class AuthController < ApplicationController
  def exchange_token
    if params[:error].blank?
      handle_token_exchange(params[:code])
    else
      # Error returned from Strava side. E.g. user clicked 'Cancel' and didn't authorize.
      # Log it and redirect back to homepage.
      Rails.logger.warn("Exchanging token failed. params[:error]: #{params[:error].inspect}.")
    end

    redirect_to root_path
  end

  def deauthorize
    unless cookies.signed[:access_token].nil?

      # Delete all data.
      athlete = Athlete.find_by_access_token(cookies.signed[:access_token])
      unless athlete.nil?
        athlete_id = athlete.id
        Rails.logger.warn("Deauthrozing and destroying all data for athlete #{athlete_id}.")
        BestEffort.where(athlete_id: athlete_id).destroy_all
        Race.where(athlete_id: athlete_id).destroy_all
        Gear.where(athlete_id: athlete_id).destroy_all
        HeartRateZones.where(athlete_id: athlete_id).destroy_all
        Activity.where(athlete_id: athlete_id).destroy_all
        AthleteInfo.where(athlete_id: athlete_id).destroy_all
        Subscription.where(athlete_id: athlete_id).update_all(is_deleted: true)
        Athlete.where(id: athlete_id).destroy_all
      end

      # Revoke Strava access.
      uri = URI(STRAVA_API_AUTH_DEAUTHORIZE_URL)
      response = Net::HTTP.post_form(uri, 'access_token' => cookies.signed[:access_token])
      if response.is_a? Net::HTTPSuccess
        Rails.logger.info("Revoked Strava access for athlete (access_token=#{cookies.signed[:access_token]}).")
      else
        # Fail to revoke Strava access. Log it and don't throw.
        Rails.logger.error("Revoking Strava access failed. HTTP Status Code: #{response.code}. Response Message: #{response.message}") # rubocop:disable LineLength
      end
    end

    # Log the user out.
    logout
  end

  def logout
    cookies.delete(:access_token)
    redirect_to root_path
  end

  private

  def handle_token_exchange(code) # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity, PerceivedComplexity
    response = Net::HTTP.post_form(
      URI(STRAVA_API_AUTH_TOKEN_URL),
      'code' => code,
      'client_id' => STRAVA_API_CLIENT_ID,
      'client_secret' => ENV['STRAVA_API_CLIENT_SECRET']
    )

    if response.is_a? Net::HTTPSuccess
      result = JSON.parse(response.body)
      access_token = result['access_token']
      athlete = ::Creators::AthleteCreator.create_or_update(access_token, result['athlete'], false)
      ::Creators::HeartRateZonesCreator.create_or_update(result['athlete']['id']) # Create default heart rate zones.

      if ENV['ENABLE_EARLY_BIRDS_PRO_ON_LOGIN'] == 'true'
        # Automatically apply 'Early Birds PRO' Plan on login for everyone for now.
        athlete = athlete.decorate
        begin
          unless athlete.pro_subscription?
            ::Creators::SubscriptionCreator.create('Early Birds PRO', athlete.id)
          end
        rescue StandardError => e
          Rails.logger.error("Automatically applying 'Early Birds PRO' failed for athlete '#{athlete.id}'. "\
            "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        end
      end

      if ENV['ENABLE_OLD_MATES_PRO_ON_LOGIN'] == 'true'
        begin
          athlete = athlete.decorate
          is_old_mate = athlete.last_active_at.blank? || athlete.last_active_at.to_date < Date.today - 180.days
          if !athlete.pro_subscription? && is_old_mate
            ::Creators::SubscriptionCreator.create('Old Mates PRO', athlete.id)
          end
        rescue StandardError => e
          Rails.logger.error("Automatically applying 'Old Mates PRO' failed for athlete '#{athlete.id}'. "\
            "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        end
      end

      # Subsribe or update to mailing list.
      SubscribeToMailingListJob.perform_later(athlete)

      # Add a delayed_job to fetch data for this athlete.
      fetcher = ::ActivityFetcher.new(access_token)
      fetcher.delay.fetch_all

      # Encrypt and set access_token in cookies.
      cookies.signed[:access_token] = { value: access_token, expires: Time.now + 7.days }
      return
    end

    response_body = response.nil? || response.body.blank? ? '' : "\nResponse Body: #{response.body}"
    raise ActionController::BadRequest, "Bad request while exchanging token with Strava.#{response_body}" if response.code == '400' # rubocop:disable LineLength
    raise "Exchanging token failed. HTTP Status Code: #{response.code}.#{response_body}"
  end
end

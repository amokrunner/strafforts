module Api
  class RacesController < ApplicationController
    def index
      athlete = Athlete.find_by_id_or_username(params[:id_or_username])
      ApplicationController.raise_athlete_not_found_error(params[:id_or_username]) if athlete.nil?

      heart_rate_zones = ApplicationHelper::Helper.get_heart_rate_zones(athlete.id)
      if params[:distance_or_year].blank?
        items = Race.find_all_by_athlete_id(athlete.id)
        shaped_items = ApplicationHelper::Helper.shape_races(items, heart_rate_zones, athlete.measurement_preference)
        @races = RacesDecorator.new(shaped_items)
        @races = @races.to_show_in_overview
        render json: @races
      elsif params[:distance_or_year] =~ /^20\d\d$/
        year = params[:distance_or_year]
        items = Race.find_all_by_athlete_id_and_year(athlete.id, year)
        shaped_items = ApplicationHelper::Helper.shape_races(items, heart_rate_zones, athlete.measurement_preference)
        render json: shaped_items
      else
        # Get race distance from distance_or_year parameter.
        # 'Half Marathon' is passed in as half-marathon
        # as defined in createView method in athletes/races.js, revert back when before searching here.
        distance = params[:distance_or_year].tr('|', '/').tr('-', ' ')
        race_distance = RaceDistance.find_by_name(distance)
        ApplicationController.raise_item_not_found_error('race distance', distance) if race_distance.nil?

        items = Race.find_all_by_athlete_id_and_race_distance_id(athlete.id, race_distance.id)
        shaped_items = ApplicationHelper::Helper.shape_races(items, heart_rate_zones, athlete.measurement_preference)
        render json: shaped_items
      end
    end
  end
end

module Api
  class BestEffortsController < ApplicationController
    def index
      athlete = Athlete.find_by(id: params[:id])
      ApplicationController.raise_athlete_not_found_error(params[:id]) if athlete.nil?

      heart_rate_zones = ApplicationHelper::Helper.get_heart_rate_zones(athlete.id)

      results = []
      unless params[:distance].blank?
        # '1/2 mile' is passed in as 1_2-mile, 'Half Marathon' is passed in as half-marathon
        # as defined in createView method in app/assets/javascripts/athletes/views/navigationSidebar.ts.
        distance = params[:distance].tr('_', '/').tr('-', ' ')
        best_effort_type = BestEffortType.find_by_name(distance)
        ApplicationController.raise_item_not_found_error('best effort type', distance) if best_effort_type.nil?

        items = BestEffort.find_top_by_athlete_id_and_best_effort_type_id(
          athlete.id, best_effort_type.id, BEST_EFFORTS_LIMIT
        )
        results = ApplicationHelper::Helper.shape_best_efforts(
          items, heart_rate_zones, athlete.athlete_info.measurement_preference
        )
      end

      render json: results
    end
  end
end

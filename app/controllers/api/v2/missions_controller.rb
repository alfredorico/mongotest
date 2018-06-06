# TODO: separtate admin & client API
module Api::V2
  class MissionsController < ApplicationController

    before_action :set_missions,                only: [:index, :batch_delete]
    before_action :sort_by_lat_long,            only: [:index], if: Proc.new {params[:lat].present? and params[:long].present?}
    before_action :sort_by_update_at,           only: [:index], unless: Proc.new {params[:lat].present? or params[:long].present?}
    before_action :limit,                       only: [:index], if: Proc.new {params[:limit].present?}
    before_action :missions_in_campains, only: [:agregacion], if: Proc.new {
      params[:missions_in_campains].present? and
      params[:missions_in_campains].to_s == 'true' and
      params[:lat].present? and
      params[:long].present?
    }
    def index
      render json: @missions
    end

    def agregacion
      render json: @missions_in_campains
    end

    def missions_in_campains
        @missions_in_campains = Mission.collection.aggregate([
          {
            '$geoNear': {
              near: { type: "Point", coordinates: [params['long'].to_f, params['lat'].to_f] },
              distanceField: "dist.calculated",
              spherical: false,
              query: { published: true },
              maxDistance: 2150000,
              limit: 100000 # To get all missions
            }
          },
          {
          '$project': {
              id: "$_id",
              campain_id: "$campain_id",
              name: "$name",
              builder_id: "$builder_id",
              public_name: "$public_name",
              title: "$title",
              amount: "$amount",
              reward_points: "$reward_points",
              level: "$level",
              state: "$state",
              logo: "$logo",
              address_street: "$address_street",
              # is_clone: "$is_clone",
              schedule: "$schedule",
              campain_type: "$campain_type",
              need_toc_validation: "$need_toc_validation",
              home_check: "$home_check",
              record_audio: "$record_audio",
              headquarter_name: "$headquarter_name",
              # created_at: "$created_at",
              # updated_at: "$updated_at",
              # end_date_time: "$end_date_time",
              # start_date_time: "$start_date_time",
              completed_date_time: "$completed_date_time",
              scheduled_for_today: "$scheduled_for_today",
              # has_required_level: "$has_required_level",
              location: "$location"
            }
          },
          { '$group':
            { _id: "$campain_id",
              missions: {
                '$push': {
                  id: "$id",
                  campain_id: "$campain_id",
                  name: "$name",
                  builder_id: "$builder_id",
                  public_name: "$public_name",
                  title: "$title",
                  amount: "$amount",
                  reward_points: "$reward_points",
                  level: "$level",
                  state: "$state",
                  logo: "$logo",
                  address_street: "$address_street",
                  # is_clone: "$is_clone",
                  schedule: "$schedule",
                  campain_type: "$campain_type",
                  need_toc_validation: "$need_toc_validation",
                  home_check: "$home_check",
                  record_audio: "$record_audio",
                  headquarter_name: "$headquarter_name",
                  # created_at: "$created_at",
                  # updated_at: "$updated_at",
                  # end_date_time: "$end_date_time",
                  # start_date_time: "$start_date_time",
                  completed_date_time: "$completed_date_time",
                  scheduled_for_today: "$scheduled_for_today",
                  location: "$location"
                }
              }
            }
          },
          { '$project': {
              _id: 0,
              campain_id: "$_id",
              missions:{'$slice':["$missions", 3]}
            }
          }
        ]).to_a      
    end
 
    private
    def set_missions
      @missions = Mission.all
    end

    def sort_by_lat_long
      @missions = @missions.where(:location.near_sphere => [@long, @lat]) if @lat and @long
    end

    def limit
      @missions = @missions.limit(params[:limit].to_i)
    end

  end
end

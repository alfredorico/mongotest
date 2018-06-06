class Mission


  ## INCLUDES
  include Mongoid::Document
  include Mongoid::Geospatial
  include Mongoid::Timestamps
  
  # history tracking all Mission documents
  # note: tracking will not work until #track_history is invoked
  # include PublicActivity::Model


  ## ATTRIBUTES
  field :name,                      type: String
  field :public_name,               type: String
  field :title,                     type: String
  field :logo,                      type: String
  field :video,                     type: String
  field :email_notification_status, type: String
  field :instructions,              type: String
  field :campain_type,              type: String
  field :campain_scope,             type: String
  field :shopper_comment,           type: String
  field :headquarter_name,          type: String
  field :address_street,            type: String
  field :shopper_name,              type: String
  field :disapprove_comment,        type: String
  field :launch_type,               type: String
  field :form_id,                   type: String
  field :builder_id,                type: String
  field :firebase_mame,             type: String
  field :cloned_mission_id,         type: String
  field :additional_instruction,    type: String
  field :home_check_type,           type: String
  field :toc_selfie,                type: String
  field :toc_face_vs_face_status,   type: String
  field :toc_biometric_result,      type: String
  field :start_date_time,           type: DateTime
  field :end_date_time,             type: DateTime
  field :approved_at,               type: DateTime
  field :taken_at,                  type: DateTime
  field :update_state_at,           type: DateTime
  field :started_date_time,         type: DateTime
  field :completed_date_time,       type: DateTime
  field :campain_id,                type: Integer
  field :company_id,                type: Integer
  field :address_id,                type: Integer
  field :order_id,                  type: Integer
  field :form_builder_id,           type: Integer
  field :headquarter_id,            type: Integer
  field :admin_user_id,             type: Integer
  field :minutes_to_release,        type: Integer
  field :minutes_to_complete,       type: Integer
  field :assignation_period,        type: Integer
  field :reschedule_times,          type: Integer
  field :amount,                    type: Integer
  field :approver_id,               type: Integer # admin_user id
  field :reward_points,             type: Integer, default: 100
  field :approver_id,               type: Integer # admin_user id
  field :radio_allowed_to_take,     type: Integer
  field :owner_client_id,           type: Integer # client.id
  field :is_rocketpin,              type: Boolean, default: false
  field :is_clone,                  type: Boolean, default: false
  field :was_transferred,           type: Boolean, default: false
  field :taken_by_admin,            type: Boolean, default: false
  field :show_in_report,            type: Boolean, default: true
  field :record_audio,              type: Boolean, default: false
  field :need_toc_validation,       type: Boolean, default: false
  field :published,                 type: Boolean, default: false
  field :need_authorization,        type: Boolean
  field :need_validation,           type: Boolean
  field :capture_coordenates,       type: Boolean
  field :home_check,                type: Boolean
  field :level,                     type: Hash
  field :start_coords,              type: Hash
  field :end_coords,                type: Hash
  field :description,               type: Hash
  field :collecting_limit,          type: Hash
  field :dependency,                type: Hash
  field :schedule,                  type: Date
  field :period,                    type: Date
  field :location,                  type: Point, sphere: true
  field :score,                     type: Float, default: 0
  field :home_check_approve_detail, type: String

  ## SCOPES
  scope :inside_date_range, -> {where(:start_date_time.lte => DateTime.now, :end_date_time.gte => DateTime.now)}
  scope :inside_complete_date_range, -> (start_date, end_date) {where(:completed_date_time.lte => end_date, :completed_date_time.gte => start_date)}
  scope :inside_current_day, -> {where(:update_state_at.gt => DateTime.now.beginning_of_day)}
  scope :by_campain_ids, -> (ids) {where(campain_id: { :$in => ids }, campain_type: 'Campain')}
  scope :by_corporate_campain_ids, -> (ids) {where(campain_id: { :$in => ids }, campain_type: 'Corporate::Campain')}
  scope :when_types, lambda {|*states| where(:campain_type => {'$in' => states.map{|s| s.to_s.camelize}})}
  scope :with_open_postulations, -> {where(state: :collecting_stakeholders)}
  scope :dependents_of, -> (campain) {where('dependency.target_id' => campain.id, 'dependency.target_type' => campain.class.to_s)}

  sphere_index :location

  ## ENUMERIZE
  extend Enumerize
  enumerize :campain_type, in: [:geo, :scout, :survey], default: :geo, scope: true
  enumerize :campain_scope, in: [:default, :corporate], default: :default, scope: true
  enumerize :launch_type, in: [:immediately, :scheduled_auto_mapping, :scheduled_authorized, :scheduled_manual, :collecting_stakeholders], scope: true
  enumerize :email_notification_status, in: [:pending, :se1nd], default: :pending, scope: true
  enumerize :home_check_approve_detail, in: [:verified, :sms_verified, :no_address, :no_meeting], scope: true


end

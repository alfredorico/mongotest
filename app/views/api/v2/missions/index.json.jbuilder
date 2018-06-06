json.array!(@missions) do |mission|
  json.id mission._id.to_s
  json.extract! mission, :campain_id, :name, :builder_id, :public_name, :title, :amount, :reward_points, :level, :state, :logo, :is_clone, :schedule, :campain_type, :need_toc_validation, :home_check, :record_audio
end

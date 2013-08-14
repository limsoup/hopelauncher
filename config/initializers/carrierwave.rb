CarrierWave.configure do |config|
	config.fog_credentials = {
		:provider => 'AWS',
		:aws_access_key_id => CONFIG[:AWS_ACCESS_KEY_ID],
		:aws_secret_access_key  => CONFIG[:AWS_SECRET_ACCESS_KEY],
	}
  config.fog_directory  = CONFIG[:AWS_BUCKET_NAME]
  config.fog_public     = false 
end
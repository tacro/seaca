class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  process :convert => 'jpg'

  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Choose what kind of storage to use for this uploader:
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
     "avatars/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    "/avatars/default_icon.png"
  end


  # Create different versions of your uploaded files:
  version :standard do
    process :resize_to_limit => [700,700]
  end
  version :thumb do
    process :resize_to_limit => [300, 300]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
   "#{secure_token}.jpg" if original_filename.present?
  end

 protected
 def secure_token
   var = :"@#{mounted_as}_secure_token"
   model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
 end
end

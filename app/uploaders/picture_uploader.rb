class PictureUploader < CarrierWave::Uploader::Base

  #
  #
  #
  # Resizing images using '/usr/bin/convert'
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 400]

  #
  #
  #
  # Storage
  #
  # Production
  if Rails.env.production?
    storage :fog
  #
  # Development
  else
    storage :file
  end

  #
  #
  #
  # Storing Directory
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  #
  #
  #
  # Allowed Image Extensions
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end


end

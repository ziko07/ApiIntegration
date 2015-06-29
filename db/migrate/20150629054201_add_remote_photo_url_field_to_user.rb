class AddRemotePhotoUrlFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :remote_photo_url, :string
  end
end

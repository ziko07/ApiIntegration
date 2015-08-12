class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable
  devise :omniauthable
  mount_uploader :image, ImageUploader

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        puts(auth.inspect)
        user = User.create(:name => auth.info.name,
                           :remote_photo_url => auth.info.image,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email => auth.info.email,
                           :password => Devise.friendly_token[0,20] )
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        puts(data.inspect)
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        user = User.create(
                           :provider => access_token.provider,
                           :email => data["email"],
                           :remote_photo_url => data["image"],
                           :uid => access_token.uid ,
                           :password => Devise.friendly_token[0,20]
        )
      end
    end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        puts(auth.inspect)
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        user = User.create(provider:auth.provider,
                           uid:auth.uid,
                           email:auth.uid+"@twitter.com",
                           password:Devise.friendly_token[0,20]
        )
      end
    end
  end
end



module WelcomeHelper

  def get_photo(user_id)
    @user = User.find_by_id(user_id)
    if(@user.provider?)
      if(@user.remote_photo_url?)
        @user.remote_photo_url
      else
        'default_user_icon.png'
      end

    else
      if(@user.image?)
        @user.image_url('small')
      else
        'default_user_icon.png'
      end
    end
  end
end

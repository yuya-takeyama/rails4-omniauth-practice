class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def facebook_user
    if facebook_token
      user = ::FbGraph::User.me(facebook_token)

      if user
        user.fetch
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(:facebook_id => auth.uid).first

    unless user
      user = User.create(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        facebook_id: auth.uid,
        facebook_token: auth.credentials.token,
      )
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end

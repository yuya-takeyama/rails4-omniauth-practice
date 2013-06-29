class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :reviews

  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :name, :case_sensitive => false

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

    if user
      user.facebook_token = auth.credentials.token
      user.save
    else
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

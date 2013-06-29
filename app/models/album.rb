class Album < ActiveRecord::Base
  has_many :album_artists
  has_many :artists, :through => :album_artists
  has_many :reviews
end

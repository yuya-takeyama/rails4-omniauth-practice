class Album < ActiveRecord::Base
  has_many :album_artists
end

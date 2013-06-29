class Artist < ActiveRecord::Base
  has_many :album_artists
end

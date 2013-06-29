class AddUniqueIndexForAlbumArtists < ActiveRecord::Migration
  def up
    add_index :album_artists, :album_id, :artist_id, :unique => true
  end

  def down
    remove_index :album_artists, :album_id, :artist_id
  end
end

class Poster < ApplicationRecord
  belongs_to :film

  def url
    'https://image.tmdb.org/t/p/w500/15uOEfqBNTVtDUT7hGBVCka0rZz.jpg'
  end
end

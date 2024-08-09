# frozen_string_literal: true

require 'csv'

module FilmData
  # # Film Locations in San Francisco
  #
  # Class FilmLocationsInSanFrancisco represents each row in the data set.
  class FilmLocationsInSanFrancisco
    HEADERS = ['Title',
               'Release Year',
               'Locations',
               'Fun Facts',
               'Production Company',
               'Distributor',
               'Director',
               'Writer',
               'Actor 1', 'Actor 2', 'Actor 3',
               'SF Find Neighborhoods',
               'Analysis Neighborhoods',
               'Current Supervisor Districts'].freeze

    ATTRIBUTE_MAPS = { 'Locations' => 'location',
                       'SF Find Neighborhoods' => 'find_neighborhood_id',
                       'Analysis Neighborhoods' => 'analysis_neighborhood_id',
                       'Current Supervisor Districts' => 'supervisor_district_id' }.freeze

    def self.all
      Rails.root.join('lib/film_data/Film_Locations_in_San_Francisco.csv').open do |file|
        CSV.read(file, headers: true).map { |row| new(row) }
      end
    end

    def initialize(row)
      @data = row.to_h
    end

    (HEADERS - ['Director', 'Writer', 'Actor 1', 'Actor 2', 'Actor 3']).each do |name|
      attribute_name = ATTRIBUTE_MAPS.fetch(name, name.parameterize.underscore)
      define_method(attribute_name) do
        @data[name]
      end
    end

    def directors
      name_parser(@data['Director'])
    end

    def writers
      name_parser(@data['Writer'])
    end

    def actors
      @data.slice('Actor 1', 'Actor 2', 'Actor 3').values.compact
    end

    private

    def name_parser(names)
      names = Array.wrap(names)
      [',', ' and ', '/', '&'].each do |separator|
        names = names.flat_map do |segment|
          segment.include?(separator) ? segment.split(separator).map(&:strip) : segment
        end
      end
      names
    end
  end
end

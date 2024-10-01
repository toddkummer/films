# frozen_string_literal: true

require 'test_helper'

module FilmData
  class FilmLocationsInSanFranciscoTest < ActiveSupport::TestCase
    CSV_ROW = ['Vertigo',
               1958,
               '1007 Gough Street',
               "Tennis courts now sit on the site; in the movie the structure was Carlota Valdes' home.",
               'Alfred J. Hitchcock Productions',
               'Paramount Pictures',
               'Alfred Hitchcock',
               'Alec Coppel',
               'James Stewart',
               'Kim Novak',
               'Barbara Bel Geddes',
               100,
               39,
               11].freeze

    def setup
      row = CSV::Row.new(FilmData::FilmLocationsInSanFrancisco::HEADERS, CSV_ROW)
      @data = FilmData::FilmLocationsInSanFrancisco.new(row)
    end

    def test_title
      assert_equal 'Vertigo', @data.title
    end

    def test_release_year
      assert_equal 1958, @data.release_year
    end

    def test_location
      assert_equal '1007 Gough Street', @data.location
    end

    def test_fun_facts
      assert_equal "Tennis courts now sit on the site; in the movie the structure was Carlota Valdes' home.",
                   @data.fun_facts
    end

    def test_production_comapny
      assert_equal 'Alfred J. Hitchcock Productions', @data.production_company
    end

    def test_distributor
      assert_equal 'Paramount Pictures', @data.distributor
    end

    def test_directors
      assert_equal ['Alfred Hitchcock'], @data.directors
    end

    def test_writers
      assert_equal ['Alec Coppel'], @data.writers
    end

    def test_actors
      assert_equal ['James Stewart', 'Kim Novak', 'Barbara Bel Geddes'], @data.actors
    end

    def test_find_neighborhood
      assert_equal 100, @data.find_neighborhood_id
    end

    def test_analysis_neighborhood
      assert_equal 39, @data.analysis_neighborhood_id
    end

    def test_supervisor_district
      assert_equal 11, @data.supervisor_district_id
    end
  end

  class MultipleDirectorsTest < ActiveSupport::TestCase
    def test_comma_separated
      row = with_directors('Jamie Babbit, Amanda Brotchie, Steven K. Tsuchida, Christian Ditter, John Riggi')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.directors, 'Jamie Babbit'
      assert_includes data.directors, 'Amanda Brotchie'
      assert_includes data.directors, 'Steven K. Tsuchida'
      assert_includes data.directors, 'Christian Ditter'
      assert_includes data.directors, 'John Riggi'
      assert_equal 5, data.directors.size
    end

    def test_joined_by_and
      row = with_directors('Alexandra Cunningham and Kem Nunn')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.directors, 'Alexandra Cunningham'
      assert_includes data.directors, 'Kem Nunn'
      assert_equal 2, data.directors.size
    end

    def test_with_slash
      row = with_directors('Oded Binnun/ Michel Brezis')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.directors, 'Oded Binnun'
      assert_includes data.directors, 'Michel Brezis'
      assert_equal 2, data.directors.size
    end

    private

    def with_directors(directors)
      CSV::Row.new(
        FilmData::FilmLocationsInSanFrancisco::HEADERS,
        FilmLocationsInSanFranciscoTest::CSV_ROW.dup.tap do |csv|
          csv[FilmData::FilmLocationsInSanFrancisco::HEADERS.index('Director')] = directors
        end
      )
    end
  end

  class MultipleWritersTest < ActiveSupport::TestCase
    def test_comma_separated
      row = with_writers('Michael Golamco, Randall Park, Ali Wong')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.writers, 'Michael Golamco'
      assert_includes data.writers, 'Randall Park'
      assert_includes data.writers, 'Ali Wong'
      assert_equal 3, data.writers.size
    end

    def test_joined_by_and
      row = with_writers('Alexandra Cunningham and Kem Nunn')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.writers, 'Alexandra Cunningham'
      assert_includes data.writers, 'Kem Nunn'
      assert_equal 2, data.writers.size
    end

    def test_joined_by_ampersand
      row = with_writers('Alexander Bulkley & Kelley Bulkeley')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.writers, 'Alexander Bulkley'
      assert_includes data.writers, 'Kelley Bulkeley'
      assert_equal 2, data.writers.size
    end

    def test_with_slash
      row = with_writers('Oded Binnun/ Michel Brezis')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.writers, 'Oded Binnun'
      assert_includes data.writers, 'Michel Brezis'
      assert_equal 2, data.writers.size
    end

    def test_ampersand_and_commas
      row = with_writers('Brian Koppelman & David Levien, Sarah Acosta, Stephen Schiff')
      data = FilmData::FilmLocationsInSanFrancisco.new(row)
      assert_includes data.writers, 'Brian Koppelman'
      assert_includes data.writers, 'David Levien'
      assert_includes data.writers, 'Sarah Acosta'
      assert_includes data.writers, 'Stephen Schiff'
      assert_equal 4, data.writers.size, data.writers
    end

    private

    def with_writers(writers)
      CSV::Row.new(
        FilmData::FilmLocationsInSanFrancisco::HEADERS,
        FilmLocationsInSanFranciscoTest::CSV_ROW.dup.tap do |csv|
          csv[FilmData::FilmLocationsInSanFrancisco::HEADERS.index('Writer')] = writers
        end
      )
    end
  end
end

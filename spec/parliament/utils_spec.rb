require_relative '../spec_helper'

describe Parliament::Utils, vcr: true do
  describe '#sort_by' do
    context 'all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName)

        expect(sorted_response.first.personGivenName).to eq('Jane')
      end

      it 'returns a response sorted by seatIncumbencyStartDate' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people('2c196540-13f3-4c07-8714-b356912beceb').get
        filtered_response = response.filter('http://id.ukpds.org/schema/SeatIncumbency')
        sorted_response = filtered_response.sort_by(:start_date)

        expect(sorted_response.first.start_date).to eq(DateTime.new(1987, 6, 11))
        expect(sorted_response[1].start_date).to eq(DateTime.new(1992, 4, 9))
      end
    end

    context 'not all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        filtered_response = response.filter('http://id.ukpds.org/schema/Person')
        sorted_response = filtered_response.sort_by(:given_name)

        expect(sorted_response.first.given_name).to eq('')
        expect(sorted_response[1].given_name).to eq('Alice')
      end

      it 'returns a response sorted by end_date (it can handle nil values)' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::Utils.sort_by({
                                                          list: person.incumbencies,
                                                          parameters: [:end_date],
                                                          prepend_rejected: false
                                                        })

        expect(sorted_incumbencies.last.end_date).to eq(nil)
        expect(sorted_incumbencies[sorted_incumbencies.length - 2].end_date).to eq(DateTime.new(2015, 3, 30))
      end

      it 'uses the prepend_rejected parameter correctly - defaults to true so nil values will be at the start' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::Utils.sort_by({
                                                            list: person.incumbencies,
                                                            parameters: [:end_date]
                                                        })

        expect(sorted_incumbencies.first.end_date).to be(nil)
      end

      it 'uses the prepend_rejected parameter correctly - when set to false the nil values will be at the end' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::Utils.sort_by({
                                                            list: person.incumbencies,
                                                            parameters: [:end_date],
                                                            prepend_rejected: false
                                                        })

        expect(sorted_incumbencies.last.end_date).to be(nil)
      end
    end

    context 'sorting by multiple parameters' do
      it 'returns a response sorted by personFamilyName, then personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName, :personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Rebecca')
        expect(sorted_response[1].personGivenName).to eq('Sarah')
      end
    end

    context 'sorting strings of different cases' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName)

        expect(sorted_response.first.personGivenName).to eq('Jane')
        expect(sorted_response[1].personGivenName).to eq('Alice')
      end
    end

    context 'sorting strings with accents' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Sarah')
        expect(sorted_response[1].personGivenName).to eq('Sóley')
        expect(sorted_response[2].personGivenName).to eq('Solomon')
      end

      it 'returns a response sorted by personFamilyName, personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName, :personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Solomon')
        expect(sorted_response[1].personGivenName).to eq('Sophie')
        expect(sorted_response[2].personGivenName).to eq('Sarah')
      end
    end
  end

  describe '#reverse_sort_by' do
    it 'returns a response sorted by incumbencyStartDate' do
      response = Parliament::Request.new(base_url: 'http://localhost:3030').people('2c196540-13f3-4c07-8714-b356912beceb').get
      filtered_response = response.filter('http://id.ukpds.org/schema/SeatIncumbency')
      sorted_response = filtered_response.reverse_sort_by(:start_date)

      expect(sorted_response[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(sorted_response[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'returns a response sorted by end_date (it can handle nil values)' do
      response = Parliament::Request.new(base_url: 'http://localhost:3030').people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
      person = response.filter('http://id.ukpds.org/schema/Person').first

      sorted_incumbencies = Parliament::Utils.sort_by({
                                                          list: person.incumbencies,
                                                          parameters: [:end_date],
                                                          prepend_rejected: false
                                                      })

      expect(sorted_incumbencies.last.end_date).to be(nil)
      expect(sorted_incumbencies[sorted_incumbencies.length - 2].end_date).to eq(DateTime.new(2015, 3, 30))
    end
  end
end
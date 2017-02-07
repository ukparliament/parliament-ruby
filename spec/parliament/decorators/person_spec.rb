require_relative '../../spec_helper'

describe Parliament::Decorators::Person, vcr: true do
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get }

  describe '#houses' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.houses.size).to eq(1)
        expect(person_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has no houses' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.houses).to eq([])
      end
    end
  end

  describe '#seat_incumbencies' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seat incumbencies for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.seat_incumbencies.size).to eq(5)
        expect(person_node.seat_incumbencies.first.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    context 'Grom::Node has no seat incumbencies' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.seat_incumbencies).to eq([])
      end
    end
  end

  describe '#seats' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seats for a Grom::Node object of type Person' do
        person_node = @people_nodes.first
        expect(person_node.seats.size).to eq(3)
        expect(person_node.seats.first.type).to eq('http://id.ukpds.org/schema/HouseSeat')
      end
    end

    context 'Grom::Node has no seats' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.seats).to eq([])
      end
    end
  end

  describe '#given_name' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the given name for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.given_name).to eq('Person 1 - givenName')
      end
    end

    context 'Grom::Node has no personGivenName' do
      it 'returns an empty string' do
        person_node = @people_nodes[1]

        expect(person_node.given_name).to eq('')
      end
    end
  end

  describe '#family_name' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the given name for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.family_name).to eq('Person 1 - familyName')
      end
    end

    context 'Grom::Node has no personGivenName' do
      it 'returns an empty string' do
        person_node = @people_nodes[1]

        expect(person_node.family_name).to eq('')
      end
    end
  end

  describe '#full_name' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the full name for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.full_name).to eq('Person 1 - givenName Person 1 - familyName')
      end
    end

    context 'Grom::Node has no personGivenName' do
      it 'returns a full name with just personFamilyName' do
        person_node = @people_nodes[1]

        expect(person_node.full_name).to eq('Person 2 - familyName')
      end
    end

    context 'Grom::Node has no personFamilyName' do
      it 'returns a full name with just personGivenName' do
        person_node = @people_nodes[1]

        expect(person_node.full_name).to eq('Person 2 - givenName')
      end
    end

    context 'Grom::Node has no personGivenName or personFamilyName' do
      it 'returns an empty string' do
        person_node = @people_nodes[1]

        expect(person_node.full_name).to eq('')
      end
    end
  end

  describe '#parties' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the parties for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.parties.size).to eq(1)
        expect(person_node.parties.first.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    context 'Grom::Node has no parties' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.parties).to eq([])
      end
    end
  end

end

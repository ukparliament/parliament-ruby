require_relative '../../spec_helper'

describe Parliament::Decorator::Person, vcr: true do
  let(:id) { '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
  let(:response) do
    Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                        builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
  end

  describe '#houses' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.houses.size).to eq(1)
        expect(person_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has all the required objects (house incumbencies)' do
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

  describe '#incumbencies' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the incumbencies for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.incumbencies.size).to eq(5)
      end
    end

    context 'Grom::Node has no incumbencies' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.incumbencies).to eq([])
      end
    end
  end

  describe '#seat_incumbencies' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
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
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seats for a Grom::Node object of type Person' do
        person_node = @people_nodes.first
        expect(person_node.seats.size).to eq(2)
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
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
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
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
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

  describe '#date_of_birth' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the date of birth for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.date_of_birth).to eq(DateTime.new(1950, 10, 17))
      end
    end

    context 'Grom::Node has no personDateOfBirth' do
      it 'returns nil' do
        person_node = @people_nodes[1]

        expect(person_node.date_of_birth).to be(nil)
      end
    end
  end

  describe '#other_name' do
    before(:each) do
      id = '08a3dfac-652a-44d6-8a43-00bb13c60e47'
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the other name for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.other_name).to eq('Person 1 - otherName')
      end
    end

    context 'Grom::Node has no personGivenName' do
      it 'returns an empty string' do
        person_node = @people_nodes[1]

        expect(person_node.other_name).to eq('')
      end
    end
  end

  describe '#full_name' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
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

  describe '#constituencies' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the parties for a Grom::Node objects of type Person' do
        person_node = @people_nodes.first

        expect(person_node.constituencies.size).to eq(3)
        expect(person_node.constituencies.first.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'Grom::Node has no constituencies' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.constituencies).to eq([])
      end
    end
  end

  describe '#parties' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
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

  describe '#party_memberships' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the party memberships for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.party_memberships.size).to eq(2)
        expect(person_node.party_memberships.first.type).to eq('http://id.ukpds.org/schema/PartyMembership')
      end
    end

    context 'Grom::Node has no party memberships' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.party_memberships).to eq([])
      end
    end
  end

  describe '#contact_points' do
    before(:each) do
      id = '08a3dfac-652a-44d6-8a43-00bb13c60e47'
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
      @people_with_contact_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the contact points for a Grom::Node object of type Person' do
        person_node = @people_with_contact_nodes.first

        expect(person_node.contact_points.size).to eq(1)
        expect(person_node.contact_points.first.type).to eq('http://id.ukpds.org/schema/ContactPoint')
      end
    end

    context 'Grom::Node has no contact points' do
      it 'returns an empty array' do
        person_node = @people_with_contact_nodes[1]

        expect(person_node.contact_points).to eq([])
      end
    end
  end

  describe '#gender_identities' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the contact points for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.gender_identities.size).to eq(1)
        expect(person_node.gender_identities.first.type).to eq('http://id.ukpds.org/schema/GenderIdentity')
      end
    end

    context 'Grom::Node has no gender identities' do
      it 'returns an empty array' do
        person_node = @people_nodes[1]

        expect(person_node.gender_identities).to eq([])
      end
    end
  end

  describe '#gender' do
    before(:each) do
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the gender for a Grom::Node object of type Person' do
        person_node = @people_nodes.first

        expect(person_node.gender.genderName).to eq('F')
        expect(person_node.gender.type).to eq('http://id.ukpds.org/schema/Gender')
      end
    end

    context 'Grom::Node has no gender' do
      it 'returns nil' do
        person_node = @people_nodes[1]

        expect(person_node.gender).to be(nil)
      end
    end
  end

  describe '#statuses' do
    context 'Grom::Node has a current seat incumbency' do
      it 'returns the status Current MP' do
        id = '1921fc4a-6867-48fa-a4f4-6df05be005ce'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:house_membership_status].size).to eq(1)
        expect(person_node.statuses[:house_membership_status].first).to eq('Current MP')
      end
    end

    context 'Grom::Node has a current house incumbency' do
      it 'returns the status Current Lord' do
        id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:house_membership_status].size).to eq(1)
        expect(person_node.statuses[:house_membership_status].first).to eq('Lord')
      end
    end

    context 'Grom::Node has a current incumbency' do
      it 'returns the status Current Member' do
        id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:general_membership_status].size).to eq(1)
        expect(person_node.statuses[:general_membership_status].first).to eq('Current Member')
      end
    end

    context 'Grom::Node has no current incumbency' do
      it 'returns the status Former Member' do
        id = '5fe4df31-fa20-40cc-8cf2-f9d731e0be91'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:general_membership_status].size).to eq(1)
        expect(person_node.statuses[:general_membership_status].first).to eq('Former Member')
      end
    end

    context 'Grom::Node has seat incumbencies but no current seat incumbency' do
      it 'returns the status Former MP' do
        id = '5fe4df31-fa20-40cc-8cf2-f9d731e0be91'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:house_membership_status].size).to eq(1)
        expect(person_node.statuses[:house_membership_status].first).to eq('Former MP')
      end
    end

    context 'Grom::Node has house incumbencies but no current house incumbency' do
      it 'returns the status Former Lord' do
        id = '99ceb32e-2e16-42a0-904d-c6a7e3a9f217'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:house_membership_status].size).to eq(1)
        expect(person_node.statuses[:house_membership_status].first).to eq('Former Lord')
      end
    end

    context 'Grom::Node has seat incumbencies and a current house incumbency' do
      it 'returns the statuses Former MP and Current Lord' do
        id = '7c511a2b-9ce2-4001-8ee5-71ae734c52d6'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses.size).to eq(2)
        expect(person_node.statuses[:house_membership_status][0]).to eq('Lord')
        expect(person_node.statuses[:house_membership_status][1]).to eq('Former MP')
      end
    end

    context 'Grom::Node has house incumbencies and seat incumbencies but no current incumbency' do
      it 'returns the statuses Former Lord and Former MP' do
        id = '90558d1f-ea34-4c44-b3ad-ed9c98a557d1'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses.size).to eq(2)
        expect(person_node.statuses[:house_membership_status][0]).to eq('Former Lord')
        expect(person_node.statuses[:house_membership_status][1]).to eq('Former MP')
      end
    end

    context 'Grom::Node has no membership data' do
      it 'returns an empty array' do
        id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
        person_node = response.filter('http://id.ukpds.org/schema/Person').first

        expect(person_node.statuses[:house_membership_status]).to eq([])
      end
    end
  end

  describe '#full_title' do
    before(:each) do
      id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
      @person_node = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the given full_title for a Grom::Node objects of type Person' do
        expect(@person_node.full_title).to eq('Person - fullTitle')
      end
    end

    context 'Grom::Node has no fullTitle' do
      it 'returns an empty string' do
        expect(@person_node.full_title).to eq('')
      end
    end
  end

  describe '#display_name' do
    before(:each) do
      id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder).people(id).get
      @person_node = response.filter('http://id.ukpds.org/schema/Person').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the given display_name for a Grom::Node objects of type Person' do
        expect(@person_node.display_name).to eq('Person - displayAs')
      end
    end

    context 'Grom::Node has no displayAs' do
      it 'returns the full_name' do
        expect(@person_node.display_name).to eq('Person - givenName Person - familyName')
      end
    end
  end

  describe '#sort_name' do
    before(:each) do
      id = '841a4a1f-965a-4009-8cbc-dfc9e350fe0e'
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder).people.get
      @people_nodes = response.filter('http://id.ukpds.org/schema/Person')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the given sort_name for a Grom::Node objects of type Person' do
        expect(@people_nodes.first.sort_name).to eq('Person 1 - listAs')
      end
    end

    context 'Grom::Node has no listAs' do
      it 'returns an empty string' do
        expect(@people_nodes.first.sort_name).to eq('')
      end
    end
  end
end

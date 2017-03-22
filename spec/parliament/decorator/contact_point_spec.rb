require_relative '../../spec_helper'

describe Parliament::Decorator::ContactPoint, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('08a3dfac-652a-44d6-8a43-00bb13c60e47').get
  end

  before(:each) do
    @contact_point_nodes = response.filter('http://id.ukpds.org/schema/ContactPoint')
  end

  describe '#postal_addresses' do
    context 'Grom::Node has all the required objects' do
      it 'returns the postal addresses for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node.postal_addresses.size).to eq(1)
        expect(contact_point_node.postal_addresses.first.type).to eq('http://id.ukpds.org/schema/PostalAddress')
      end
    end

    context 'Grom::Node has no postal addresses' do
      it 'returns an empty array' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node.postal_addresses).to eq([])
      end
    end
  end

  describe '#email' do
    context 'Grom::Node has all the required objects' do
      it 'returns the email for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:email)
        expect(contact_point_node.email).to eq('person@parliament.uk')
      end
    end

    context 'Grom::Node has no email' do
      it 'returns an empty string' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node).to respond_to(:email)
        expect(contact_point_node.email).to eq('')
      end
    end
  end

  describe '#phone_number' do
    context 'Grom::Node has all the required objects' do
      it 'returns the phone number for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:phone_number)
        expect(contact_point_node.phone_number).to eq('123456789')
      end
    end

    context 'Grom::Node has no phone number' do
      it 'returns an empty string' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node).to respond_to(:phone_number)
        expect(contact_point_node.phone_number).to eq('')
      end
    end
  end

  describe '#fax_number' do
    context 'Grom::Node has all the required objects' do
      it 'returns the fax number for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:fax_number)
        expect(contact_point_node.fax_number).to eq('123456789')
      end
    end

    context 'Grom::Node has no fax number' do
      it 'returns an empty string' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node).to respond_to(:fax_number)
        expect(contact_point_node.fax_number).to eq('')
      end
    end
  end

  describe '#person' do
    context 'Grom::Node has all the required objects' do
      it 'returns the object of type Person for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:person)
        expect(contact_point_node.person.first.type).to eq('http://id.ukpds.org/schema/Person')
        expect(contact_point_node.person.first.given_name).to eq('given')
        expect(contact_point_node.person.first.family_name).to eq('family')
      end
    end

    context 'Grom::Node has no person associated with it' do
      it 'returns an empty string' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node).to respond_to(:person)
        expect(contact_point_node.person.size).to eq(0)
      end
    end
  end

  describe '#incumbency' do
    context 'Grom::Node has all the required objects' do
      it 'returns the object of type Incumbency for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:incumbency)
        expect(contact_point_node.incumbency.type).to eq('http://id.ukpds.org/schema/Incumbency')
      end
    end

    context 'Grom::Node has no incumbency associated with it' do
      it 'returns nil' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node).to respond_to(:incumbency)
        expect(contact_point_node.incumbency).to be(nil)
      end
    end
  end
end

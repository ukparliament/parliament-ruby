module Parliament
  # Decorator namespace
  module Decorator
    require_relative '../parliament/decorator/constituency_area'
    require_relative '../parliament/decorator/constituency_group'

    require_relative '../parliament/decorator/contact_point'

    require_relative '../parliament/decorator/gender'
    require_relative '../parliament/decorator/gender_identity'

    require_relative '../parliament/decorator/house'
    require_relative '../parliament/decorator/house_incumbency'
    require_relative '../parliament/decorator/house_seat'

    require_relative '../parliament/decorator/incumbency'

    require_relative '../parliament/decorator/party'
    require_relative '../parliament/decorator/party_membership'

    require_relative '../parliament/decorator/person'

    require_relative '../parliament/decorator/postal_address'

    require_relative '../parliament/decorator/seat_incumbency'
  end
end

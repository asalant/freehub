class ServiceType
  attr_reader :id, :name, :description

  def initialize(id, name, description)
    @id, @name, @description = id, name, description
  end
  
  TYPES = [
            ServiceType.new('MEMBERSHIP', "Membership", "Membership for this shop."),
            ServiceType.new('EAB', "Earn a Bike/Digging Rights", "One of everything you can find in the shop to build or fix one bike."),
            ServiceType.new('CLASS', "Class", "Membership for this shop.")
          ]

  def self.[](id)
    TYPES.select{|type| type.id == id.to_s.upcase }.first
  end

  def self.find_all
    TYPES
  end

end

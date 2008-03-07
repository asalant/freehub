class Report
  attr_accessor :target, :date_from, :date_to

  def initialize(params)
    params.each { |key,value| self.send("#{key}=", value) }
  end
end

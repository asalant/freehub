module Legacy
  class Operation < ActiveRecord::Base
  end
  
  class OperationDate < ActiveRecord::Base
    belongs_to :operation
    has_many :visits
    has_many :people, :through => :visits
  end
  
  class Person < ActiveRecord::Base
    has_many :visits
  end
  
  class Visit < ActiveRecord::Base
    belongs_to :person
    belongs_to :operation_date

    TYPES = %w{Patron Staff EAB}
  end
end
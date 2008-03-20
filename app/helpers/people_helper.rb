module PeopleHelper

  def person_form_fields(form)
    markaby do
      labeled_input 'First name', :for => :first_name do
        form.text_field :first_name
      end
      labeled_input 'Last name', :for => :last_name do
        form.text_field :last_name
      end
      labeled_input 'Email', :for => :email do
        form.text_field :email
      end
      labeled_input 'Phone', :for => :phone do
        form.text_field :phone
      end
      labeled_input 'Street1', :for => :street1 do
        form.text_field :street1
      end
      labeled_input 'Street2', :for => :street2 do
        form.text_field :street2
      end
      labeled_input 'City', :for => :city do
        form.text_field :city
      end
      labeled_input 'State', :for => :state do
        form.text_field :state
      end
      labeled_input 'Postal code', :for => :postal_code do
        form.text_field :postal_code
      end
      labeled_input 'Country', :for => :country do
        form.text_field :country
      end
      labeled_input 'Staff', :for => :staff do
        form.check_box :staff
      end
    end
  end
  def form_for_person(person, options={}, &block)
    markaby do
      form_for person, options do |form|
        labeled_input 'First name', :for => :first_name do
          form.text_field :first_name
        end
        labeled_input 'Last name', :for => :last_name do
          form.text_field :last_name
        end
        labeled_input 'Email', :for => :email do
          form.text_field :email
        end
        labeled_input 'Phone', :for => :phone do
          form.text_field :phone
        end
        labeled_input 'Street1', :for => :street1 do
          form.text_field :street1
        end
        labeled_input 'Street2', :for => :street2 do
          form.text_field :street2
        end
        labeled_input 'City', :for => :city do
          form.text_field :city
        end
        labeled_input 'State', :for => :state do
          form.text_field :state
        end
        labeled_input 'Postal code', :for => :postal_code do
          form.text_field :postal_code
        end
        labeled_input 'Country', :for => :country do
          form.text_field :country
        end
        labeled_input 'Staff', :for => :staff do
          form.check_box :staff
        end
        text  block.call(form)
      end
    end
  end

end

namespace :db do
  namespace :legacy do
    desc 'Migrate legacy data to new Freehub'
    task :migrate => :environment do
      require 'legacy_models'

      [Legacy::Operation, Legacy::OperationDate, Legacy::Person, Legacy::Visit].each do |model_class|
        model_class.establish_connection(
         :adapter  => "mysql",
         :host     => "127.0.0.1",
         :username => "root",
         :password => "",
         :database => "freehub_legacy"
       )
      end

      TzTime.zone = TimeZone[ENV['TIMEZONE_DEFAULT']]
      User.current_user = User.find_by_login 'sfbk'
      sfbk = Organization.find_by_key('sfbk')

      legacy_person_ids_to_new_person_ids = {}
      Person.transaction do
        Note.delete_all
        Visit.delete_all
        Service.delete_all
        Person.delete_all

        puts "Migrating people"
        Legacy::Person.find(:all).each do |old_person|
          print "."
          new_person = Person.new(:organization => sfbk)
          [:first_name, :last_name, :email, :phone,:city, :state].each do |attribute|
            new_person[attribute] = old_person[attribute]
          end
          new_person.street1 = old_person.address1
          new_person.street2 = old_person.address2
          new_person.postal_code = old_person.zip
          new_person.country = 'US'

          # Data scrubbing
          new_person.phone = nil if new_person.phone = '(415) 000-0000'
          if new_person.first_name.blank?
            next if new_person.last_name.blank?
            new_person.first_name = new_person.last_name
            new_person.last_name = nil
          end
          if !new_person.valid? && new_person.errors.on(:email) == 'is invalid.'
            new_person.email = nil
            new_person.errors.clear
          end

          puts "\nINVALID: #{new_person.inspect} but saving anyway, email error: #{new_person.errors.on(:email)}" if !new_person.valid?
          new_person.save(false) # Don't run validation
          new_person.services << Service.new(:service_type_id => 'MEMBERSHIP',
                                             :start_date => old_person.expiration.last_year,
                                             :end_date => old_person.expiration) if (old_person.expiration)
          new_person.notes << Note.new(:text => old_person.comment) if !old_person.comment.blank?

          legacy_person_ids_to_new_person_ids[old_person.id] = new_person.id
        end

        puts "\nMigrating visits"
        Legacy::Visit.find(:all).each do |old_visit|
          print "."
          operation = old_visit.operation_date.date
          datetime = TzTime.zone.utc_to_local(old_visit.operation_date.date)
          new_visit = Visit.new(:person_id => legacy_person_ids_to_new_person_ids[old_visit.person_id],
                                :datetime => datetime,
                                :volunteer => old_visit.is_volunteer,
                                :created_at => datetime,
                                :updated_at => datetime)
          if (old_visit.visitor_type == 'Staff')
            new_visit.volunteer = true
            new_visit.person.update_attribute(:staff, true)
          elsif old_visit.visitor_type == 'EAB'
            new_visit.volunteer = true
          end
          new_visit.note = Note.new(:text => old_visit.purpose, :created_at => datetime, :updated_at => datetime) if !old_visit.purpose.blank?
          new_visit.save!
        end
      end
    end
  end

end
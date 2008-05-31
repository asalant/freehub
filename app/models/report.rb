class Report
  attr_accessor :target, :date_from, :date_to

  def initialize(params={})
    params.each { |key,value| self.send("#{key}=", value) }
  end

  def summary
    date_condition = ""
    date_condition += "and visits.datetime > #{date_from.to_db}" if date_from
    date_condition += "and visits.datetime < #{date_to.to_db}" if date_to
    connection = ActiveRecord::Base.connection
    all_result = connection.select_all(<<-END
      select date(visits.datetime) as date, people.staff, count(*) as count
        from visits
        left join people on people.id = visits.person_id
        where 1 = 1
        #{date_condition}
        group by date(visits.datetime), people.staff
      END
      )
    members_result = connection.select_all(<<-END
      select date(visits.datetime) as date, people.staff, count(*) as count
        from visits
        left join people on people.id = visits.person_id
        left join services on services.person_id = people.id
        where services.start_date < visits.datetime and services.end_date > visits.datetime and services.service_type_id = 'MEMBERSHIP'
        #{date_condition}
        group by date(visits.datetime), people.staff
      END
      )
    result = {}
    all_result.each do |row|
      day = result[row['date']] || { :date => row['date'] }
      day[:staff] = row['count'].to_i if row['staff'] == '0'
      day[:patron] = row['count'].to_i if row['staff'] == '1'
      result[day[:date]] = day
    end
    members_result.each do |row|
      day = result[row['date']]
      if row['staff'] == '1'
        day[:patron] = day[:patron] - row['count'].to_i
        day[:member] = row['count'].to_i
      end
    end
    result
  end
end

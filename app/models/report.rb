class Report
  attr_accessor :target, :date_from, :date_to

  def initialize(params={})
    params.each { |key,value| self.send("#{key}=", value) }
  end

  def summary
    date_condition = ""
    date_condition += "and visits.datetime > '#{date_from.to_s(:db)}' " if date_from
    date_condition += "and visits.datetime < '#{date_to.to_s(:db)}' " if date_to
    connection = ActiveRecord::Base.connection
    visits_result = connection.select_all(<<-END
      select date(visits.datetime) as date, staff, member, volunteer, count(*) as count
        from visits
        where 1 = 1
        #{date_condition}
        group by date(visits.datetime), staff, member, volunteer
        order by visits.datetime asc
      END
      )
    visit_days, day = [], {}
    visits_result.each do |row|
      date = ActiveRecord::ConnectionAdapters::Column.string_to_date(row['date'])
      if day[:date] != date
        day = { :date => date }
        visit_days << day
      end
      if row['staff'] == '1'
        day[:staff] = row['count'].to_i
      elsif row['volunteer'] == '1'
        day[:volunteer] = row['count'].to_i
      elsif row['member'] == '1'
        day[:member] = row['count'].to_i
      else
        day[:patron]  = row['count'].to_i
      end
    end
    { :visits => visit_days }
  end
end

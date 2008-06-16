class VisitsSummary
  attr_reader :criteria

  def initialize(criteria={})
    @criteria, @result = criteria, {}
  end

  def days
    @days ||= summarize
  end

  def summarize
    date_condition = ""
    date_condition += "and visits.datetime > '#{TzTime.at(criteria[:from]).to_s(:db)}' " if criteria[:from]
    date_condition += "and visits.datetime < '#{TzTime.at(criteria[:to]).to_s(:db)}' " if criteria[:to]
    visits_result = ActiveRecord::Base.connection.select_all(<<-END
      select date(convert_tz(visits.datetime,'+00:00','#{TzTime.zone.offset}')) as date, visits.staff, visits.member, visits.volunteer, count(*) as count
        from visits
        left join people on visits.person_id = people.id
        where people.organization_id = #{criteria[:organization_id]}
        #{date_condition}
        group by date(visits.datetime), visits.staff, visits.member, visits.volunteer
        order by visits.datetime asc
      END
      )
    visit_days, day = [], nil
    visits_result.each do |row|
      date = ActiveRecord::ConnectionAdapters::Column.string_to_date(row['date'])
      if day.nil? || day.date != date
        day = VisitsDay.new(date)
        visit_days << day
      end
      if row['staff'] == '1'
        day.staff = row['count'].to_i
      elsif row['volunteer'] == '1'
        day.volunteer = row['count'].to_i
      elsif row['member'] == '1'
        day.member = row['count'].to_i
      else
        day.patron  = row['count'].to_i
      end
    end

   visit_days
  end
  
end

class VisitsDay
  attr_accessor :date, :staff, :member, :volunteer, :patron

  def initialize(date)
    @date = date
    @staff, @member, @volunteer, @patron = 0, 0, 0, 0
  end

  def total
    @total ||= @staff + @member + @volunteer + @patron
  end
end
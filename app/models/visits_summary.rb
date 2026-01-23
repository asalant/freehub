class VisitsSummary
  attr_reader :criteria

  def initialize(criteria={})
    @criteria, @result = criteria, {}
  end

  def days
    @days ||= fill_empty_days(summarize_days)
  end

  def weeks
    @weeks ||= summarize_weeks(days)
  end

  def summarize_days
    date_condition = ""
    date_condition += "and visits.arrived_at > '#{criteria[:from].to_date.to_time.utc.to_s(:db)}' " if criteria[:from]
    date_condition += "and visits.arrived_at < '#{criteria[:to].to_date.to_time.utc.to_s(:db)}' " if criteria[:to]
    visits_result = ActiveRecord::Base.connection.select_all(<<-END
      select date(convert_tz(visits.arrived_at,'+00:00','#{Time.zone.formatted_offset}')) as arrived_at_date, visits.staff, visits.member, visits.volunteer, count(*) as count
        from visits
        left join people on visits.person_id = people.id
        where people.organization_id = #{criteria[:organization_id]}
        #{date_condition}
        group by arrived_at_date, visits.staff, visits.member, visits.volunteer
        order by arrived_at_date asc
      END
      )
    visit_days, day = [], nil
    visits_result.each do |row|
      date = ActiveRecord::ConnectionAdapters::Column.string_to_date(row['arrived_at_date'])
      if day.nil? || day.date != date
        day = VisitsDay.new(date)
        visit_days << day
      end
      day.add_row row
    end

   visit_days
  end

  def fill_empty_days(days)
    filled = []
    from = criteria[:from] ? criteria[:from].to_date : days.first.date
    to = criteria[:to] ? criteria[:to].to_date : days.last.date
    filled << VisitsDay.new(from) if (days.first.date > from)
    days.each do |day|
      until filled.last.nil? || filled.last.date.tomorrow == day.date
        filled << VisitsDay.new(filled.last.date.tomorrow)
      end
      filled << day
    end
    until filled.last.date.tomorrow >= to
      filled << VisitsDay.new(filled.last.date.tomorrow)
    end
    filled
  end

  def summarize_weeks(days)
    weeks, week = [], nil
    days.each do |day|
      if week.nil? || !week.contains?(day.date)
        week = VisitsWeek.new(day.date)
        weeks << week
      end
      week.add_day(day)
    end
    
    weeks
  end
  
end

class VisitsDay
  attr_accessor :date, :staff, :member, :volunteer, :patron

  def initialize(date)
    @date = date
    @staff, @member, @volunteer, @patron = 0, 0, 0, 0
  end

  def add_row(row)
    if row['staff'] == '1'
      if row['volunteer'] == '1'
        @staff += row['count'].to_i
      else
        @member += row['count'].to_i # count non-volunteering staff as members
      end
    elsif row['volunteer'] == '1'
      @volunteer = row['count'].to_i
    elsif row['member'] == '1'
      @member = row['count'].to_i
    else
      @patron  = row['count'].to_i
    end
  end

  def total
    @total ||= @staff + @member + @volunteer + @patron
  end

  def add_values(day)
    @staff += day.staff
    @volunteer += day.volunteer
    @member += day.member
    @patron += day.patron
  end
end

class VisitsWeek
  attr_accessor :start, :days, :total_day

  def initialize(date)
    @start = date.advance(:days => -1 * date.wday) # Sunday
    @days = []
    @total_day = VisitsDay.new(nil)
  end

  def add_day(day)
    return unless contains?(day.date)
    @days[day.date.wday] = day
    @total_day.add_values day
  end

  def contains?(date)
    date >= @start && date < @start.advance(:days => 7)
  end 
end
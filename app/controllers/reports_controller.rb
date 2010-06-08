require 'csv'

class ReportsController < ApplicationController

  permit "admin or (manager of :organization)"

  def index
  end

  def visits
    if (params[:report])
      @report = {:for_organization => @organization,
                 :after => params[:report][:after],
                 :before => params[:report][:before]}
      @report.delete_if { |key, value| value.respond_to?(:empty?) && value.empty? }
    else
      @report = {:for_organization => @organization, :after => Date.today, :before => Date.tomorrow}
    end

    @visits = Visit.chain_finders(@report)

    respond_to do |format|
      format.html { @visits = @visits.paginate(params) }
      format.xml { render :xml => @visits }
      format.csv do
        stream_csv("#{@organization.key}_visits_#{@report[:after]}_#{@report[:before]}.csv") do |output|
          output << Visit.csv_header
          @visits.each do |visit|
            output << "\n#{visit.to_csv}"
          end
        end
      end
    end
  end

  def services
    @service_types = ServiceType.find_all
    if (params[:report])
      @report = {:for_organization => @organization,
                 :end_after => params[:report][:end_after],
                 :end_before => params[:report][:end_before],
                 :for_service_types => params[:report][:for_service_types].collect { |type| type }}
      @report.delete_if { |key, value| value.respond_to?(:empty?) && value.empty? }
    else
      @report = {:for_organization => @organization,
                 :end_after => Time.now.beginning_of_month.to_date, :end_before => Time.now.next_month.beginning_of_month.to_date,
                 :for_service_types => @service_types.collect { |service_type| service_type.id }}
    end

    @services = Service.chain_finders(@report)

    respond_to do |format|
      format.html { @services = @services.paginate(params) }
      format.xml { render :xml => @services }
      format.csv do
        stream_csv("#{@organization.key}_services_#{@report[:end_after]}_#{@report[:end_before]}.csv") do |output|
          output << CSV.generate_line(Service::CSV_FIELDS[:person] + Service::CSV_FIELDS[:self])
          @services.each do |service|
            output << "\n#{service.to_csv}"
          end
        end
      end
    end
  end

  def people
    if (params[:report])
      @report = params[:report].merge :for_organization => @organization,
                                      :after => params[:report][:after],
                                      :before => params[:report][:before]
      @report.delete(:matching_name) if @report[:matching_name] && @report[:matching_name].length < 3
      @report.delete_if { |key, value| value.nil? || (value.respond_to?(:empty?) && value.empty?) }
    else
      @report = {:for_organization => @organization,
                 :after => Date.today, :before => Date.tomorrow}
    end

    @people = Person.chain_finders(@report)

    respond_to do |format|
      format.html { @people = @people.paginate(params) }
      format.xml { render :xml => @people }
      format.csv do
        stream_csv("#{@organization.key}_people_#{@report[:after]}_#{@report[:before]}.csv") do |output|
          output << CSV.generate_line(Person::CSV_FIELDS[:self])
          @people.each do |person|
            output << "\n#{person.to_csv}"
          end
        end
      end
    end
  end

  def summary
    criteria = params[:criteria] || {:from => Time.now.beginning_of_year.to_date}
    criteria[:organization_id] = @organization.id
    criteria.delete_if { |key, value| value.respond_to?(:empty?) && value.empty? }

    @report= VisitsSummary.new(criteria)
    @gchart = Gchart.line(:size => '840x120',
                          :data => [@report.weeks.collect { |week| week.total_day.total }, @report.weeks.collect { |week| week.total_day.staff },
                                    @report.weeks.collect { |week| week.total_day.volunteer }, @report.weeks.collect { |week| week.total_day.member },
                                    @report.weeks.collect { |week| week.total_day.patron }],
                          :line_colors => ['74A3FB', 'F9B639', 'A3FB74', 'FB8974', 'CC74FB'],
                          :legend => ['Total', 'Staff', 'Volunteer', 'Member', 'Patron'],
                          :axis_with_labels => 'x', :axis_labels => [[@report.weeks.first, @report.weeks.last].collect { |week| date_short(week.start) }],
                          :format => 'img_tag')

    respond_to do |format|
      format.html # summary.html.mab
    end
  end

  private

  # http://wiki.rubyonrails.org/rails/pages/HowtoExportDataAsCSV
  def stream_csv(filename)
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :text => lambda { |response, output|
      yield output
    }
  end
end

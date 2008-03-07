require 'csv'

class ReportsController < ApplicationController

  permit "admin or (user of :organization)"

  def index
  end

  def visits
    @report ||= params[:report].nil? ?
            Report.new(:target => 'Visit', :date_from => Date.today, :date_to => Date.tomorrow) :
            Report.new(:target => 'Visit',
              :date_from => date_from_params(params[:report][:date_from]) || Date.today,
              :date_to => date_from_params(params[:report][:date_to]) || Date.tomorrow)
    
    @visits = Visit.for_organization(@organization).after(@report.date_from).before(@report.date_to)

    respond_to do |format|
      format.html { @visits = @visits.paginate(params) }
      format.xml  { render :xml => @visits }
      format.csv do
        stream_csv("#{@organization.key}_visits_#{@report.date_from.to_s(:db)}_#{@report.date_to.to_s(:db)}.csv") do |output|
          output << CSV.generate_line(Visit::CSV_FIELDS[:person] + Visit::CSV_FIELDS[:self])
          @visits.each do |visit|
            output << "\n#{visit.to_csv}"
          end
        end
      end
    end
  end

  def signin
    @day = date_from_params(params)
    @visits = Visit.for_organization(@organization).after(@day).before(@day.tomorrow)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @visits }
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

  # year, month, day
  def date_from_params(params)
    return nil unless params[:year] && params[:month] && params[:day]
    Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
  end
end

require 'csv'

class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
  def index
    @reports = Report.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])

    if @report.target == 'Visit'
      visits
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  def visits
    @report ||= params[:report].nil? ?
            Report.new(:target => 'Visit', :date_from => Date.today, :date_to => Date.tomorrow) :
            Report.new(params[:report])

    finders = { :for_organization => @organization }
    finders[:after] = @report.date_from if @report.date_from
    finders[:before] = @report.date_to if @report.date_to
    @visits = Visit.chain_finders(finders)

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
    @day = parse_date_params(params.values_at(:year, :month, :day))
    @visits = Visit.for_organization(@organization).after(@day).before(@day.tomorrow)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @visits }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(report_path(:id => @report)) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(report_path(:id => @report)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
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
  def parse_date_params(args)
    Date.new args[0].to_i, args[1].to_i, args[2].to_i
  end
end

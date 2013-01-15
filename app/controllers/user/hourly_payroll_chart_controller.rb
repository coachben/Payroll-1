class User::HourlyPayrollChartController < User::UserController
  
  # GET /hourly/chart
  # GET /hourly/chart.json
  def index
    @month_hash = month_options
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'chart' }
    end
  end
  
  # POST /hourly/chart/data
  def data
    month = params[:month].blank? ? '0' : params[:month]
    year = params[:year].blank? ? 0 : params[:year].to_i
    staff_id = get_staff_id
    
    criteria = PayRate
    title = 'Hourly Payroll'
    yaxis = 'Total Amount (RM)'
    
    criteria = criteria.where(:staff_id => staff_id)
    
    if year != 0
      criteria = criteria.where(:year => year)
      title = "Hourly Payroll for #{year}"
    end
    
    if month != '0'
      criteria = criteria.where('month in (?)', month)
    end
    
    list = criteria.group(:month).order(:month).sum('total_hours * hourly_pay_rate')
    months = I18n.t('date.month_names')
    
    o = []
    b = []
    categories = []
    list.each do |k, v|
      y = v
      o << [months[k], y]
      b << v
      categories << months[k][0..2]
    end
    
    c = b.collect { |x| x.round(2) }
    
    @data = { :pie => o, :column => { :data => c, :categories => categories, :yaxis => yaxis }, :title => title }
    
    render :json => @data
  end
end

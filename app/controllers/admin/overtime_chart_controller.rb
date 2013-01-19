# This controller serves incoming requests to display Employee Overtime Chart.
class Admin::OvertimeChartController < Admin::AdminController
  
  # Display the main page.
  # GET /overtime/chart
  def index
    @month_hash = month_options
    
    respond_to do |fmt|
      fmt.html { render :layout => LAYOUT[:chart] }
    end
  end
  
  # Get the overtime json data to be populated to the chart.
  # GET /overtime/chart/data
  def data
    staff_id = params[:staff_id].blank? ? '' : params[:staff_id]
    month = params[:month].blank? ? '0' : params[:month]
    year = params[:year].blank? ? 0 : params[:year].to_i
    
    criteria = Attendance
    title = 'Overtime'
    yaxis = 'Duration (hours)'
    
    if staff_id.present?
      criteria = criteria.where(:staff_id => staff_id)
    end
    
    if year != 0
      criteria = criteria.where('year(work_date) = ?', year)
      title = "Overtime for Year #{year}"
    end
    
    if month != '0'
      criteria = criteria.where('month(work_date) in (?)', month)
    end
    
    list = criteria.order(:work_date).all
    months = I18n.t('date.month_names')
    
    b = Array.new(12) { |x| 0 }
    categories = Array.new(12) { |x| months[x + 1][0..2] }
    list.each do |o|
      to = ApplicationHelper.localtime(o.time_out)
      v = Time.new(to.year, to.month, to.day, 18, 0, 0, '+08:00')
      x = (to - v) / 3600.0
      m = o.work_date.month
      if x > 0
        b[m - 1] += x
      end
    end
    
    c = b.collect { |x| x.round(2) }
    
    @data = { :data => c, :categories => categories, :title => title, :yaxis => yaxis }
    
    render :json => @data
  end
end

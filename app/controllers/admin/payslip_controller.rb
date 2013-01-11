class Admin::PayslipController < Admin::AdminController
  
  def index
    @data = EmployeeHelper.get_all
    @employmentstatus = EmploymentStatus.order(:name).all
    @designation = Designation.order(:title).all
    @dept = Department.order(:name).all
    @month_hash = month_options
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  def list
    employee = params[:employee].blank? ? '' : params[:employee]
    staff_id = params[:staff_id].blank? ? '' : params[:staff_id]
    employment_status = params[:employment_status].blank? ? 0 : params[:employment_status].to_i
    designation = params[:designation].blank? ? 0 : params[:designation].to_i
    dept = params[:dept].blank? ? 0 : params[:dept].to_i
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? EmployeeHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? EmployeeHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = { :employee => employee,
                :staff_id => staff_id,
                :employment_status => employment_status,
                :designation => designation,
                :dept => dept }
                
    if employee.blank? && staff_id.blank? && employment_status == 0 && designation == 0 && dept == 0
      @data = EmployeeHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = EmployeeHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  def payslip
    @employee = Employee.find(params[:id])
    @employee_salary = @employee.employee_salary
    
    _month = params[:month].to_i
    month = month_name(params[:month].to_i)
    year = params[:year].blank? ? Time.now.year : params[:year].to_i
    @period = "#{month}-#{year}"
    
    if @employee_salary.blank?
      @total_earnings = 0
      @total_deduct = 0
      @nett_salary = 0
      
      @employee_salary = EmployeeSalary.new
      
      respond_to do |fmt|
        fmt.html { render 'payslip_monthly' }
        fmt.json { render :json => [@employee, @total_earnings, @total_deduct, @nett_salary] }
      end
      
    else
      if @employee_salary.pay_type == 1
        @total_earnings = PayslipHelper.total_earnings(@employee_salary)
        @total_deduct = PayslipHelper.total_deductions(@employee_salary)
        @nett_salary = PayslipHelper.nett_salary(@employee_salary)
    
        respond_to do |fmt|
          fmt.html { render 'payslip_monthly' }
          fmt.json { render :json => [@employee, @total_earnings, @total_deduct, @nett_salary] }
        end
        
      else
        filters = { :staff_id => @employee.staff_id, :year => year, :month => _month }
        @total_earnings = PayslipHelper.total_earnings_hourly(@employee_salary, filters)
        @total_deduct = PayslipHelper.total_deductions(@employee_salary)
        @nett_salary = PayslipHelper.nett_salary_hourly(@employee_salary, filters)
        
        o = PayRate.where(filters)
        @total_hours = o.first.blank? ? 0 : o.first.total_hours
        @hourly_pay_rate = o.first.blank? ? 0 : o.first.hourly_pay_rate
        
        respond_to do |fmt|
          fmt.html { render 'payslip_hourly' }
          fmt.json { render :json => [@employee, @total_earnings, @total_deduct, @nett_salary] }
        end
      end
    end
  end
end

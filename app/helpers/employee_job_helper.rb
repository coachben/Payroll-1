module EmployeeJobHelper
  # Get the validation errors.
  def self.get_errors(errors)
    { :error => 1, :errors => errors }
  end
  
  # Checks whether any job parameters are present in the POST request.
  def self.is_empty_params?(params)
    q = params[:employee_job]
    if q[:designation_id] == '0' && q[:department_id] == '0' && 
      q[:employment_status_id] == '0' && q[:job_category_id] == '0' && 
      q[:join_date].blank? && q[:confirm_date].blank?
      return true
    end
    false
  end
  
  # Get the job object from the POST request.
  def self.employee_job_obj(o, params)
    q = params[:employee_job]
    
    _join_date = q[:join_date]
    _confirm_date = q[:confirm_date]
    join_date = Date.strptime(_join_date, 
      ApplicationHelper.date_fmt) if _join_date.present?
    confirm_date = Date.strptime(_confirm_date, 
      ApplicationHelper.date_fmt) if _confirm_date.present?
    
    EmployeeJob.new(:id => o.id, :designation_id => q[:designation_id], 
                    :department_id => q[:department_id], 
                    :employment_status_id => q[:employment_status_id], 
                    :job_category_id => q[:job_category_id], :join_date => join_date, 
                    :confirm_date => confirm_date)
  end
  
  # Update the job object.
  def self.update_obj(o, params)
    q = params[:employee_job]
    
    _join_date = q[:join_date]
    _confirm_date = q[:confirm_date]
    join_date = Date.strptime(_join_date, 
      ApplicationHelper.date_fmt) if _join_date.present?
    confirm_date = Date.strptime(_confirm_date, 
      ApplicationHelper.date_fmt) if _confirm_date.present?
    
    o.update_attributes(:designation_id => q[:designation_id], 
                        :department_id => q[:department_id],
                        :employment_status_id => q[:employment_status_id], 
                        :job_category_id => q[:job_category_id], :join_date => join_date, 
                        :confirm_date => confirm_date)
  end
  
  # Get the job object.
  def self.find(id)
    o = nil
    begin
      o = EmployeeJob.find(id)
      
    rescue Exception => e
      o = EmployeeJob.new
    end
    o
  end
end

class DesignationController < ApplicationController
  layout false
  
  # GET /designation
  # GET /designation.json
  def index
    @data = DesignationHelper.get_all(1, ApplicationHelper::Pager.default_page_size)
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /designation/list
  # GET /designation/list.json
  def list
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    
    if keyword.blank?
      @data = DesignationHelper.get_all(pgnum, pgsize)
      
    else
      @data = DesignationHelper.get_filter_by(keyword, pgnum, pgsize)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /designation/new
  # GET /designation/new.json
  def new
    @designation = Designation.new
    @form_id = 'add-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @designation }
    end
  end
  
  # POST /designation/create
  def create
    o = Designation.new(:title => params[:title])
    
    if o.save
      render :json => { :success => 1 }
      
    else
      render :json => DesignationHelper.get_errors(o.errors, params)
    end
  end
  
  # GET /designation/edit/1
  # GET /designation/edit/1.json
  def edit
    @designation = Designation.find(params[:id])
    @form_id = 'edit-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @designation }
    end
  end
  
  # POST /designation/update/1
  def update
    o = Designation.find(params[:id])
    
    if o.update_attributes(:title => params[:title])
      render :json => { :success => 1 }
        
    else
      render :json => DesignationHelper.get_errors(o.errors, params)
    end
  end
  
  # POST /designation/delete
  def destroy
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    lsid = ids.split(',')
    Designation.delete_all(:id => lsid)
    
    itemscount = DesignationHelper.item_message(keyword, pgnum, pgsize)
    
    render :json => { :success => 1, :itemscount => itemscount }
  end
end

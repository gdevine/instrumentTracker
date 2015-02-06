class StatusesController < ApplicationController
  before_action :set_status_type
  before_action :set_status_type_text
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,  only: [:edit, :update, :destroy]
  
  
  def index
    if params[:instrument_id]
      @statuses = status_type_class.where(instrument_id:params[:instrument_id]).paginate(page: params[:page], :per_page => 20)
      @instrument = Instrument.find(params[:instrument_id])
    else
      # when not bounded by a particular instrument we return a list of only 'current' statuses
      @instruments = Instrument.where(id: view_context.current_instruments(status_type).map(&:id)).paginate(page: params[:page], :per_page => 20)
    end
  end

  def show
    @status = Status.find(params[:id])
    @instrument = @status.instrument
  end

  def new
    @instrument = Instrument.find(params[:instrument_id])
    @status = status_type_class.new
  end

  def edit
    @status = Status.find(params[:id])
  end


  def create
    @instrument = Instrument.find(status_params[:instrument_id])
    @status = @instrument.statuses.build(status_params)
    @status.reporter = current_user
    @status.status_type = @status_type
    
    if @status.save
      if @status.status_type == 'Retirement'
        flash[:success] = "Instrument has been retired!"
      else  
        flash[:success] = @status.status_type_text + " Record Created!"
      end
      @status = Status.find(@status.id)
      redirect_to @status
    else
      @statuses = []
      @instrument = Instrument.find(status_params[:instrument_id])
      @status_type = @status_type
      render 'new'
    end
  end
   
  def update
    @status = Status.find(params[:id])
    if @status.update_attributes(status_params)
      flash[:success] = @status.status_type_text + " Record Updated"
      redirect_to @status
    else
      render 'edit'
    end
  end


  def destroy
    @status.destroy
    flash[:success] = @status.status_type_text + " Record Deleted!"
    redirect_to @instrument
  end
  
  
  private

    def set_status_type 
      @status_type = status_type 
    end
    
    def set_status_type_text 
      @status_type_text = status_type_text 
    end
    
    def status_type 
      Status.status_types.include?(params[:status_type]) ? params[:status_type] : "Status"
    end
    
    def status_type_text
      case status_type
      when 'Loan'
        'Loan'
      when 'Lost'
        'Lost'
      when 'Facedeployment'
        'FACE Deployment'
      when 'Storage'
        'In Storage'
      when 'Retirement'
        'Retired'
      else
        'Status'
      end
    end
    
    def status_type_class 
      status_type.constantize 
    end
    
    def status_params
      params.require(@status_type.downcase).permit(:instrument_id, :loaned_to, :startdate, :enddate, :address, :comments, :reporter_id, :status_type, :ring, :northing, :easting, :vertical, :storage_location_id)
    end
    
    def correct_user
      @status = Status.find_by(id:params[:id])
      @inst_id = @status.instrument.id
      @instrument = current_user.instruments.find_by(id: @inst_id)
      redirect_to root_url if @instrument.nil?
    end
end

class StatusesController < ApplicationController
  before_action :set_status_type
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,  only: [:edit, :update, :destroy]
  
  
  def index
    if params[:instrument_id]
      @statuses = status_type_class.where(instrument_id:params[:instrument_id]).paginate(page: params[:page], :per_page => 20)
      @instrument = Instrument.find(params[:instrument_id])
    else
      @statuses = status_type_class.paginate(page: params[:page], :per_page => 20)
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
    # @status = Status.find(params[:id])
    @status = status_type_class.find(params[:id])
    @instrument = @status.instrument
  end


  def create
    @instrument = Instrument.find(status_params[:instrument_id])
    @status = @instrument.statuses.build(status_params)
    @status.reporter = current_user
    @status.status_type = @status_type
    
    if @status.save
      flash[:success] = @status.status_type.capitalize + " Record Created!"
      # redirect_to instrument_status_path(instrument_id:@instrument.id, id:@status.id)
      # redirect_to @instrument
      @status = Status.find(@status.id)
      redirect_to @status
    else
      @statuses = []
      @instrument = Instrument.find(status_params[:instrument_id])
      # render action: 'new'
      # render status_type_class.new
      @status_type = @status_type
      render 'new'
      # render Status.new(:status_type=>@status.status_type)
    end
  end
   
   
  def update
    @status = Status.find(params[:id])
    @instrument = @status.instrument
    if @status.update_attributes(status_params)
      flash[:success] = @status.status_type.capitalize + " Record Updated"
      # redirect_to @instrument
      redirect_to @status
    else
      render 'edit'
    end
  end


  def destroy
    @status.destroy
    flash[:success] = @status.status_type.capitalize + " Record Deleted!"
    redirect_to @instrument
  end
  
  
  private

    def set_status_type 
      @status_type = status_type 
    end

    def status_type 
      Status.status_types.include?(params[:status_type]) ? params[:status_type] : "Status"
    end
    
    def status_type_class 
      status_type.constantize 
    end
    
    def status_params
      params.require(@status_type.downcase).permit(:instrument_id, :loaned_to, :startdate, :enddate, :address, :comments, :reporter_id, :status_type)
    end
    
    def correct_user
      @status = Status.find_by(id:params[:id])
      @inst_id = @status.instrument.id
      @instrument = current_user.instruments.find_by(id: @inst_id)
      redirect_to root_url if @instrument.nil?
    end
end
class LandgrafExpressionLevelsController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /landgraf_expression_levels
  # GET /landgraf_expression_levels.xml
  def index
    @landgraf_expression_levels = nil
    
    params[:page] ||= 1
        
    if params[:mature_id]
      @landgraf_expression_levels = Mature.find_rest(params[:mature_id]).landgraf_expression_levels
    elsif params[:landgraf_library_id]
      @landgraf_expression_levels = LandgrafLibrary.find_rest(params[:landgraf_library_id]).landgraf_expression_levels
    end

    respond_to do |format|
      format.html do
        if @landgraf_expression_levels # subselect
          @landgraf_expression_levels = LandgrafExpressionLevel.paginate @landgraf_expression_levels.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => "expression_level DESC"
        else #all
          @landgraf_expression_levels = LandgrafExpressionLevel.paginate :page => params[:page], :per_page => 12, :order => "landgraf_library_id, mature_id"
        end        
      end
      format.xml do
        @landgraf_expression_levels = LandgrafExpressionLevel.find(:all) if !@landgraf_expression_levels
        render :xml => @landgraf_expression_levels.to_xml(:only => LandgrafExpressionLevel.column_names)
      end
    end
  end
  
end

class LandgrafLibrariesController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /landgraf_libraries
  # GET /landgraf_libraries.xml
  def index
    @landgraf_libraries = nil
    
    params[:page] ||= 1
        
    respond_to do |format|
      format.html do
        if @landgraf_libraries # subselect
          @landgraf_libraries = LandgrafLibrary.paginate @landgraf_libraries.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => :name
        else #all
          @landgraf_libraries = LandgrafLibrary.paginate :page => params[:page], :per_page => 12, :order => :name
        end        
      end
      format.xml do
        @landgraf_libraries = LandgrafLibrary.find(:all) if !@landgraf_libraries
        render :xml => @landgraf_libraries.to_xml(:only => LandgrafLibrary.column_names)
      end
    end
  end

  # GET /landgraf_libraries/1
  # GET /landgraf_libraries/1.xml
  def show
    @landgraf_library = LandgrafLibrary.find_rest(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @landgraf_library.to_xml(:only => LandgrafLibrary.column_names)}
    end
  end
  
end

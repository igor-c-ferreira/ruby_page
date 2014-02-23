class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

before_filter :check_format


  def check_format
    render :nothing => true, :status => 406 unless (params[:format] == 'json' || params[:format] == 'xml')
  end

	respond_to :json, :xml

	def index
		msg = { :status => "error", :message => "Bad access!"}
		render :json => msg, :status => 404 unless (params[:format] != 'json')
		render :xml => msg.to_xml(:root => ‘response’), :status => 404 unless (params[:format] != 'xml')
	end

end

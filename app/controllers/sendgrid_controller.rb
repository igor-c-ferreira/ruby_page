class SendgridController < ApplicationController
protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
	def index
		msg = { :status => "ok", :message => "Success!"}
		render :json => msg, :status => 200 unless params[:format] != 'json'
		render :xml => msg.to_xml(:root => 'response'), :status => 200 unless params[:format] != 'xml'
	end
end
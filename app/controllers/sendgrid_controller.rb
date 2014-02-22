class SendgridController < ApplicationController
	def index
		msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
		render :json => msg
	end
end
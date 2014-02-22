class SendgridController < ApplicationController
	def index
		msg = {:status => “Ok”}
		render.json => msg
	end
end
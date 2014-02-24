require 'mail'
require 'pusher'

class SendgridController < ApplicationController
	def index
        
        msg = { :status => "ok", :message => "Success!", :parameters => params}
        
        @from = params[:from];
        
        unless @from.nil?
            
            Mail.defaults do
                delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                    :port      => 587,
                    :domain    => "pogamadores.com",
                    :user_name => ENV['SENDGRID_USER'],
                    :password  => ENV['SENDGRID_PASSWORD'],
                    :authentication => 'plain',
                    :enable_starttls_auto => true }
            end
            
            mail = Mail.new do
                from 'POGAmadores <contato@pogamadores.com>'
                subject 'Sendgrid test with env'
                text_part do
                    body msg.to_json()
                end
                html_part do
                    content_type 'text/html; charset=UTF-8'
                    body '<p>' + msg.to_json() + '</p>'
                end
            end
            
            mail[:to] = params[:from]
            mail.deliver!
        end
		
		Pusher.app_id = ENV['PUSH_APP_ID']
		Pusher.key = ENV['PUSH_APP_KEY']
		Pusher.secret = ENV['PUSH_APP_SECRET']
		Pusher.host = "api-eu.pusher.com"
		
		begin
			Pusher.trigger('sendgrid_email_parser', 'received_email', msg)
			render :json => msg.to_json, :status => 200 unless params[:format] != 'json'
			render :xml => msg.to_xml(:root => 'response'), :status => 200 unless params[:format] != 'xml'
			render :nothing => true, :status => 200 unless params[:format] != nil
		rescue Pusher::Error => e
			# (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
			render :json => e.original_error.to_json, :status => 500 unless params[:format] != 'json'
			render :xml => e.original_error.to_xml(:root => 'response'), :status => 500 unless params[:format] != 'xml'
			render :nothing => true, :status => 500 unless params[:format] != nil
		end
	end
end
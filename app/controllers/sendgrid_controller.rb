require 'mail'

class SendgridController < ApplicationController
	def index
        
        msg = { :status => "ok", :message => "Success!", :parameters => params}
        
        @from = params[:from];
        
        unless @from.nil?
            
            Mail.defaults do
                delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                    :port      => 587,
                    :domain    => "pogamadores.com",
                    :user_name => "igorcferreira",
                    :password  => "C4r4ct3r3$",
                    :authentication => 'plain',
                    :enable_starttls_auto => true }
            end
            
            mail = Mail.deliver do
                to 'igorferreiracastanheda@gmail.com'
                from 'POGAmadores <contato@pogamadores.com>'
                subject 'Sendgrid test'
                text_part do
                    body msg.to_json()
                end
                html_part do
                    content_type 'text/html; charset=UTF-8'
                    body '<p>' + msg.to_json() + '</p>'
                end
            end
        end
        
		render :json => msg, :status => 200 unless params[:format] != 'json'
		render :xml => msg.to_xml(:root => 'response'), :status => 200 unless params[:format] != 'xml'
        render :nothing => true, :status => 200
	end
end
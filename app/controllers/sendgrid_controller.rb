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
        
		render :json => msg, :status => 200 unless params[:format] != 'json'
		render :xml => msg.to_xml(:root => 'response'), :status => 200 unless params[:format] != 'xml'
        render :nothing => true, :status => 200 unless params[:format] != nil
	end
end
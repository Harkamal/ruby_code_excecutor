class StaticController < ApplicationController
  layout 'static'
	# Online Ruby code execution
	def tryRuby
	end
	
	# execute ruby script code
	def executeRubyScript
    return export if params[:export]
    if request.xhr?
  	  begin
  	    return @data = "Please write the code you want to execute." if params[:rubyCode].blank?
        create_and_execute_ruby_file
  		rescue Exception => ecd
  			logger.info "exception raise......."
  			@data = e.message
  		end
  	else
  	  redirect_to root_path
  	end
	end
	
	def create_and_execute_ruby_file
	  doc = "require 'timeout'\n" unless params[:export]
	  doc << "begin\n"
	  doc << "Timeout.timeout(5) do\n" unless params[:export]
    doc << params[:rubyCode] + "\n"
    doc << "end\n" unless params[:export]
    doc << "rescue Exception => e \n"
    doc << 'puts "Error: #{e.class} - " + e.to_s'
    doc << "\nend"
    File.open('cc.rb', 'w') {|f| f.write(doc) }
    unless (`ruby -c cc.rb`).include?("OK")
      return @data = "Syntax error, Provide correct Ruby syntax."
    end
    begin
      Timeout.timeout(3) do
        @data = `ruby cc.rb` 
      end
    rescue Exception => e
      @data = "Error: #{e.class} - " + e.to_s
      puts "exception==================#{e.to_s}"
    end
	end

	def export
	  @content = get_content
    send_data @content,
      :type => 'application/vnd.ms-excel',
      :disposition => "attachment; filename=script.rb"
	end
	
	def get_content
	  doc = "begin\n"
    doc << " #{params[:exportCode]}" + "\n"
    doc << "rescue Exception => e \n"
    doc << ' puts  e.to_s'
    doc << "\nend"
	end
end

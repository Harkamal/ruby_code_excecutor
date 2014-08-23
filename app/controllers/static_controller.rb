class StaticController < ApplicationController
  layout 'static'
	# Online Ruby code execution
	def tryRuby
	end
	
	# execute ruby script code
	def executeRubyScript
	  begin
	    return @data = "Please write the code you want to execute." if params[:rubyCode].blank?
      create_and_execute_ruby_file
		rescue Exception => ecd
			logger.info "exception raise......."
			@data = e.message
		end
	end
	
	def create_and_execute_ruby_file
	  doc = "begin\n"
    doc << params[:rubyCode] + "\n"
    doc << "rescue Exception => e \n"
    doc << 'puts "Error: #{e.class} - " + e.to_s'
    doc << "\nend"
    File.open('cc.rb', 'w') {|f| f.write(doc) }
    unless (`ruby -c cc.rb`).include?("OK")
      return @data = "Syntax error, Provide correct Ruby syntax."
    end
    @data = `ruby cc.rb`
	end
end

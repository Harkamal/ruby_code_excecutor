module StaticHelper
  def scriptResponse
    res = @data.gsub("\n", "<br />")
    if @data.include?('Error')
      res  = "<div id='error'>#{res}</div>"
    else
      res = "<div id='success'>#{res}</div>"
    end
    res.html_safe
  end
end

module ApplicationHelper
  #return the title on a per-page basis
  def title  #method defition
    base_title = "Ruby on Rails Tutorial Sample App" #variable assignment
    if @title.nil?
      base_title #implicit return
    else
      "#{base_title} | #{@title}" #string interpolation
    end
  end
end

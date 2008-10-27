module ApplicationHelper
  def flashes
    flash.map {|type, content| content_tag(:div, content, :class => "flash", :id => "flash_#{type}")}
  end
end

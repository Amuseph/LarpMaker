# frozen_string_literal: true

module ApplicationHelper
  def getGameMonth(month)
    case month
    when 1
      'Chillwind'
    when 2
      'Snowfell'
    when 3
      'Winterwane'
    when 4
      'Mistmoot'
    when 5
      'Meadowrise'
    when 6
      'Greatsun'
    when 7
      'Firemeet'
    when 8
      'Firewithe'
    when 9
      'Softsun'
    when 10
      'Leafell'
    when 11
      'Snowmoot'
    when 12
      'Fellnight'
    else
      'Error'
    end
  end

  def full_title(page_title = '')
    base_title = Setting.game_name
    if page_title.empty?
      base_title
    else
      "#{ page_title } | #{ base_title }"
    end
  end
end

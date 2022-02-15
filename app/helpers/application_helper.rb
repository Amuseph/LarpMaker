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

  def update_mailchimp(user)
    begin
      if user.aliaslastname.present?
        lastname = user.aliaslastname
      else
        lastname = user.lastname
      end

      mailchimp = MailchimpMarketing::Client.new
      mailchimp.set_config({
        :api_key => ENV['MAILCHIMP_API'],
        :server => ENV['MAILCHIMP_SERVER']
      })

      mailchimp.lists.set_list_member(
        ENV['MAILCHIMP_LIST'],
          user.email,
          {
            'email_address' => user.email,
            'status_if_new': 'subscribed',
            'merge_fields': {
              FNAME: user.firstname,
              LNAME: lastname
            }
          }
        )
    rescue MailchimpMarketing::ApiError => e
      puts "Error: #{e}"
    end
  end
end

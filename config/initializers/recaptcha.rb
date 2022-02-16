Recaptcha.configure do |config|
  config.site_key  = ENV['reCAPTCHA_SITE']
  config.secret_key = ENV['reCAPTCHA_KEY']
end
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  #Specifies the scopes (api) that will be used and provides the client id and secret id
  provider :google_oauth2, '242940041414-3p5v3sl6hsbonl7b49af4agc0kbdg9rq.apps.googleusercontent.com', '45WS4-BvMJoo2Izjht6pn3uv', {
  scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
    access_type: 'offline'}
end
 
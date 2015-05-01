# require 'pp'
# task :list_labels => :environment do
#   client = Google::APIClient.new
#   client.authorization.access_token = User.last.oauth_token #nakhela User.token
#   service = client.discovered_api('calendar', 'v3')
#   # result = client.execute(
#   # 	:api_method => service.calendar_list.list,
#   #   :parameters => {'userId' => 'me'},
#   #   :headers => {'Content-Type' => 'application/json'})
#   # pp JSON.parse(result.body)

#   event = {
#   'summary' => 'Appointment',
#   'location' => 'Somewhere',
#   'start' => {
#     'dateTime' => '2015-04-08T10:00:00.000-07:00'
#   },
#   'end' => {
#     'dateTime' => '2015-04-12T10:25:00.000-07:00'
#   },
#   'attendees' => [
#     {
#       'email' => 'nesreen.mouti@gmail.com'
#     },
#     #...
#   ]
# }
# result = client.execute(:api_method => service.events.insert,
#                         :parameters => {'calendarId' => 'primary'},
#                         :body => JSON.dump(event),
#                         :headers => {'Content-Type' => 'application/json'})
#   pp JSON.parse(result.body)

# end

# result = api_client.execute(:api_method => calendar_api.events.list,
#                              :parameters => {'calendarId' => 'primary'},
#                              :authorization => user_credentials)
#  [result.status, {'Content-Type' => 'application/json'}, result.data.to_json]
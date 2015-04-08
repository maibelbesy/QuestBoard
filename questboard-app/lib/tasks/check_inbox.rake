require 'pp'
task :check_inbox => :environment do
  client = Google::APIClient.new
  client.authorization.access_token = User.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.get,
    # :parameters => {'userId' => 'me', :q => 'subject:' + '[QuestBoard] Task Assignment'},
    :parameters => {'userId' => 'me', 'id' => '14c99fd764da7df2', 'format' => 'minimal'},
    :headers => {'Content-Type' => 'application/json'})
  # 14c996b88e06a615
  # 14c96a3baf65e6a8
  # 14c96574e4a52ae5
  # 14c9648417ff1a46
  data = JSON.parse(result.body)
  # pp data
  # data["messages"].each do |d|
  #   pp d
  # end
  pp data['snippet'].scan(/\[\quest \d+\]/)[0].scan(/\d+/)[0].to_i
  # if data['payload']['mimeType'].split('/')[0] == 'multipart'
	 #  pp Base64.decode64 data['payload']['parts'][0]['body']['data']	
  # else
  # 	pp Base64.decode64 data['payload']['body']['data']
  # end

  # Base64.decode64
end
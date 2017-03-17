require './lib/slack_message.rb'

Data = {}
Data[:count] = 0

get '/' do
  Data[:count] += 1
  user_agent = request.user_agent

  penny = SlackMessage.new( ENV["PENNY_URL"], 
                            "#notifications", 
                            "New download!", 
                            "Total downloads: #{Data[:count]}\nFrom: #{user_agent}"
                          )
  penny.send

  content_type 'text/plain'
  File.read("install.sh")
end

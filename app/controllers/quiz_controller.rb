class QuizController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
  end

  def task
	info_string = File.read('database.json')
    	info = JSON.parse(info_string)
  	string = params["question"]
	level = params["level"].to_i
	id = params["id"]
	#answer = Pushkin.up(level, string, info)
	case level
			when 1
				info.size.times do |i|
					if info[i][1].include?(string)
						answer = info[i][0]
					end
				end

	
	uri = URI('http://pushkin.rubyroidlabs.com/quiz')
	parameters = {
        answer: answer,
        token: "62a577a09ddc094e97031892510c16fd",
        task_id: id
    }
    res = Net::HTTP.post_form(uri, parameters)
  end
end



class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    s_file = File.read('database.json')
    str = JSON.parse(s_file)
    @per = str[0][0]
  end

  def task
    info_string = File.read('database.json')
    info = JSON.parse(info_string)
    answer = ""
    string = params["question"]
    level = params["level"].to_i
    id = params["id"]
    case level
      when 1
        info.size.times do |i|
		if info[i][1].include?(string)
			answer = info[i][0]
			break
		end
	end
    end
    if answer
      uri_app = URI('http://pushkin.rubyroidlabs.com/quiz')

      parameters = {
        answer: answer,
        token: '62a577a09ddc094e97031892510c16fd',
        task_id: id
      }
      Net::HTTP.post_form(uri_app, parameters)
      #render json: 'ok'
      #puts res.body
    end
    file = File.open('in_data.json', 'w') do |f|
      f.write(params)
    end
  end
end


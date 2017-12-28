class QuizController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
  end

  def task
  	string = params["question"]
		level = params["level"].to_i
		id = params["id"]
		answer = Pushkin.up(level, string)
		
		uri = URI('http://pushkin.rubyroidlabs.com/quiz')
		parameters = {
      answer: answer,
      token: "62a577a09ddc094e97031892510c16fd",
      task_id: id
    }
    file = File.open('in_data.json', 'w') do |f|
        f.write(parameters.json)
    end
    res = Net::HTTP.post_form(uri, parameters)
  end
end

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
    when 2
      string_part = string.split('%WORD%')
      info.size.times do |i|
        answer = nil
        if string_part[0].empty? && info[i][1].include?(string_part[1])
          answer = info[i][1].split(string_part[1])
          answer = answer[0]
        end
        if string_part[1].nil? && info[i][1].include?(string_part[0])
          answer = info[i][1].split(string_part[0])
          answer = answer[1]
        end
        if info[i][1].include?(string_part[0]) && info[i][1].include?(string_part[1])
          answer = info[i][1].split(string_part[0])
          answer = answer[1].split(string_part[1])
          answer = answer[0]
        end
        if answer != nil
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


#require_relative 'lib/pushkin'
#class QuizController < ApplicationController
#	skip_before_action :verify_authenticity_token
#
#	def index
#  end
#
#  def task
#  	string = params["question"]
#		level = params["level"].to_i
#		id = params["id"]
#		answer = Pushkin.up(level, string)
#		
#		uri = URI('http://pushkin.rubyroidlabs.com/quiz')
#		parameters = {
#      answer: answer,
#      token: "62a577a09ddc094e97031892510c16fd",
#      task_id: id
#    }
#    file = File.open('in_data.json', 'w') do |f|
#        f.write(parameters.json)
#    end
#    res = Net::HTTP.post_form(uri, parameters)
#  end
#end
#
class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    s_file = File.read('database.json')
    str = JSON.parse(s_file)
    @per = str[0][0]
  end

  def task
    s_file = File.read('database.json')
    str = JSON.parse(s_file)
    answer = ""
    question = params["question"]
    level = params["level"].to_i
    id = params["id"]
    question = question.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
    question = question.strip
    case level
      when 1
        str.map do |e|
          tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
          if tmp_str.include?(question)
            answer = e[0]
            break
          end
        end
      when 2
        tmp_tmp_inp = question.split(' ')
        tmp_tmp_str = Array.new
        fl = 0
        str.map do |e|
          tmp_str = e[1].split("\n")
          tmp_str.map do |el|
            tmp_tmp_str = el.split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            fl = 1
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i] && !tmp_tmp_inp[i].include?('%')
                fl = 0
                break
              end
            end
            if fl == 1
              break
            end
          end
          if fl == 1
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i]
                answer = tmp_tmp_str[i]
                break
              end
            end
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
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
    when 3
      string = string.split('\n')
      devited_first = string[0].split('%WORD%')
      devited_second = string[1].split('%WORD%')
      info.size.times do |i|
        devited_info = info[i][1].split(/\n/)
        devited_info.size.times do |j|
          if devited_info[j].include?(devited_first[0]) && devited_info[j].include?(devited_first[1])
            if devited_info[j+1].include?(devited_second[0]) && devited_info[j+1].include?(devited_second[1])
              if devited_first[0].empty? && info[i][1].include?(devited_first[1])
                answer1 = info[i][1].split(devited_first[1])
                answer1 = answer1[0]
              end
              if devited_first[1].nil? && info[i][1].include?(devited_first[0])
                answer1 = info[i][1].split(devited_first[0])
                answer1 = answer1[1]
              end
              if info[i][1].include?(devited_first[0]) && info[i][1].include?(devited_first[1])
                answer1 = info[i][1].split(devited_first[0])
                answer1 = answer1[1].split(devited_first[1])
                answer1 = answer1[0]
              end

              if devited_second[0].empty? && info[i][1].include?(devited_second[1])
                answer2 = info[i][1].split(devited_second[1])
                answer2 = answer2[0]
              end
              if devited_second[1].nil? && info[i][1].include?(devited_second[0])
                answer2 = info[i][1].split(devited_second[0])
                answer2 = answer2[1]
              end
              if info[i][1].include?(devited_second[0]) && info[i][1].include?(devited_second[1])
                answer2 = info[i][1].split(devited_second[0])
                answer2 = answer2[1].split(devited_second[1])
                answer2 = answer2[0]
              end
              answer = answer1 + "," + answer2
              break
            end
          end
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
    end
  end
end


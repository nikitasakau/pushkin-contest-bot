require 'json'

class Pushkin
	def self.up(level, string)
		info_string = File.read('database.json')
    info = JSON.parse(info_string)
    if level == 1
			return Pushkin.level1(info, string)
		end
		if level == 2
			return Pushkin.level2(info, string)
		end
		if level == 3
			return Pushkin.level3(info, string)
		end
		if level == 4
			return Pushkin.level4(info, string)
		end
		if level == 5
			return Pushkin.level5(info, string)
		end
		if level == 6
			return Pushkin.level6(info, string)
		end
		if level == 7
			return Pushkin.level7(info, string)
		end
		if level == 8
			return Pushkin.level8(info, string)
		end
	end

	def self.level1(info, string)
		info.size.times do |i|
			if info[i][1].include?(string)
				return info[i][0]
			end
		end
	end

	def self.level2(info, string)
		string_part = string.split('%WORD%')
		info.size.times do |i|
			answer = Pushkin.find_word(info, i, string_part)
			if answer != nil
				return answer
			end
		end
	end

	def self.level3(info, strings)
		strings = strings.split('\n')
		devited_first = strings[0].split('%WORD%')
		devited_second = strings[1].split('%WORD%')
		info.size.times do |i|
			devited_info = info[i][1].split(/\n/)
			devited_info.size.times do |j|
				if devited_info[j].include?(devited_first[0]) && devited_info[j].include?(devited_first[1])
					if devited_info[j+1].include?(devited_second[0]) && devited_info[j+1].include?(devited_second[1])
						answers = Array.new(2, 0)
						answers[0] = Pushkin.find_word(info, i, devited_first)
						answers[1] = Pushkin.find_word(info, i, devited_second)
						return "#{answers[0]},#{answers[1]}"
					end
				end
			end
		end
	end

	def self.level4(info, strings)
		strings = strings.split('\n')
		devited_first = strings[0].split('%WORD%')
		devited_second = strings[1].split('%WORD%')
		devited_third = strings[2].split('%WORD%')
		info.size.times do |i|
			devited_info = info[i][1].split(/\n/)
			devited_info.size.times do |j|
				if devited_info[j].include?(devited_first[0]) && devited_info[j].include?(devited_first[1])
					if devited_info[j+1].include?(devited_second[0]) && devited_info[j+1].include?(devited_second[1])
						if devited_info[j+2].include?(devited_third[0]) && devited_info[j+2].include?(devited_third[1])
							answers = Array.new(3, 0)
							answers[0] = Pushkin.find_word(info, i, devited_first)
							answers[1] = Pushkin.find_word(info, i, devited_second)
							answers[2] = Pushkin.find_word(info, i, devited_third)
							return "#{answers[0]},#{answers[1]},#{answers[2]}"
						end
					end
				end
			end
		end
	end

	def self.level5(info, string)
		words = string.split
		info.size.times do |i|
			strings = info[i][1].split(/\n/)
			strings.size.times do |j|
				parts_of_string = strings[j].split
				if Pushkin.are_equal(words, parts_of_string)
					return Pushkin.find_contrast(words, parts_of_string)
				end
			end
		end
	end

	def self.level6(info, string)
		string = string.tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
		words = string.split
		info.size.times do |i|
			strings = info[i][1].split(/\n/)
			strings.size.times do |j|
				string_without_changes = strings[j]
				strings[j] = strings[j].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
				parts_of_string = strings[j].split
				if Pushkin.is_this_string(words, parts_of_string)
					return string_without_changes
				end
			end
		end
	end

	def self.level7(info, string)
		string = string.tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
		info.size.times do |i|
			strings = info[i][1].split(/\n/)
			strings.size.times do |j|
				string_without_changes = strings[j]
				strings[j] = strings[j].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
				if Pushkin.is_this_word(string, strings[j])
					return string_without_changes
				end
			end
		end
	end

	def self.level8(info, string)
		string = string.tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
		info.size.times do |i|
			strings = info[i][1].split(/\n/)
			strings.size.times do |j|
				string_without_changes = strings[j]
				strings[j] = strings[j].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').downcase
				if Pushkin.almost_same_strings(string, strings[j])
					return string_without_changes
				end
			end
		end
	end

	def self.almost_same_strings(string1, string2)
		if string1.size == string2.size
			count = 0
			string1.size.times do |i|
				string2.size.times do |j|
					if string1[i] == string2[j]
						string2[j] = ' '
						break
					end
				end
			end
			string2.size.times do |i|
				if string2[i] != ' '
					count += 1
				end
			end
			if count == 1
				return true
			end
		end
	end

	def self.is_this_string(words, parts_of_string)
		if words.size == parts_of_string.size
			count = 0
			words.size.times do |i|
				if Pushkin.is_this_word(words[i], parts_of_string[i])
					count += 1
				end
			end
			if count == words.size 
				return true
			end
		end
	end

	def self.is_this_word(word1, word2)
		if word1.chars.sort == word2.chars.sort
			return true
		end
	end

	def self.find_word(info, i, string_part)
		if string_part[0].empty? && info[i][1].include?(string_part[1])
			answer = info[i][1].split(string_part[1])
			return answer[0]
		end
		if string_part[1].nil? && info[i][1].include?(string_part[0])
			answer = info[i][1].split(string_part[0])
			return answer[1]
		end
		if info[i][1].include?(string_part[0]) && info[i][1].include?(string_part[1])
			answer = info[i][1].split(string_part[0])
			answer = answer[1].split(string_part[1])
			return answer[0]
		end
		return nil
	end

	def self.are_equal(words, parts_of_string)
		if words.size == parts_of_string.size
			count = 0
			words.size.times do |i|
				if words[i].include?(parts_of_string[i])
					count += 1
				end
			end
			if count == (words.size - 1)
				return true
			end
		end
	end

	def self.find_contrast(words, parts_of_string)
		words.size.times do |i|
				if !words[i].include?(parts_of_string[i])
					parts_of_string[i] = parts_of_string[i].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
					words[i] = words[i].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
					return "#{parts_of_string[i]},#{words[i]}"
				end
			end
	end

end

Pushkin.up

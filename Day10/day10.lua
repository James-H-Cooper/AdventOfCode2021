
local function read_input_list(file_name)
   local inputs = {}
   for line in io.lines(file_name) do
      local line_input = {}
      for char in line:gmatch(".") do
         table.insert(line_input,char)
      end
      table.insert(inputs,line_input)
   end 
   return inputs
end

local function is_opening_tag(tag)
   if tag == "(" or tag == "[" or tag == "{" or tag == "<" then
      return true
   end 
   return false
end 

local function do_tags_match(opening_tag,closing_tag)
   if opening_tag == "(" then
      return closing_tag == ")"
   elseif opening_tag == "[" then
      return closing_tag == "]"
   elseif opening_tag == "{" then
      return closing_tag == "}"
   elseif opening_tag == "<" then
      return closing_tag == ">"
   end

   print("ERROR: Opening tag was invalid")
   return false
end

-- Iterate through each character adding each opening tag to a list.
-- When we hit a closing tag, check if it matches the last opening tag, if it does then remove the last opening tag
-- Otherwise return that character.
local function  find_error_character(line)
   local opening_tag_list = {}
   for _,character in ipairs(line) do
      if is_opening_tag(character) then
         table.insert(opening_tag_list,character)
      else
         local last_opening_tag = opening_tag_list[#opening_tag_list]
         if do_tags_match(last_opening_tag,character) then
            table.remove(opening_tag_list,#opening_tag_list)
         else
            return character
         end
      end
   end
end

-- If a closing tag is passed, get the error score of that character
-- If an opening tag is passed, get the score of the correct ending tag
local function get_weight_of_character(target_character)
   if target_character == ")" then
      return 3
   elseif target_character == "]" then
      return 57
   elseif target_character == "}" then
      return 1197
   elseif target_character == ">" then
      return 25137
   end

   if target_character == "(" then
      return 1
   elseif target_character == "[" then
      return 2
   elseif target_character == "{" then
      return 3
   elseif target_character == "<" then
      return 4
   end

   print("ERROR: Target character was not a valid tag")
end

local function calculate_error_score_for_line(line)
   local error_character = find_error_character(line)
   if error_character == nil then
      return 0 
   end
   local character_weight = get_weight_of_character(error_character)

   return character_weight
end

local function autocomplete_line(line)
   local opening_tag_list = {}
   for _,character in ipairs(line) do
      if is_opening_tag(character) then
         table.insert(opening_tag_list,character)
      else
         table.remove(opening_tag_list,#opening_tag_list)
      end
   end

   local score = 0
   for i=#opening_tag_list, 1,-1 do
      score = score * 5
      score = score + get_weight_of_character(opening_tag_list[i])
   end
   return score
end

local function get_middle_autocomplete_score(input_list)
   local auto_complete_scores = {}
   for _,line in ipairs(input_list) do
      if find_error_character(line) == nil then   
         local score = autocomplete_line(line)
         table.insert(auto_complete_scores,score)
      end
   end

   local function sort_function(left,right) return left < right end
   table.sort(auto_complete_scores, sort_function)
   local index_to_return = math.ceil(#auto_complete_scores/2)
   return auto_complete_scores[index_to_return]
end

local function solution(file_name, is_part_two)
   local input_list = read_input_list(file_name)
   local result = 0
   if is_part_two then 
      result = get_middle_autocomplete_score(input_list)
   else
      for _,line in ipairs(input_list) do
         result = result + calculate_error_score_for_line(line)
      end
   end

   print("Result = " .. result)
end

print("Sample Part 1")
solution("sample.txt",false)

print("-------------------------")
print("Input Part 1")
solution("input.txt",false)

print("-------------------------")
print("Sample Part 2")
solution("sample.txt",true)

print("-------------------------")
print("Input Part 2")
solution("input.txt",true)
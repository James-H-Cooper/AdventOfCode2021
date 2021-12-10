-- Read each input as a table.
-- Line[1] is a table of strings containing the input on the left side. 
-- Line[2] is a table of strings containing the output on the right side 
local function read_input_list(file_name)
   local inputs = {}
   for line in io.lines(file_name) do
      local full_input = {}
      for half in string.gmatch(line,"([^|]+)") do
         local section = {}
         for word in half:gmatch("%w+") do
            table.insert(section,word)
         end
         table.insert(full_input, section)
      end
      table.insert(inputs,full_input)
   end 
   return inputs
end

local function build_segment_lists()
   local segment_counts = {6,2,5,5,4,5,6,3,7,6}
   return segment_counts
end

local function remove_non_unique_segments(segment_list)
   local numbers_to_remove = {}
   local segments_found = {}
   for i, segment in ipairs(segment_list) do
      for _,found in ipairs(segments_found) do
         if segment == found then
            table.insert(numbers_to_remove,segment)
         end 
      end
      table.insert(segments_found,segment)
   end

   for _,number in ipairs(numbers_to_remove) do
      for i=#segment_list,1,-1 do
         if segment_list[i] == number then
            table.remove(segment_list,i)
         end
      end
   end 

   return segment_list
end

local function count_unique_outputs(input_list)
   local segment_counts = build_segment_lists()
   segment_counts = remove_non_unique_segments(segment_counts)
   local result = 0
   for _, line in ipairs(input_list) do
      for _,word in ipairs(line[2]) do
         for _,unique_segment in ipairs(segment_counts) do
            if #word == unique_segment then
               result = result + 1
            end
         end
      end 
   end

   return result
end

local function find_zero_mapping(number_mapping, character_mapping)
   local number_string = ""
   for _, character in ipairs(character_mapping) do
      if character[1] ~= "d"  then
         number_string = number_string .. character[2]
      end
   end

   number_mapping[1] = number_string
   return number_mapping
end

local function find_one_mapping(line, mapping_table)
   for _,word in ipairs(line[1]) do
      if #word == 2 then
         mapping_table[2] = word
         return mapping_table
      end
   end
end

local function find_two_mapping(number_mapping, character_mapping)
   local number_string = ""
   for _, character in ipairs(character_mapping) do
      if character[1] ~= "b"  and character[1] ~= "f" then
         number_string = number_string .. character[2]
      end
   end

   number_mapping[3] = number_string
   return number_mapping
end

local function find_three_mapping(line, mapping_table)
   -- 3 is the only 5 segment character that has all the segments of 7
   -- Loop through each 5 segment character, checking if all of the characters of 7 are found
   for _,word in ipairs(line[1]) do
      if #word == 5 then
         local matches_all_seven = true
         for seven_character in mapping_table[8]:gmatch(".") do
            local character_found = false
            for test_character in word:gmatch(".") do
               if test_character == seven_character then
                  character_found = true
               end
            end
            if not character_found then
               matches_all_seven = false
            end
         end
         if matches_all_seven then
            mapping_table[4] = word
            return mapping_table
         end
      end
   end
end

local function find_four_mapping(line, mapping_table)
   for _,word in ipairs(line[1]) do
      if #word == 4 then
         mapping_table[5] = word
         return mapping_table
      end
   end
end

local function find_five_mapping(number_mapping, character_mapping)
   local number_string = ""
   for _, character in ipairs(character_mapping) do
      if character[1] ~= "c"  and character[1] ~= "e" then
         number_string = number_string .. character[2]
      end
   end

   number_mapping[6] = number_string
   return number_mapping
end

local function find_six_mapping(line, mapping_table)
   for _,word in ipairs(line[1]) do
      if #word == 6 then
         local matches_all_seven = true
         for seven_character in mapping_table[8]:gmatch(".") do
            local character_found = false
            for test_character in word:gmatch(".") do
               if test_character == seven_character then
                  character_found = true
               end
            end
            if not character_found then
               matches_all_seven = false
            end
         end
         if not matches_all_seven then
            mapping_table[7] = word
            return mapping_table
         end
      end
   end
end

local function find_seven_mapping(line, mapping_table)
   for _,word in ipairs(line[1]) do
      if #word == 3 then
         mapping_table[8] = word
         return mapping_table
      end
   end
end

local function find_eight_mapping(line, mapping_table)
   for _,word in ipairs(line[1]) do
      if #word == 7 then
         mapping_table[9] = word
         return mapping_table
      end
   end
end


local function find_nine_mapping(number_mapping, character_mapping)
   local number_string = ""
   for _, character in ipairs(character_mapping) do
      if character[1] ~= "e" then
         number_string = number_string .. character[2]
      end
   end

   number_mapping[10] = number_string
   return number_mapping
end

local function find_number_from_mapping(digit, number_mapping)
   for index, mapping in ipairs(number_mapping) do
      -- Only compare mappings where number of characters match.
      if mapping ~= -1 and #digit == #mapping then
         local all_digits_match = true
         for digit_character in digit:gmatch(".") do
            local character_found = false
            for mapping_character in mapping:gmatch(".") do
               if mapping_character == digit_character then
                  character_found = true
               end
            end
            if not character_found then
               all_digits_match = false
            end
         end
         if all_digits_match then
            return index - 1
         end
      end
   end
end

local function construct_answer_from_digit_table(digit_table)
   -- Concatenate each digit in the table to a string
   local output_string = ""
   for _,digit in ipairs(digit_table) do
      output_string = output_string .. tostring(digit)
   end
   -- Now convert our string back to a number when we return it
   return tonumber(output_string)
end

local function get_last_not_found_char(number,letter_mapping)
   for char in number:gmatch(".") do
      local char_found = false
      for _, letter in ipairs(letter_mapping) do
         if letter[2] == char then
            char_found = true
         end
      end
      if not char_found then
         return char
      end
   end
end

local function find_a_mapping(number_mapping,letter_mapping)
   -- Only char of 7 not in 1 
   local char = nil
   for seven_char in number_mapping[8]:gmatch(".") do
      local char_found = false
      for one_char in number_mapping[2]:gmatch(".") do
         if one_char == seven_char then
            char_found = true
         end
      end

      if not char_found then
         char = seven_char
      end
   end
   local map = {"a",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_c_mapping(number_mapping,letter_mapping)
   -- Only char of 3 not in 6
   local char = nil
   for three_char in number_mapping[4]:gmatch(".") do
      local char_found = false
      for six_char in number_mapping[7]:gmatch(".") do
         if six_char == three_char then
            char_found = true
         end
      end

      if not char_found then
         char = three_char
      end
   end
   local map = {"c",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_f_mapping(number_mapping,letter_mapping)
   -- Only char in 1 that's not c
   local char = nil
   local c = nil
   for _,letter in ipairs(letter_mapping) do
      if letter[1] == "c" then
         c = letter[2]
      end
   end

   for one_char in number_mapping[2]:gmatch(".") do
      if one_char ~= c then
         char = one_char
      end     
   end
   
   local map = {"f",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_d_mapping(number_mapping,letter_mapping)
   -- in BOTH 4 and 3 but not c or f
   local char = nil
   local c = nil
   local f = nil
   local matching_chars = ""
   for _,letter in ipairs(letter_mapping) do
      if letter[1] == "c" then
         c = letter[2]
      elseif letter[1] == "f" then
         f= letter[2]
      end
   end

   for four_char in number_mapping[5]:gmatch(".") do
      for three_char in number_mapping[4]:gmatch(".") do
         if three_char == four_char and three_char ~= c and three_char ~= f then
            matching_chars = matching_chars.. three_char
         end
      end
   end

   char = get_last_not_found_char(matching_chars,letter_mapping)
   local map = {"d",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_b_mapping(number_mapping,letter_mapping)
   -- last not found character in 4
   local char =  get_last_not_found_char(number_mapping[5],letter_mapping)
   local map = {"b",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_g_mapping(number_mapping,letter_mapping)
   -- last not found character in 3
   local char =  get_last_not_found_char(number_mapping[4],letter_mapping)
   local map = {"g",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

local function find_e_mapping(number_mapping,letter_mapping)
   -- last not found character in 8
   local char =  get_last_not_found_char(number_mapping[9],letter_mapping)
   local map = {"e",char}
   table.insert(letter_mapping,map)
   return letter_mapping
end

-- This isn't a great way to do this but it logically makes sense for solving the problem.
-- Find each mapping individually.
-- This is a bit hard coded and there's certainly a cleaner way
local function find_number_from_line(line)
   local number_mapping = {}
   for i=1, 10, 1 do
      table.insert(number_mapping,-1)
   end 
   local letter_mapping = {}

   -- Get 1,4,7,8 (No Dependencies)
   number_mapping = find_one_mapping(line,number_mapping)
   number_mapping = find_four_mapping(line,number_mapping)
   number_mapping = find_seven_mapping(line,number_mapping)
   number_mapping = find_eight_mapping(line,number_mapping)
   -- 3 and 6 are only dependent on 7 so we can find that now
   number_mapping = find_three_mapping(line,number_mapping)
   number_mapping = find_six_mapping(line,number_mapping)

   -- Now we can find the letters:
   letter_mapping = find_a_mapping(number_mapping,letter_mapping)
   letter_mapping = find_c_mapping(number_mapping,letter_mapping)
   letter_mapping = find_f_mapping(number_mapping,letter_mapping) 
   letter_mapping = find_d_mapping(number_mapping,letter_mapping)
   letter_mapping = find_b_mapping(number_mapping,letter_mapping)
   letter_mapping = find_g_mapping(number_mapping,letter_mapping)
   letter_mapping = find_e_mapping(number_mapping,letter_mapping)
 
   --Now construct the rest from letter map
   number_mapping = find_nine_mapping(number_mapping,letter_mapping)
   number_mapping = find_five_mapping(number_mapping,letter_mapping)
   number_mapping = find_two_mapping(number_mapping,letter_mapping)
   number_mapping = find_zero_mapping(number_mapping,letter_mapping)

   -- We now have a complete number mapping, we can find the actual number
   local digit_table = {}
   for _,digit in ipairs(line[2]) do
      local number_to_add = find_number_from_mapping(digit, number_mapping)
      table.insert(digit_table,number_to_add)
   end

   return construct_answer_from_digit_table(digit_table)
end

local function count_all_outputs(input_list)
   local result = 0 
   for _,line in ipairs(input_list) do
      result = result + find_number_from_line(line)
   end
   return result
end

local function solution(file_name, is_part_two)
   local input_list = read_input_list(file_name)
   local result  = 0
   if is_part_two then
      result = count_all_outputs(input_list)
   else
      result = count_unique_outputs(input_list)
   end
   print("Result " .. result)
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
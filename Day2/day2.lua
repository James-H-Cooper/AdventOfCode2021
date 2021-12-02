local function create_instructions_from_input(file_name)
   local instructions = {} 
   for line in io.lines(file_name) do
      table.insert(instructions, line)
   end
   return instructions
end

local function seperate_instruction(instruction)
   local words = {}
   for word in instruction:gmatch("%w+") do
      table.insert(words, word)
   end
   return words[1], words[2]
end

local function is_instruction_vertical(word)
   if(word == "up"or word == "down") then
      return true
   else
      return false
   end
end

local function does_instruction_increase_value(word, is_depth)
   if(word == "forward" or word == "down") then
      return true
   else
      return false
   end
end

local function part_one(file_name)
   local input_array = create_instructions_from_input(file_name)
   local current_depth = 0
   local current_position = 0

   for _,instruction in ipairs(input_array) do
      local word, value = seperate_instruction(instruction)
      local is_depth = is_instruction_vertical(word)
      local is_increase = does_instruction_increase_value(word)

      if(is_depth) then
         if(is_increase) then
            current_depth = current_depth + value;
         else
            current_depth = current_depth - value;
         end
      else
         if(is_increase) then
            current_position = current_position + value;
         else
            current_position = current_position - value;
         end
      end
   end

   local answer = current_depth * current_position
   print("Depth = " .. current_depth)
   print("Position = " .. current_position)
   print("Answer = " .. answer)
end

local function part_two(file_name)
   local input_array = create_instructions_from_input(file_name)
   local current_depth = 0
   local current_position = 0
   local current_aim = 0

   for _,instruction in ipairs(input_array) do
      local word, value = seperate_instruction(instruction)
      local is_aim = is_instruction_vertical(word)

      if(is_aim) then
         if(does_instruction_increase_value(word)) then
            current_aim = current_aim + value;
         else
            current_aim = current_aim - value;
         end
      else
         current_position = current_position + value

         local depth_increase = current_aim * value
         current_depth = current_depth + depth_increase
      end
   end

   local answer = current_depth * current_position
   print("Depth = " .. current_depth)
   print("Position = " .. current_position)
   print("Answer = " .. answer)
end

print("Sample Part 1")
part_one("sample.txt")

print("-------------------------")
print("Input Part 1")
part_one("input.txt")

print("-------------------------")
print("Sample Part 2")
part_two("sample.txt")

print("-------------------------")
print("Input Part 2")
part_two("input.txt")
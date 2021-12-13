local FLASHED_FISH_VALUE = "f"

local function read_input_list(file_name)
   local inputs = {}
   for line in io.lines(file_name) do
      local line_input = {}
      for char in line:gmatch(".") do
         table.insert(line_input,tonumber(char))
      end
      table.insert(inputs,line_input)
   end 
   return inputs
end

local function increment_all(list)
   for i,row in ipairs(list) do
      for k,fish in ipairs(row) do
         list[i][k] = fish + 1
      end
   end
   return list
end

local function flash(list, row, column)
   -- set flashed fish to FLASHED_FISH_VALUE
   list[row][column] = FLASHED_FISH_VALUE
   -- increment all neighbours not set to F (including diagonals)
   local not_top = row > 1
   local not_bot = row < #list
   local not_left = column > 1
   local not_right = column < #list[row]

   -- Cardinal directions first
   if not_top then
      if list[row-1][column] ~= FLASHED_FISH_VALUE then
         list[row-1][column] = list[row-1][column] + 1
      end
   end
   if not_bot then
      if list[row+1][column] ~= FLASHED_FISH_VALUE then
         list[row+1][column] = list[row+1][column] + 1
      end
   end   
   if not_left then
      if list[row][column-1] ~= FLASHED_FISH_VALUE then
         list[row][column-1] = list[row][column-1] + 1
      end
   end  
   if not_right then
      if list[row][column+1] ~= FLASHED_FISH_VALUE then
         list[row][column+1] = list[row][column+1] + 1
      end
   end

   -- now diagonals
   if not_top then
      if not_left then
         if list[row-1][column-1] ~= FLASHED_FISH_VALUE then
            list[row-1][column-1] = list[row-1][column-1] + 1
         end
      end
      if not_right then
         if list[row-1][column+1] ~= FLASHED_FISH_VALUE then
            list[row-1][column+1] = list[row-1][column+1] + 1
         end
      end
   end
   if not_bot then
      if not_left then
         if list[row+1][column-1] ~= FLASHED_FISH_VALUE then
            list[row+1][column-1] = list[row+1][column-1] + 1
         end
      end
      if not_right then
         if list[row+1][column+1] ~= FLASHED_FISH_VALUE then
            list[row+1][column+1] = list[row+1][column+1] + 1
         end
      end
   end

   return list
end

local function set_flashed_fish_to_0(list)
   for i,row in ipairs(list) do
      for k,fish in ipairs(row) do
         if fish == FLASHED_FISH_VALUE then
            list[i][k] = 0
         end
      end
   end
   return list
end

-- Return 0 if there were no flashes, otherwise continue
local function check_for_flashes(list)
   local flashes = 0

   for i, row in ipairs(list) do
      for k, fish in ipairs(row) do
         if fish ~= FLASHED_FISH_VALUE and fish > 9 then
            flashes = flashes + 1
            list = flash(list,i,k)
         end
      end
   end

   return list, flashes
end

local function run_step(list)
   local list = increment_all(list)
   local total_flashes = 0
   local flashes_this_loop = 0
   list,flashes_this_loop = check_for_flashes(list)
   while flashes_this_loop ~= 0 do
      total_flashes = total_flashes + flashes_this_loop
      list,flashes_this_loop = check_for_flashes(list)
   end
   list = set_flashed_fish_to_0(list)

   return list, total_flashes
end

local function have_all_fish_flashed(list) 
   for i,row in ipairs(list) do
      for k,fish in ipairs(row) do
         if fish ~= 0 then
            return false
         end
      end
   end

   return true
end 

local function solution(file_name, is_part_two)
   local list = read_input_list(file_name)
   local result = 0
   if is_part_two then
      while not have_all_fish_flashed(list) do
         list,_ = run_step(list)
         result = result + 1
      end
   else
      local STEPS_TO_RUN = 100
      for i=1, STEPS_TO_RUN, 1 do
         local new_flashes = 0
         list, new_flashes = run_step(list)
         result = result + new_flashes
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
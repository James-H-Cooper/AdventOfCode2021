-- Each line input wil be set into a map of 4 values. 
-- Starting X, Starting Y, Ending X, Ending Y
local function get_lines_from_input(file_name)
   local lines = {} 
   for line in io.lines(file_name) do
      -- split based on spaces
      local tube = {}
      local set = 1
      for coordinate in string.gmatch(line,"%w+") do
         -- These co-ordinates start at 0 but indexing in LUA starts at 1. we need to add 1 to each co-ordinate to account for this. 
         -- This means we'll have an empty row and column at the beginning of the map but that probably doesn't matter for this exercise.
         local adjusted_coordinate = tonumber(coordinate) + 1
         table.insert(tube,adjusted_coordinate)
      end
      table.insert(lines,tube)
   end
   return lines
end

local function remove_non_straight_lines(lines)
   for i=#lines, 1, -1 do
      if (lines[i][1] ~= lines[i][3]) and (lines[i][2] ~= lines[i][4]) then
         table.remove(lines,i)
      end
   end

   return lines
end

-- Finds the extremes for length and height to generate a map from and then generates the map
local function generate_map_from_lines(lines)
   local global_highest_x = 1
   local global_highest_y = 1

   for _,line in ipairs(lines) do
      local local_highest_x = math.max(line[1], line[3])
      local local_highest_y = math.max(line[2], line[4])
      global_highest_x = math.max(local_highest_x, global_highest_x)
      global_highest_y = math.max(local_highest_y, global_highest_y)
   end

   local map = {}
   for i=1, global_highest_y, 1 do
      local row = {}
      for k=1, global_highest_x, 1 do
         table.insert(row,k,0)
      end
      table.insert(map,i,row)
   end

   return map
end

-- Add a single straight line to the map
local function add_line_to_map(line,map)
   local is_horizontal = line[1] == line[3]
   local is_vertical = line[2] == line[4]
   if is_horizontal then
      local min_y = math.min(line[2], line[4])
      local max_y = math.max(line[2], line[4])
      for i=min_y, max_y, 1 do
         map[i][line[1]] =  map[i][line[1]] + 1
      end
   elseif is_vertical then
      local min_x = math.min(line[1], line[3])
      local max_x = math.max(line[1], line[3])
      for i=min_x, max_x, 1 do
         map[line[2]][i] =  map[line[2]][i] + 1
      end
   else 
      local current_x =line[1]
      local current_y =line[2]
      local end_x =line[3]
      local end_y =line[4]

      local is_x_increasing = current_x < end_x
      local is_y_increasing = current_y < end_y

      -- Part 2, 45 degree line so the difference between x and y will be the same.
      local number_of_loops = math.abs(current_x-end_x) 
      -- Start i at 0 so that we don't miss the last point of the line
      for i=0, number_of_loops, 1 do
      -- In/decrement X, and Y from starting to ending point and record it on the map
         map[current_y][current_x] =  map[current_y][current_x] + 1
         if is_x_increasing then
            current_x = current_x + 1
         else
            current_x = current_x - 1
         end
         if is_y_increasing then
            current_y = current_y + 1
         else
            current_y = current_y - 1
         end
      end
   end

   return map
end

local function solution(file_name, is_part_two)
   local lines = get_lines_from_input(file_name)
   if not is_part_two then
      lines = remove_non_straight_lines(lines)
   end
   local map = generate_map_from_lines(lines)
   for _,line in ipairs(lines) do
      map = add_line_to_map(line,map)
   end

   local result = 0
   for _,row in ipairs(map) do
      for _,point in ipairs(row) do
         if point > 1 then
            result = result + 1
         end
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
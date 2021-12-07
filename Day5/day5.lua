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
   for i=1, global_highest_x, 1 do
      local row = {}
      for k=1, global_highest_y, 1 do
         table.insert(row,k,0)
      end
      table.insert(map,i,row)
   end

   return map
end

-- Add a single straight line to the map
local function add_line_to_map(line,map)
   local is_horizontal = line[1] == line[3]
   if is_horizontal then
      local min_y = math.min(line[2], line[4])
      local max_y = math.max(line[2], line[4])
      for i=min_y, max_y, 1 do
         map[line[1]][i] =  map[line[1]][i] + 1
      end
   else
      local min_x = math.min(line[1], line[3])
      local max_x = math.max(line[1], line[3])
      for i=min_x, max_x, 1 do
         map[i][line[2]] =  map[i][line[2]] + 1
      end
   end

   return map
end

local function part_one(file_name)
   local lines = get_lines_from_input(file_name)
   lines = remove_non_straight_lines(lines)
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
part_one("sample.txt")

print("-------------------------")
print("Input Part 1")
part_one("input.txt")

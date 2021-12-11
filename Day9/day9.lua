
local function read_input_list(file_name)
   local inputs = {}
   for line in io.lines(file_name) do
      local row_input = {}
      for digit in line:gmatch(".") do
         table.insert(row_input,tonumber(digit))
      end
      table.insert(inputs,row_input)
   end 
   return inputs
end

local function is_low_point(point_list, row_index, column_index, point)
   -- Empty points are intialised as 10 so that the point is definitely lower than them
   local up_point = 10
   if row_index > 1 then
      up_point = point_list[row_index-1][column_index]
   end
   local down_point = 10
   if row_index < #point_list then
      down_point = point_list[row_index+1][column_index]
   end
   local left_point = 10
   if column_index > 1 then
      left_point = point_list[row_index][column_index-1]
   end
   local right_point = 10
   if column_index < #point_list[row_index] then
      right_point = point_list[row_index][column_index+1]
   end

   if point < up_point and point < down_point and point < left_point and point < right_point then
      return true
   end

   return false 
end

local function get_low_points(point_list) 
   local low_points = {}
   for i,row in ipairs(point_list) do
      for k, point in ipairs(row) do
         if is_low_point(point_list,i,k,point) then
            table.insert(low_points,point)
         end
      end
   end
   return low_points
end

local function find_nearest_basin(point_list,row_index,column_index,point)
   if point == 9 then
      return 0,0
   end

   if is_low_point(point_list,row_index,column_index,point) then
      return row_index,column_index
   end
   local up_point = 10
   if row_index > 1 then
      up_point = point_list[row_index-1][column_index]
   end
   local down_point = 10
   if row_index < #point_list then
      down_point = point_list[row_index+1][column_index]
   end
   local left_point = 10
   if column_index > 1 then
      left_point = point_list[row_index][column_index-1]
   end
   local right_point = 10
   if column_index < #point_list[row_index] then
      right_point = point_list[row_index][column_index+1]
   end

   -- Check each neighbour, starting at up and rotating clockwise. 
   -- If it's lower than the point, recursively call this function on that point 
   if up_point < point then
      return find_nearest_basin(point_list,row_index-1,column_index, point_list[row_index-1][column_index])
   end

   if down_point < point then
      return find_nearest_basin(point_list,row_index+1,column_index, point_list[row_index+1][column_index])
   end

   if left_point < point then
      return find_nearest_basin(point_list,row_index,column_index-1, point_list[row_index][column_index-1])
   end

   if right_point < point then
      return find_nearest_basin(point_list,row_index,column_index+1, point_list[row_index][column_index+1])
   end

   print("ERROR: Point was not a 9 but did not belong to a Basin")
end

local function find_basin_size(point_list, row_index, column_index)
   local basin_size = 0
   -- Iterate through point list, finding which basin each point belongs to. 
   for i,row in ipairs(point_list) do
      for k,point in ipairs(row) do
         nearest_basin_row, nearest_basin_column = find_nearest_basin(point_list,i,k,point)
         if nearest_basin_column == column_index and nearest_basin_row == row_index then
            basin_size = basin_size + 1 
         end
      end
   end
   return basin_size
end

local function get_basin_sizes(point_list) 
   local basins = {}
   for i,row in ipairs(point_list) do
      for k, point in ipairs(row) do
         if is_low_point(point_list,i,k,point) then
            local basin = find_basin_size(point_list,i,k)
            table.insert(basins,basin)
         end
      end
   end
   return basins
end

local function sum_low_points(low_points)
   local result = 0
   for _, point in ipairs(low_points) do
      result = result + point + 1
   end
   return result 
end

local function calculate_basin_score(basins)
   local biggest = 1
   local second_biggest = 1
   local third_biggest = 1
   for _,basin in ipairs(basins) do
      if basin > biggest then
         third_biggest = second_biggest
         second_biggest = biggest
         biggest = basin
      elseif basin > second_biggest then
         third_biggest = second_biggest
         second_biggest = basin
      elseif basin > third_biggest then
         third_biggest = basin
      end
   end

   return biggest*second_biggest*third_biggest
end

local function solution(file_name, is_part_two)
   local input_list = read_input_list(file_name)
   local result = 0
   if is_part_two then
      local basins = get_basin_sizes(input_list)
      result = calculate_basin_score(basins)
   else
      local low_points = get_low_points(input_list)
      result = sum_low_points(low_points)
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
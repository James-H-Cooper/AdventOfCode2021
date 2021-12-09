
local function get_starting_pos_from_input(file_name)
   local positions = {}
   for line in io.lines(file_name) do
      for character in string.gmatch(line,"([^,]+)") do
         local crab = tonumber(character)
         table.insert(positions, crab)
      end
   end   

   return positions
end

local function get_median_position(positions)
   local function sort_function(left,right) return left < right end
   table.sort(positions,sort_function)

   local mid_point = math.ceil(#positions/2)
   return positions[mid_point]
end

local function get_mean_position(positions)
   local total = 0
   for _,crab in ipairs(positions) do
      total = total + crab
   end
   
   local mean = total/#positions
   local median = get_median_position(positions)
   -- Round towards the median 
   if mean > median then
      mean = math.ceil(mean)
   else
      mean = math.floor(mean)
   end
   return mean
end

local function calculate_distances_to_point(positions,point,is_part_two)
   local total = 0
   if is_part_two then
      for _,crab in ipairs(positions) do
         -- Calculate
         local diff = math.abs(crab - point)
         for i=1,diff,1 do
            total = total + i
         end
      end
   else
      for _,crab in ipairs(positions) do
         total = total + math.abs(crab - point)
      end
   end

   return total
end

local function solution(file_name, is_part_two)
   local positions = get_starting_pos_from_input(file_name)
   local mid_point = 0
   if is_part_two then
      mid_point = get_mean_position(positions)
   else
      mid_point = get_median_position(positions)
   end
   local result = calculate_distances_to_point(positions,mid_point,is_part_two)

   print("Meet = " .. mid_point .. " Result = " .. result)
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
-- As with all these inputs, they assume indexing starts from 0 but in Lua it starts from 1
-- This is why we have 9 generations not 8 and why we increment all of the input
local function get_fish_from_input(file_name)
   local fish_table = {}
   local fish_generations = 9

   for i=1, fish_generations, 1 do
      table.insert(fish_table,0)
   end
   for line in io.lines(file_name) do
      for character in string.gmatch(line,"([^,]+)") do
         local fish = tonumber(character) + 1
         fish_table[fish] = fish_table[fish] + 1
      end
   end   

   return fish_table
end

local function process_fish_day(fish_table)
   local new_fish_count = fish_table[1]
   for i=1,#fish_table,1 do
      fish_table[i] = fish_table[i+1] 
   end

   fish_table[7] = fish_table[7] + new_fish_count
   fish_table[9] = new_fish_count

   return fish_table
end

-- Originally I was storing each fish as an element in the table but this was too slow for part 2. 
-- Instead, store 9 elements in the table representing the count of fish at that time
local function solution(file_name, is_part_two)
   local days_to_simulate
   if is_part_two then
      days_to_simulate = 256
   else
      days_to_simulate = 80
   end
   local fish_table = get_fish_from_input(file_name)
   for i=1, days_to_simulate, 1 do
      fish_table = process_fish_day(fish_table)
   end

   local result = 0
   for _, fish in ipairs(fish_table) do
      result = result + fish
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
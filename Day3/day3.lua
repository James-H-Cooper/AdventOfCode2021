local function create_table_from_input(file_name)
   --Covnert each binary string into a row of bits within the table
   local outside_table = {} 
   for line in io.lines(file_name) do
      local inside_table = {}
      for bit_value in line:gmatch(".") do
         table.insert(inside_table, bit_value)
      end
      table.insert(outside_table, inside_table)
   end

   return outside_table
end

local function create_bit_table_from_input_table(input_table)
      --Get the number of bits in each line (asusming all lines are the same length)
      local input_length = #input_table[1]
      local output_table = {}
   
      for i=1, input_length do
         -- For each bit we want to create a row in bit_table containing the binary value at that space
         local bit_table = {}
         for k, inner_table in ipairs(input_table) do
            table.insert(bit_table,k,inner_table[i])
         end
         table.insert(output_table,i,bit_table)
      end
   
      return output_table
end

local function get_most_common_bit(bit_table)
   local one_count = 0
   local zero_count = 0

   for _,bit in ipairs(bit_table) do
      if(bit == "0") then
         zero_count = zero_count + 1
      else
         one_count = one_count +1
      end
   end

   if(zero_count == one_count) then
      print("There is no definite most common value for this bit, returning 1 as per part 2")
      return "1"
   end

   if(zero_count > one_count) then
      return "0"
   else
      return "1"
   end

end

local function part_one(file_name)
   local input_table = create_table_from_input(file_name)
   local bit_table = create_bit_table_from_input_table(input_table)
   local gamma_bits = {}

   for i, inner_table in ipairs(bit_table) do
       local most_common_bit = get_most_common_bit(inner_table)
       table.insert(gamma_bits,i,most_common_bit)
   end

   local epsilon_bits = {}
   for i, bit in ipairs(gamma_bits) do
      if(bit == "1") then
         table.insert(epsilon_bits,i,"0")
      else
         table.insert(epsilon_bits,i,"1")
      end
   end
   local gamma_binary = table.concat(gamma_bits)
   local epsilon_binary = table.concat(epsilon_bits)

   local gamma_denary = tonumber(gamma_binary,2)
   local epsilon_denary = tonumber(epsilon_binary,2)

   local result = gamma_denary * epsilon_denary

   print("Gamma binary = " .. gamma_binary .. " Gamma denary = " .. gamma_denary)
   print("Epsilon binary = " .. epsilon_binary .. " Epsilon denary = " .. epsilon_denary)
   print("Result = " .. result)
end


local function get_least_common_bit(bit_table)
   local most_common = get_most_common_bit(bit_table)
   if(most_common == "1") then
      return "0"
   else
      return "1"
   end
end

local function remove_entires_without_bit_at_pos(input_table,bit_table,bit_to_keep,current_bit)
   -- iterate back to front so we can remove entries in place
   for i=#input_table, 1, -1 do
      if(input_table[i][current_bit] ~= bit_to_keep) then
         table.remove(input_table,i)

         -- remove the corresponding row from the bit table
         for _,bits in ipairs(bit_table) do
            table.remove(bits,i)
         end
      end
   end

   return input_table, bit_table
end

local function calculate_rating_based_on_criteria(file_name, is_oxygen)
   -- We should really take in the tables not the file and make a clone of them. 
   -- Since this isn't a real project it's easier to just reconstruct them
   local input_table = create_table_from_input(file_name)
   local bit_table = create_bit_table_from_input_table(input_table)

   local current_bit = 1
   -- While we don't have a single answer, keep looping
   while #input_table > 1 do
      if(current_bit > #input_table[1] ) then
         print("ERROR: More than 1 entry left after checking all bits, returning early.")
         return
      end

      local bit_to_keep = -1

      if is_oxygen then
         bit_to_keep = get_most_common_bit(bit_table[current_bit])
      else
         bit_to_keep = get_least_common_bit(bit_table[current_bit])
      end
      input_table, bit_table = remove_entires_without_bit_at_pos(input_table,bit_table,bit_to_keep,current_bit)

      current_bit = current_bit + 1
   end

   local binary = table.concat(input_table[1])
   local denery = tonumber(binary,2)

   return binary,denery
end

local function part_two(file_name)

   local oxygen_binary, oxygen_denery = calculate_rating_based_on_criteria(file_name,true)
   local carbon_binary, carbon_denery = calculate_rating_based_on_criteria(file_name,false)

   local result = carbon_denery * oxygen_denery

   print("Oxygen binary = " .. oxygen_binary .. " Oxygen denary = " .. oxygen_denery)
   print("Carbon binary = " .. carbon_binary .. " Carbon denary = " .. carbon_denery)
   print("Result = " .. result)
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
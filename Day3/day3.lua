-- FOR EACH LINE OF THE INPUT
-- HAVE A TABLE THAT MAPS NUMERICAL POSITION WITH THE BIT 
-- SO INPUT_TABLE[1] IS A TABLE OF ALL THE BITS IN THE FIRST POSITION 

-- ONCE WE HAVE THIS, ITERATE THROUGH EACH SUB TABLE TO FIND THE BITS FOR THE GAMMA (AS A STRING)
-- FLIP THAT AND STORE IT AS THE EPSILON 
-- USE tonumber() to get the actual values 

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

   --Get the number of bits in each line (asusming all lines are the same length)
   local input_length = #outside_table[1]
   local output_table = {}

   for i=1, input_length do
      -- For each bit we want to create a row in bit_table containing the binary value at that space
      local bit_table = {}
      for k, inner_table in ipairs(outside_table) do
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
      print("Invalid input: there is no definite most common value for this bit")
   end

   if(zero_count > one_count) then
      return "0"
   else
      return "1"
   end

end

local function part_one(file_name)
   local bit_table = create_table_from_input(file_name)
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

print("Sample Part 1")
part_one("sample.txt")

print("-------------------------")
print("Input Part 1")
part_one("input.txt")

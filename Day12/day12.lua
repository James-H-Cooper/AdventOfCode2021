local node = {name = nil; is_big = nil; connections = {};}

function node:new(o,name,is_big)
   o = o or {}
   setmetatable(o,self)
   self.__index = self
   o.name = name
   o.is_big = is_big
   o.connections = {}
   return o
end

function node:add_connection(new_connection)
   table.insert(self.connections,new_connection.name)
end

local function read_input(file_name)
   local inputs = {}
   for line in io.lines(file_name) do
      local line_input = {}
      for point in line:gmatch("([^-]+)") do
         table.insert(line_input, point)
      end
      table.insert(inputs,line_input)
   end 
   return inputs
end

local function add_new_node_to_map(map,node_name)
   local is_big = false
   if node_name == node_name:upper() then
      is_big = true
   end
   local node = node:new(nil,node_name,is_big)
   map[node_name] = node
   return map
end

local function convert_input_to_map(input)
   local map = {}
   for _,input_set in ipairs(input) do
      -- First add both to the map if they're not already
      if map[input_set[1]] == nil then
         map = add_new_node_to_map(map,input_set[1])
      end
      if map[input_set[2]] == nil then
         map = add_new_node_to_map(map,input_set[2])
      end
      map[input_set[1]]:add_connection(map[input_set[2]])
      map[input_set[2]]:add_connection(map[input_set[1]])
   end

   return map
end

local function explore_path(node_map,current_node,visited_nodes,is_allowed_small_visit)
   if visited_nodes == nil then
      visited_nodes = current_node.name
   else
      visited_nodes = visited_nodes .. "," .. current_node.name
   end

   if current_node.name == "end" then
      return 1
   end

   local total = 0
   for _,node_name in ipairs(current_node.connections) do
      local is_already_visited = false
      for visited in visited_nodes:gmatch("([^,]+)") do
         if visited == node_name then
            is_already_visited = true
         end
      end

      if not is_already_visited or node_map[node_name].is_big then
         total = total + explore_path(node_map,node_map[node_name],visited_nodes,is_allowed_small_visit)
      elseif is_allowed_small_visit and (not node_map[node_name].is_big and node_name ~= "start") then
         total = total + explore_path(node_map,node_map[node_name],visited_nodes,false)
      end
   end
   return total;
end

local function solution(file_name, is_part_two)
   local input = read_input(file_name)
   local node_map = convert_input_to_map(input)
   local result = explore_path(node_map,node_map["start"],nil,is_part_two)

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
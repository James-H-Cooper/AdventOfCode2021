local DOT_CHAR = "#"
local GRID_CHAR = "."
-- Increase all inputs by 1 because indexing starts at 1 not 0 in Lua
local function read_input(file_name)
   local grid_dots = {}
   local fold_instructions = {}
   local has_hit_empty_line = false
   for line in io.lines(file_name) do
      if line == "" then
         has_hit_empty_line = true
      else
         if has_hit_empty_line then
            -- Handle fold instructions
            local instruction = {}
            local number_to_insert = ""
            for character in line:gmatch(".") do
               if character == "x" or character == "y" then
                  table.insert(instruction,character)
               end
               if tonumber(character) ~= nil then
                  number_to_insert = number_to_insert .. character
               end
            end
            table.insert(instruction,tonumber(number_to_insert) + 1)
            table.insert(fold_instructions,instruction)
         else
            local line_input = {}
            for dot in line:gmatch("([^,]+)") do
               table.insert(line_input, tonumber(dot) + 1)
            end
            table.insert(grid_dots,line_input)
         end
      end
   end 
   return grid_dots, fold_instructions
end

local function mark_dot_on_grid(grid,dot)
   grid[dot[2]][dot[1]] = DOT_CHAR
   return grid
end

local function build_grid_from_inputs(grid_inputs)
   local grid = {}
   local max_x = 0
   local max_y = 0

   for _,coordinate_set in ipairs(grid_inputs) do
      max_x = math.max(coordinate_set[1], max_x)
      max_y = math.max(coordinate_set[2], max_y)
   end
   for i=1, max_y, 1 do
      local cells = {}
      for k=1, max_x, 1 do
         table.insert(cells,GRID_CHAR)
      end
      table.insert(grid,cells)
   end

   for _,dot in ipairs(grid_inputs) do
      grid = mark_dot_on_grid(grid,dot)
   end

   return grid
end

-- Creates a new grid based on the fold
-- Inserts all the dots into the correct place, removing overlapping dots
local function handle_fold(grid, fold_instruction)
   local lower_grid = {}
   local overlapping_grid = {}
   if fold_instruction[1] == "x" then
      for i=1, #grid, 1 do
         local lower_row = {}
         local overlapping_row = {}
         for k=1, #grid[i],1 do
            if k < fold_instruction[2] then
               table.insert(lower_row,grid[i][k])
            elseif k > fold_instruction[2] then
               table.insert(overlapping_row,grid[i][k])
            end
         end
         table.insert(lower_grid,lower_row)
         table.insert(overlapping_grid,overlapping_row)
      end
      
      if #lower_grid[1] < #overlapping_grid[1] then
         local temp = lower_grid
         lower_grid = overlapping_grid
         overlapping_grid = temp
      end
      
      for i, row in ipairs(lower_grid) do
         for k,point in ipairs(row) do
            local opposite_point = (#lower_grid[i]-k)+1
            if opposite_point <= #overlapping_grid[i] and overlapping_grid[i][opposite_point] == DOT_CHAR then
               lower_grid[i][k] = DOT_CHAR
            end 
         end
      end

      grid = lower_grid
   else
      for i=1, #grid, 1 do
         local row = {}
         for k=1, #grid[i],1 do
            table.insert(row,grid[i][k])
         end
         if i < fold_instruction[2] then  
            table.insert(lower_grid,row)
         elseif i > fold_instruction[2] then
            table.insert(overlapping_grid,row)
         end
      end

      if #lower_grid < #overlapping_grid then
         local temp = lower_grid
         lower_grid = overlapping_grid
         overlapping_grid = temp
      end
      for i, row in ipairs(lower_grid) do
         for k,point in ipairs(row) do
            local opposite_point = (#lower_grid-i)+1
            if opposite_point <= #overlapping_grid and overlapping_grid[opposite_point][k] == DOT_CHAR then
               lower_grid[i][k] = DOT_CHAR
            end 
         end
      end

      grid = lower_grid
   end

   return grid
end

local function count_dots_on_grid(grid)
   local total = 0
   for _, row in ipairs(grid) do
      for _, point in ipairs(row) do
         if point == DOT_CHAR then
            total = total + 1
         end
      end
   end
   return total
end

local function print_grid(grid)
   for _,row in ipairs(grid) do
      local output = ""
      for _,point in ipairs(row) do
         if point == DOT_CHAR then
            output = output .. DOT_CHAR
         else
            -- Use spaces so it's easier to read
            output = output .. " "
         end
      end
      print(output)
   end
end

local function solution(file_name, is_part_two)
   local dots,folds= read_input(file_name)
   local grid = build_grid_from_inputs(dots)
   print("Starting grid has " .. count_dots_on_grid(grid) .. " dots")
   if is_part_two then    
      for _,fold in ipairs(folds) do
         grid = handle_fold(grid,fold)
      end
   else
      grid = handle_fold(grid,folds[1])
   end
   local result = count_dots_on_grid(grid)
   print("Result = " .. result)
   if is_part_two then
      print_grid(grid)
   end
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
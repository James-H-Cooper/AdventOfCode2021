local function get_random_numbers_from_line(line)
   local random_numbers = {}
   for word in string.gmatch(line,"([^,]+)") do
      table.insert(random_numbers,word)
   end
   return random_numbers
end

local function read_input_from_file(file_name)
   local random_numbers = {}
   local boards = {}

   local empty_lines = 0
   local lines_since_empty = 0
   local board = {}
   for line in io.lines(file_name) do
      if line == "" then
         if empty_lines ~= 0 then
            table.insert(boards,board)
         end
         empty_lines = empty_lines + 1
         lines_since_empty = 0
         board = {}
      else
         lines_since_empty = lines_since_empty + 1
         -- First line is the random number input 
         if empty_lines ==  0 then
            random_numbers = get_random_numbers_from_line(line)
         else
            -- Otherwise it's a row that needs to be inserted into the board
            local row = {}
            local number_index = 1
            for number in line:gmatch("%w+") do
               table.insert(row,number_index,number)
               number_index = number_index + 1
            end
            table.insert(board,lines_since_empty,row)
         end 
      end
   end

   -- Add the last board (since we've fallen out of the loop as there's not empty line at the end)
   table.insert(boards,board)
   return random_numbers, boards
end

local function calculate_score(board)
   local score = 0
   for _,row in ipairs(board) do
      for i, digit in ipairs(row) do
         if digit ~= "marked" then
            score = score + digit
         end
      end  
   end

   return score
end

-- Return 0 if no win, otherwise return score
local function have_any_boards_won(boards)
   for _,board in ipairs(boards) do
      local columns_marked = {}
      local first_row = true
      for _,row in ipairs(board) do
         local is_row_marked = true
         for i, digit in ipairs(row) do
            if first_row then
               table.insert(columns_marked,i,true)
            end
            if(digit ~= "marked") then
               is_row_marked = false;
               columns_marked[i] = false
            end
         end
         if is_row_marked then
            return calculate_score(board)
         end
         first_row = false
      end

      for _,column in ipairs(columns_marked) do
         if column == true then
            return calculate_score(board)
         end
      end
   end

   return 0
end  

-- replace number with the word "marked"
local function mark_number_on_boards(number,boards)
   for _,board in ipairs(boards) do
      for _,row in ipairs(board) do
         for i, digit in ipairs(row) do
            if digit == number then
               row[i] = "marked"
            end
         end  
      end
   end
end

local function part_one(file_name)
   local random_numbers, boards = read_input_from_file(file_name)

   for _,number in ipairs(random_numbers) do
      mark_number_on_boards(number,boards)
      local winner_score = have_any_boards_won(boards)
      if winner_score ~= 0 then
         local final_score = winner_score * number
         print("A board has won, board score = " .. winner_score .. " * number = " .. number .. " final score = " .. final_score)
         return
      end
   end

   print("No winners in input data")
end

print("Sample Part 1")
part_one("sample.txt")

print("-------------------------")
print("Input Part 1")
part_one("input.txt")
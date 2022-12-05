local util = require "util"

local function read_stacks(filename)
  local stacks = {}
  local lines = util.lines_from_file(filename)

  local pat = lines[1]

  for i = 2, #lines do
    local t = table.pack(string.match(lines[i], pat))
    for j, v in ipairs(t) do
      t[j] = string.match(v, "[(%u)]")
      if (stacks[j]) then
        stacks[j][#stacks[j]+1] = t[j]
      else
        stacks[j] = { t[j] }
      end
    end
  end

  for i, stack in ipairs(stacks) do
    reversed = {}
    for j = #stack, 1, -1 do
      reversed[#reversed+1] = stack[j]
    end
    stacks[i] = reversed
  end

  return stacks
end

local function read_moves(filename)
  local moves = {}
  local lines = util.lines_from_file(filename)

  for _, line in ipairs(lines) do
    local a, b, c = string.match(line, "^move (%d+) from (%d+) to (%d+)$")
    moves[#moves+1] = { tonumber(a), tonumber(b), tonumber(c), }
  end

  return moves
end

local function apply_move(stacks, move)
  local a, b, c = table.unpack(move)
  local f, t = stacks[b], stacks[c]
  for i = 1, a do
    t[#t+1] = f[#f]
    f[#f] = nil   
  end
end

local function apply_multi_move(stacks, move)
  local a, b, c = table.unpack(move)
  local f, t = stacks[b], stacks[c]
  local fl = #f
  for i = fl - a + 1, fl do
    t[#t+1] = f[i]
    f[i] = nil
  end
end

local function apply_moves(stacks, moves, multi)
  local move_fun = multi and apply_multi_move or apply_move
  for _, move in ipairs(moves) do
    move_fun(stacks, move)
  end
end

return {
  read_stacks = read_stacks,
  read_moves = read_moves,
  apply_moves = apply_moves,
}

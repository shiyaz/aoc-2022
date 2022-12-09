local function read_moves (input)
  local moves = {}
  for _, line in ipairs(input) do
    local dir, steps = string.match(line, "^(%u)%s(%d+)$")
    moves[#moves+1] = { dir, tonumber(steps) }
  end
  return moves
end

local function follow_head(tail, head)
  if math.abs(head.x - tail.pos.x) <= 1 and math.abs(head.y - tail.pos.y) <= 1 then 
    return { x = tail.pos.x, y = tail.pos.y }
  end

  local same_row = head.y == tail.pos.y
  local same_col = head.x == tail.pos.x

  if same_row and head.x > tail.pos.x then
    return { x = tail.pos.x + 1, y = tail.pos.y }
  end

  if same_row and head.x < tail.pos.x then
    return { x = tail.pos.x - 1, y = tail.pos.y }
  end

  if same_col and head.y > tail.pos.y then
    return { x = tail.pos.x, y = tail.pos.y + 1 }
  end

  if same_col and head.y < tail.pos.y then
    return { x = tail.pos.x, y = tail.pos.y - 1 }
  end

  if head.x < tail.pos.x and head.y < tail.pos.y then
    return { x = tail.pos.x - 1, y = tail.pos.y - 1 }
  end

  if head.x < tail.pos.x and head.y > tail.pos.y then
    return { x = tail.pos.x - 1, y = tail.pos.y + 1 }
  end

  if head.x > tail.pos.x and head.y > tail.pos.y then
    return { x = tail.pos.x + 1, y = tail.pos.y + 1 }
  end

  if head.x > tail.pos.x and head.y < tail.pos.y then
    return { x = tail.pos.x + 1, y = tail.pos.y - 1 }
  end
end

local function apply_move (move, head, tails)
  local dir, steps = table.unpack(move)

  for s = 1, steps do
    if dir == "L" then
      head = { x = head.x - 1, y = head.y }
    elseif dir == "R" then
      head = { x = head.x + 1, y = head.y }
    elseif dir == "U" then
      head = { x = head.x, y = head.y + 1 }
    elseif dir == "D" then
      head = { x = head.x, y = head.y - 1 }
    else
      goto continue
    end

    local prev = head

    for _, t in ipairs(tails) do
      t.pos = follow_head(t, prev)
      prev = t.pos
      local tk = t.pos.x..","..t.pos.y
      t.trail[tk] = (t.trail[tk] or 0) + 1
    end 

    ::continue::
  end

  return head, tails
end

local function apply_moves (moves, knots, start)
  knots = knots or 2
  start = start or { x = 0, y = 0 }

  local head = { x = start.x, y = start.y }

  local tails = {}

  for k = 1, knots - 1 do
    tails[#tails+1] = { pos = { x = start.x, y = start.y }, trail = { [start.x..","..start.y] = 1 } }
  end
  
  for _, move in ipairs(moves) do
    head, tails = apply_move(move, head, tails)
  end

  return head, tails
end

return {
  read_moves = read_moves,
  apply_move = apply_move,
  apply_moves = apply_moves,
}
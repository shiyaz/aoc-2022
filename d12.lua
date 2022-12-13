local A = string.byte("a")

local function shortest_path (map, start, dest)
  local queue_meta = {
    push = function (self, item)
      table.insert(self, 1, item)
    end,
    pop = function (self)
      return table.remove(self)
    end,
    is_empty = function (self)
      return #self == 0
    end
  }

  queue_meta.__index = queue_meta

  local function make_queue (...)
    return setmetatable({...}, queue_meta)
  end

  local function backtrack (pos, prevs)
    local path = make_queue()

    repeat
      path:push(pos)
      pos = prevs[pos]
    until not pos

    return path
  end

  local function visit (pos, queue, visited, prevs)
    for _, neighbour in ipairs(map:neighbours(pos)) do
      if not visited[neighbour] then
        queue:push(neighbour)
        visited[neighbour] = true
        prevs[neighbour] = pos
      end
    end
  end

  local curr, queue, visited, prevs = start, make_queue(start), { [start] = true }, {}

  while not queue:is_empty() do
    local pos = queue:pop()

    if pos == dest then
      return backtrack(pos, prevs)
    end

    visit(pos, queue, visited, prevs)
  end
end

local function get_pos(map, x, y)
  return map[map.xmax*(y-1)+x]
end

local function neighbours(map, pos)
  local x, y, h = table.unpack(pos)

  local options = { { x-1, y }, { x, y-1 }, { x+1, y }, { x, y+1 }, }

  local results = {}

  local function is_bounded(nx, ny)
    return nx >= 1 and nx <= map.xmax and ny >= 1 and ny <= map.ymax
  end

  local function is_ok_step(next_pos)
    return next_pos[3] <= h + 1
  end

  for _, option in ipairs(options) do
    local nx, ny = table.unpack(option)

    if is_bounded(nx, ny) then
      local next_pos = map:get_pos(nx, ny)

      if is_ok_step(next_pos) then
        results[#results+1] = next_pos
      end
    end
  end

  return results
end

local function load(text)
  local map = { ymax = #text, xmax = 0, get_pos = get_pos, neighbours = neighbours, shortest_path = shortest_path, }

  for y, line in ipairs(text) do
    local x = 1

    for c in line:gmatch(".") do
      local h = string.byte(c) - A
      local pos = { x, y, h,  }

      if c == "S" then
        pos[3], map.s = 0, pos
      elseif c == "E" then
        pos[3], map.e = 25, pos
      end

      map[#map+1] = pos

      if x > map.xmax then
        map.xmax = x
      end

      x = x + 1
    end
  end

  return map
end

return {
  load = load,
}
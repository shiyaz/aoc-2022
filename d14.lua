local Point = {
  x = 0, y = 0, hash = 0,
  __eq = function (self, other)
    return self.x == other.x and self.y == other.y
  end,
  __tostring = function (self)
    return "("..self.x..","..self.y..")  [#"..self.hash.."]"
  end,
  __call = function (cls, x, y)
    x, y = x or 0, y or 0
    local hash = (x * 0x1f1f1f1f) ~ y
    return setmetatable({ x = x, y = y, hash = hash, }, cls)
  end,
}

setmetatable(Point, Point)

local PriorityQueue = {
  __index = {
    is_empty = function (self)
      for p, q in pairs(self) do
        if q.first <= q.last then
          return false
        end
      end
      return true
    end,
    put = function (self, p, v)
      local q = self[p]
      if not q then
        q = {first = 1, last = 0}
        self[p] = q
      end
      q.last = q.last + 1
      q[q.last] = v
    end,
    pop = function (self)
      for p, q in pairs(self) do
        if q.first <= q.last then
          local v = q[q.first]
          q[q.first] = nil
          q.first = q.first + 1
          return v, p
        else
          self[p] = nil
        end
      end
    end
  },
  __call = function (cls)
    return setmetatable({}, cls)
  end
}

setmetatable(PriorityQueue, PriorityQueue)

local Graph = {
  __index = {
    shortest_path = function (self, src, dest)
      local q, prevs, costs = PriorityQueue(), { }, { [src.hash] = 0 }
      local curr = src
      q:put(0, curr)

      local function backtrack (pos)
        local path = {}
        repeat 
          table.insert(path, 1, pos)
          pos = prevs[pos.hash]
        until pos == nil
        return path
      end
    
      while not q:is_empty() do
        curr, _ = q:pop()
    
        if curr == dest then
          return backtrack(curr), curr, true
        end

        local neighbours = self:neighbours(curr)

        if not neighbours then
          return nil, nil, false
        end

        for _, nxt in ipairs(self:neighbours(curr)) do
          local cost = costs[curr.hash] + self:cost(curr, nxt)
          if not costs[nxt.hash] or cost < costs[nxt.hash] then
            costs[nxt.hash] = cost
            local p = cost + self:heuristic(dest, nxt)
            q:put(p, nxt)
            prevs[nxt.hash] = curr
          end
        end
      end

      return backtrack(curr), curr, false
    end,
    cost = function (self, a, b)
      return math.huge
    end,
    neighbours = function (self, a)
      return nil
    end,
    heuristic = function (self, a, b)
      return 0
    end
  },
  __call = function (cls, o)
    return setmetatable(o or {}, cls)
  end
}

setmetatable(Graph, Graph)

local function map_cave_system(text)
  local deltas = { { x = 0, y = 1, }, { x = -1, y = 1, }, { x = 1, y = 1, }}
  local rocks = {}
  local cave = Graph { 
    rocks = rocks,
    rock_bottom = 0,
    floor = nil,
    sand = {},
    is_blocked = function (self, x, y)
      return (self.rocks[x] and self.rocks[x][y]) or (self.sand[x] and self.sand[x][y]) or (self.floor and y >= self.floor) or false
    end,
    neighbours = function (self, a)
      if not self.floor and a.y >= self.rock_bottom then
        return nil
      end

      for _, delta in ipairs(deltas) do
        local x, y = a.x + delta.x, a.y + delta.y
        if not self:is_blocked(x, y) then
          return { Point(x, y), }
        end
      end

      return {}
    end,
    pour_sand_unit = function (self, x, y)
      local _, at, _ = self:shortest_path(Point(x, y), Point(x, -1))
      if at then
        self.sand[at.x] = self.sand[at.x] or {}
        self.sand[at.x][at.y] = true
        return at
      end
    end
  }

  local min, max = math.min, math.max

  local function coords (str)
    local x, y = str:match("^(%d+),(%d+)")
    return tonumber(x), tonumber(y)
  end

  for _, line in ipairs(text) do
    local sx, sy
    for s in line:gmatch("%d+,%d+") do
      local nx, ny = coords(s)

      if sx then
        for x = min(sx, nx), max(sx, nx) do
          for y = min(sy, ny), max(sy, ny) do
            rocks[x] = rocks[x] or {}
            rocks[x][y] = true
          end
        end
      end

      if ny > cave.rock_bottom then
        cave.rock_bottom = ny
      end 

      sx, sy = nx, ny
    end
  end

  return cave
end

return {
  map_cave_system = map_cave_system,
  Point = Point,
}
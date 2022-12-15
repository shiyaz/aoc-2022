local Point = {
  x = 0, y = 0, hash = 0,
  __index = {
    manhattan_distance = function (self, other)
      return math.abs(self.x - other.x) + math.abs(self.y - other.y)
    end,
  },
  __eq = function (self, other)
    return self.x == other.x and self.y == other.y
  end,
  __tostring = function (self)
    return "("..self.x..","..self.y..")"
  end,
  __call = function (cls, x, y)
    x, y = tonumber(x or 0), tonumber(y or 0)
    local hash = (x * 0x1f1f1f1f) ~ y
    return setmetatable({ x = x, y = y, hash = hash, }, cls)
  end,
}

setmetatable(Point, Point)

local function deploy_sensors (text)
  local pat = "^Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)$"
  local sensors = {}

  for _, line in ipairs(text) do
    local sx, sy, bx, by = line:match(pat)
    local loc, b = Point(sx, sy), Point(bx, by)
    local s = { loc = loc, b = b, d = loc:manhattan_distance(b), }
    table.insert(sensors,  s)
  end

  local min, max = math.min, math.max

  local function solve(lx, ly, y, sd)
    local c = math.abs(ly - y) - sd

    if c > 0 then
      return nil, nil
    else
      return lx - c, lx + c
    end
  end

  sensors.xrange = function (self, y)
    local segments = {}

    for i, s in ipairs(self) do
      local loc = s.loc
      local ax, bx = solve(loc.x, loc.y, y, s.d)
      if ax and bx then
        table.insert(segments, { min(ax, bx), max(ax, bx) })
      end
    end

    table.sort(segments, function (a, b)
      return a[1] < b[1]
    end)

    local ct = 0

    local covered = { }

    for _, seg in ipairs(segments) do
      local ax, bx = table.unpack(seg)
      if #covered == 0 then
        table.insert(covered, { Point(ax, y), Point(bx, y) }) 
        ct = bx - ax
      else
        local pseg = covered[#covered]
        local pax, pbx = pseg[1].x, pseg[2].x

        if ax <= pbx then
          if bx > pbx then
            ct = ct + bx - pbx
            pseg[2] = Point(bx, y)
          end
        else
          ct = ct + bx - ax
          table.insert(covered, { Point(ax, y), Point(bx, y) })
        end
      end
    end

    return covered, ct
  end

  sensors.find_distress_loc = function (self, xmax, ymax)
    local unscanned = {}

    for y = 0, ymax do
      local fx = nil
      for _, rs in ipairs(self:xrange(y)) do
        if not fx then
          fx = rs[1].x + 1
        end
        for rx = fx, rs[1].x - 1 do
          if rx >= 0 and rx <= xmax then
            unscanned[rx+y*xmax] = true
          end
        end
        fx = rs[2].x + 1
      end
    end

    local x, y

    for xy, _ in pairs(unscanned) do
      x, y = xy%xmax, xy//xmax
    end

    return Point(x, y)
  end

  return sensors
end

return {
  Point = Point,
  deploy_sensors = deploy_sensors,
}
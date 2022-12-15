local util = require "util"
local d14 = require "d14"

local Point = d14.Point

describe("day 14", function ()
  describe("part a", function ()
    it("can map cave system", function ()
      local text = util.lines_from_file("d14a_test.txt")
      local map = d14.map_cave_system(text)
      assert.is.equal(true, map:is_blocked(498, 4))
      assert.is.equal(true, map:is_blocked(498, 5))
      assert.is.equal(true, map:is_blocked(498, 6))
      assert.is.equal(false, map:is_blocked(498, 7))
      assert.is.equal(true, map:is_blocked(497, 6))
      assert.is.equal(true, map:is_blocked(496, 6))
      assert.is.equal(false, map:is_blocked(495, 6))
      assert.is.equal(true, map:is_blocked(502, 9))
      assert.is.equal(false, map:is_blocked(503, 9))
      assert.is.equal(9, map.rock_bottom)
    end)
    it("with test input", function ()
      local text = util.lines_from_file("d14a_test.txt")
      local map = d14.map_cave_system(text)
      local ct = 0
      while true do
        stopped_at = map:pour_sand_unit(500, 0)
        if not stopped_at then
          break
        end
        ct = ct + 1
      end
      assert.is.equal(24, ct)
    end)
    it("actual input", function ()
      local text = util.lines_from_file("d14_input.txt")
      local map = d14.map_cave_system(text)
      local ct = 0
      while true do
        stopped_at = map:pour_sand_unit(500, 0)
        if not stopped_at then
          break
        end
        ct = ct + 1
      end
      assert.is.equal(728, ct)
    end)
  end)
  describe("part b", function ()
    it("with test input", function ()
      local text = util.lines_from_file("d14a_test.txt")
      local map = d14.map_cave_system(text)
      map.floor = map.rock_bottom + 2
      local ct = 0
      while true do
        stopped_at = map:pour_sand_unit(500, 0)
        ct = ct + 1
        if stopped_at == Point(500, 0) then
          break
        end
      end
      assert.is.equal(93, ct)
    end)
    it("actual input", function ()
      local text = util.lines_from_file("d14_input.txt")
      local map = d14.map_cave_system(text)
      map.floor = map.rock_bottom + 2
      local ct = 0
      while true do
        stopped_at = map:pour_sand_unit(500, 0)
        ct = ct + 1
        if stopped_at == Point(500, 0) then
          break
        end
      end
      assert.is.equal(27623, ct)
    end)
  end)
end)
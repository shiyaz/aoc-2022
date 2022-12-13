local util = require "util"
local d12 = require "d12"

describe("day 12", function  ()
  describe("part a", function ()
    it("can read the height map", function ()
      local text = util.lines_from_file("d12a_test.txt")
      local map = d12.load(text)
      local _, _, h = table.unpack(map:get_pos(8, 5))
      assert.are.same({1, 1, 0}, map.s)
      assert.are.same({6, 3, 25}, map.e)
      assert.are.equal(5, map.ymax)
      assert.are.equal(8, map.xmax)
      assert.are.equal(8, h)
      assert.are.equal(40, #map)
    end)
    it("can find the shortest path between s and e", function ()
      local text = util.lines_from_file("d12a_test.txt")
      local map = d12.load(text)
      local path = map:shortest_path(map.s, map.e)
      assert.are.equal(31, #path - 1)
    end)
    it("with actual input", function ()
      local text = util.lines_from_file("d12_input.txt")
      local map = d12.load(text)
      local path = map:shortest_path(map.s, map.e)
      assert.are.equal(391, #path - 1)
    end)
  describe("part b", function ()
    it("can find the shortest path between optimal s and e", function ()
      local text = util.lines_from_file("d12a_test.txt")
      local map = d12.load(text)
      local min_dist = math.huge
      for _, s in ipairs(map) do
        if s[3] == 0 then
          local path = map:shortest_path(s, map.e)
          if path and min_dist > #path - 1 then
            min_dist = #path - 1
          end
        end
      end
      assert.are.equal(29, min_dist)
    end)
    it("with actual input", function ()
      local text = util.lines_from_file("d12_input.txt")
      local map = d12.load(text)
      local min_dist = math.huge
      for _, s in ipairs(map) do
        if s[3] == 0 then
          local path = map:shortest_path(s, map.e)
          if path and min_dist > #path - 1 then
            min_dist = #path - 1
          end
        end
      end
      assert.are.equal(386, min_dist)
    end)
  end)
  end)
end)
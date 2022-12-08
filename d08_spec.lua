local util = require "util"
local d08 = require "d08"

describe("day 2", function ()
  describe("part a", function ()
    it("can find trees visible from the outside", function ()
      local input = util.lines_from_file("d08a_test.txt")
      local grid = d08.create_tree_grid(input)
      local visible_count = grid:visible_tree_count()
      assert.is.equal(5, grid.width)
      assert.is.equal(5, grid.height)
      assert.is.equal(25, #grid.xs)
      assert.is.equal(25, #grid.ys)
      assert.is.equal(25, #grid.hs)
      assert.is.equal(21, visible_count)
    end)
    it("with actual input", function ()
      local input = util.lines_from_file("d08_input.txt")
      local grid = d08.create_tree_grid(input)
      local visible_count = grid:visible_tree_count()
      assert.is.equal(1736, visible_count)
    end)
  end)
  describe("part b", function ()
    it("can find the maximum scenic score for any tree in test input", function ()
      local input = util.lines_from_file("d08a_test.txt")
      local grid = d08.create_tree_grid(input)
      local max_score = grid:max_tree_scenic_score()
      assert.is.equal(8, max_score)
    end)
    it("with actual input", function ()
      local input = util.lines_from_file("d08_input.txt")
      local grid = d08.create_tree_grid(input)
      local max_score = grid:max_tree_scenic_score()
      assert.is.equal(8, max_score)
    end)
  end)
end)

local d09 = require "d09"
local util = require "util"

describe("day 9", function ()
  describe("part a", function ()
    it("can do a move", function ()
      local move = { "L", 3 }
      local head, tails = { x = 0, y = 0 }, { { pos = { x = 0, y = 0 }, trail = { ["0,0"] = 1 } } }
      local head, tails = d09.apply_move(move, head, tails)
      assert.same({ x = -3, y = 0 }, head)
      assert.same({ x = -2, y = 0 }, tails[1].pos)
    end)
    it("can find the unique positions the tail visited", function ()
      local input = util.lines_from_file("d09a_test.txt")
      local moves = d09.read_moves(input)
      assert.are.equal(8, #moves)
      local head, tails = d09.apply_moves(moves)
      assert.same(head, {x = 2, y = 2})
      assert.same(tails[1].pos, {x = 1, y = 2})
      local visited = 0
      for _, _ in pairs(tails[1].trail) do
        visited = visited + 1
      end
      assert.equal(13, visited)
    end)
    it("with actual input", function ()
      local input = util.lines_from_file("d09_input.txt")
      local moves = d09.read_moves(input)
      local head, tails = d09.apply_moves(moves)
      local visited = 0
      for _, _ in pairs(tails[1].trail) do
        visited = visited + 1
      end
      assert.equal(6642, visited)
    end)
  end)
  describe("part b", function ()
    it("can find the unique positions the tail visited", function ()
      local input = util.lines_from_file("d09b_test.txt")
      local knots, moves = 10, d09.read_moves(input)
      assert.are.equal(8, #moves)
      local head, tails = d09.apply_moves(moves, knots)
      assert.same(head, {x = -11, y = 15})
      assert.same(tails[knots - 1].pos, {x = -11, y = 6})
      local visited = 0
      for _, _ in pairs(tails[knots - 1].trail) do
        visited = visited + 1
      end
      assert.equal(36, visited)
    end)
    it("with actual input", function ()
      local input = util.lines_from_file("d09_input.txt")
      local knots, moves = 10, d09.read_moves(input)
      local head, tails = d09.apply_moves(moves, knots)
      local visited = 0
      for _, _ in pairs(tails[knots - 1].trail) do
        visited = visited + 1
      end
      assert.equal(2765, visited)
    end)
  end)
end)

local d05 = require "d05"
local util = require "util"

describe("day 5", function ()
  describe("part a", function ()
    it("can read stacks input", function ()
      local stacks = d05.read_stacks("d05a_test_stacks.txt")
      assert.same({ { "Z", "N", }, { "M", "C", "D", }, { "P", }, }, stacks)
    end)
    it("can read moves input", function ()
      local moves = d05.read_moves("d05a_test_moves.txt")
      assert.same({ { 1, 2, 1, }, { 3, 1, 3, }, { 2, 2, 1, }, { 1, 1, 2, } }, moves)
    end)
    it("can apply the crate moves on the given stacks", function ()
      local stacks = d05.read_stacks("d05a_test_stacks.txt")
      local moves = d05.read_moves("d05a_test_moves.txt")
      d05.apply_moves(stacks, moves)
      assert.are.equal("CMZ" , table.concat({ stacks[1][#stacks[1]], stacks[2][#stacks[2]], stacks[3][#stacks[3]], }, ""))
    end)
    it("with actual input", function ()
      local stacks = d05.read_stacks("d05_input_stacks.txt")
      local moves = d05.read_moves("d05_input_moves.txt")
      d05.apply_moves(stacks, moves)
      assert.are.equal(
        "TQRFCBSJJ", 
        table.concat({
          stacks[1][#stacks[1]], stacks[2][#stacks[2]], stacks[3][#stacks[3]],
          stacks[4][#stacks[4]], stacks[5][#stacks[5]], stacks[6][#stacks[6]],
          stacks[7][#stacks[7]], stacks[8][#stacks[8]], stacks[9][#stacks[9]], 
        }, "")
      )
    end)
  end)
  describe("part 2", function ()
    it("with test input", function ()
      local stacks = d05.read_stacks("d05a_test_stacks.txt")
      local moves = d05.read_moves("d05a_test_moves.txt")
      d05.apply_moves(stacks, moves, true)
      assert.are.equal("MCD" , table.concat({ stacks[1][#stacks[1]], stacks[2][#stacks[2]], stacks[3][#stacks[3]], }, ""))
    end)
    it("with actual input", function ()
      local stacks = d05.read_stacks("d05_input_stacks.txt")
      local moves = d05.read_moves("d05_input_moves.txt")
      d05.apply_moves(stacks, moves, true)
      assert.are.equal(
        "RMHFJNVFP", 
        table.concat({
          stacks[1][#stacks[1]], stacks[2][#stacks[2]], stacks[3][#stacks[3]],
          stacks[4][#stacks[4]], stacks[5][#stacks[5]], stacks[6][#stacks[6]],
          stacks[7][#stacks[7]], stacks[8][#stacks[8]], stacks[9][#stacks[9]], 
        }, "")
      )
    end)
  end)
end)
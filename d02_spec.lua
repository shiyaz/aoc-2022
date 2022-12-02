local d02 = require "d02"
local util = require "util"

describe("day 2", function ()
  describe("part a", function ()
    it("we can find the scores for a game", function ()
      local player1_score, player2_score = d02.score_game("R Y")
      assert.are.equal(1, player1_score)
      assert.are.equal(8, player2_score)
    end)

    it("we can find the final scores for the games", function ()
      local input = util.lines_from_file("d02a_test.txt")
      local _, my_score = d02.score_games(input)
      assert.are.equal(15, my_score)
    end)

    it("test with actual input", function ()
      local input = util.lines_from_file("d02_input.txt")
      local _, my_score = d02.score_games(input)
      assert.are.equal(10994, my_score)
    end) 
  end)

  describe("part b", function ()
    local strategy = d02.second_strategy

    it("we can find the final scores for the games", function ()
      local input = util.lines_from_file("d02a_test.txt")
      local _, my_score = d02.score_games(input, strategy)
      assert.are.equal(12, my_score)
    end)

    it("test with actual input", function ()
      local input = util.lines_from_file("d02_input.txt")
      local _, my_score = d02.score_games(input, strategy)
      assert.are.equal(12526, my_score)
    end) 
  end)

end)

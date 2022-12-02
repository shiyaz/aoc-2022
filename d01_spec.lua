local d01 = require "d01"
local util = require "util"

describe("day 1", function ()
  describe("part a", function ()
    it("we can find the elf carrying the most calories from the inventory", function ()
      local input = util.lines_from_file("d01a_test.txt")
      local pick = d01.elf_with_the_most(input)
      assert.are.equal(24000, pick:calories_carried())
    end)

    it("test with actual input", function ()
      local input = util.lines_from_file("d01a_input.txt")
      local pick = d01.elf_with_the_most(input)
      assert.are.equal(69693, pick:calories_carried())
    end) 
  end)

  describe("part b", function ()
    it("we can find the 3 elves carrying the most calories from the inventory", function ()
      local input = util.lines_from_file("d01a_test.txt")
      local picks = d01.three_elves_with_the_most(input)
      local calories = picks[1]:calories_carried() + picks[2]:calories_carried() + picks[3]:calories_carried()
      assert.are.equal(45000, calories)
    end)

    it("test with actual input", function ()
      local input = util.lines_from_file("d01a_input.txt")
      local picks = d01.three_elves_with_the_most(input)
      local calories = picks[1]:calories_carried() + picks[2]:calories_carried() + picks[3]:calories_carried()
      assert.are.equal(200945, calories)
    end) 
  end)
end)

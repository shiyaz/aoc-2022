local d03 = require "d03"
local util = require "util"

describe("day 3", function ()
  describe("part a", function ()
    it("we can find the shared item in a rucksack", function ()
      local shared_item, shared_item_priority = d03.find_shared_item("vJrwpWtwJgWrhcsFMMfFFhFp")
      assert.are.equal("p", shared_item)
      assert.are.equal(16, shared_item_priority) 
    end)
    it("we can find the shared item in a list of rucksacks", function ()
      local input = util.lines_from_file("d03a_test.txt")
      local items, sum_of_item_priorities = d03.find_shared_items(input)

      assert.are.equal("pLPvts", items)
      assert.are.equal(157, sum_of_item_priorities) 
    end)
    it("test with actual input", function ()
      local input = util.lines_from_file("d03_input.txt")
      local _, sum_of_item_priorities = d03.find_shared_items(input)

      assert.are.equal(8018, sum_of_item_priorities) 
    end)
  end)
  describe("part b", function ()
    it("we can find the badges in a list of rucksacks", function ()
      local input = util.lines_from_file("d03a_test.txt")
      local badges, sum_of_badge_priorities = d03.find_badges(input)

      assert.are.equal("rZ", badges)
      assert.are.equal(70, sum_of_badge_priorities) 
    end)
    it("test with actual input", function ()
      local input = util.lines_from_file("d03_input.txt")
      local _, sum_of_badge_priorities = d03.find_badges(input)

      assert.are.equal(2518, sum_of_badge_priorities) 
    end)
  end)

end)
local d01 = require "d01"
local util = require "util"

describe("day 1", function ()
    describe("part a", function ()
        it("we can find the elf carrying the most calories from the inventory", function ()
            local input = util.linesFromFile("d01a_test.txt")
            local pick = d01.elfWithTheMost(input)
            assert.are.equal(24000, pick:caloriesCarried())
        end)
    
        it("test with actual input", function ()
            local input = util.linesFromFile("d01a_input.txt")
            local pick = d01.elfWithTheMost(input)
            assert.are.equal(69693, pick:caloriesCarried())
        end) 
    end)

    describe("part b", function ()
        it("we can find the 3 elves carrying the most calories from the inventory", function ()
            local input = util.linesFromFile("d01a_test.txt")
            local picks = d01.threeElvesWithTheMost(input)
            local calories = picks[1]:caloriesCarried() + picks[2]:caloriesCarried() + picks[3]:caloriesCarried()
            assert.are.equal(45000, calories)
        end)
    
        it("test with actual input", function ()
            local input = util.linesFromFile("d01a_input.txt")
            local picks = d01.threeElvesWithTheMost(input)
            local calories = picks[1]:caloriesCarried() + picks[2]:caloriesCarried() + picks[3]:caloriesCarried()
            assert.are.equal(200945, calories)
        end) 
    end)
end)

local util = require "util"
local d10 = require "d10"

describe("day 10", function ()
  describe("part a", function ()
    it("can load a program from text", function ()
      local text = util.lines_from_file("d10a_test.txt")
      local m = d10.load(text)

      assert.is.equal(146, #m)
      assert.is.equal(m.X, 1)
      assert.is.equal(m.cycle, 0)
      assert.is.equal(m.pc, 1)

      local strengths = 0

      for cycle, X in d10.run(m) do
        if cycle == 20 then
          strengths = strengths + cycle*X
        end
        if cycle == 60 then
          strengths = strengths + cycle*X
        end
        if cycle == 100 then
          strengths = strengths + cycle*X
        end
        if cycle == 140 then
          strengths = strengths + cycle*X
        end
        if cycle == 180 then
          strengths = strengths + cycle*X
        end
        if cycle == 220 then
          strengths = strengths + cycle*X
        end
      end

      assert.is.equal(13140, strengths)
    end)
    it("actual input", function ()
      local text = util.lines_from_file("d10_input.txt")
      local m = d10.load(text)

      local strengths = 0

      for cycle, X in d10.run(m) do
        print(cycle, X)
        if cycle == 20 then
          strengths = strengths + cycle*X
        end
        if cycle == 60 then
          strengths = strengths + cycle*X
        end
        if cycle == 100 then
          strengths = strengths + cycle*X
        end
        if cycle == 140 then
          strengths = strengths + cycle*X
        end
        if cycle == 180 then
          strengths = strengths + cycle*X
        end
        if cycle == 220 then
          strengths = strengths + cycle*X
        end
      end

      assert.is.equal(13720, strengths)
    end)
  end)
  describe("part b", function ()
    it("actual input", function ()
      local text = util.lines_from_file("d10_input.txt")
      local m = d10.load(text)

      local c, l = 0, 1
      local lines = { {}, {}, {}, {}, {}, {}, }

      print("")

      for cycle, X in d10.run(m) do
        local c = cycle % 40
        if c >= X and c <= X + 2 then
          lines[l][c] = "#"
        else
          lines[l][c] = " "
        end
        if cycle == 40 then
          print(table.concat(lines[l], ""))
          l = l + 1
        end
        if cycle == 80 then
          print(table.concat(lines[l], ""))
          l = l + 1
        end
        if cycle == 120 then
          print(table.concat(lines[l], ""))
          c, l = 0, l + 1
        end
        if cycle == 160 then
          print(table.concat(lines[l], ""))
          c, l = 0, l + 1
        end
        if cycle == 200 then
          print(table.concat(lines[l], ""))
          c, l = 0, l + 1
        end
        if cycle == 240 then
          c = 0
        end
      end
      print(table.concat(lines[l], ""))
    end)
  end)
end)
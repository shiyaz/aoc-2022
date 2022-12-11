local d07 = require "d07"
local util = require "util"

describe("day 7", function ()
  describe("part a", function ()
    it("read fs transcript", function ()
      local input = util.lines_from_file("d07a_test.txt")
      local dirs, file_table, dir_table = d07.fs_from_transcript(input)

      assert.is.equal(4, #dirs)

      for _, dir in ipairs(dirs) do
        if dir[1] == "e" then
          assert.is.equal(584, dir[3])
        end
        if dir[1] == "a" then
          assert.is.equal(94853, dir[3])
        end
        if dir[1] == "d" then
          assert.is.equal(24933642, dir[3])
        end
        if dir[1] == "/" then
          assert.is.equal(48381165, dir[3])
        end
      end
    end)
    it("with actual input", function ()
      local input = util.lines_from_file("d07_input.txt")
      local dirs, _, _ = d07.fs_from_transcript(input)
      local sum = 0

      for _, dir in ipairs(dirs) do
        local dsz = dir[3]

        if dsz <= 100000 then
          sum = sum + dsz
        end
      end

      assert.is.equal(2104783, sum)
    end)
  end)
  describe("part b", function ()
    it("with actual input", function ()
      local input = util.lines_from_file("d07_input.txt")
      local dirs, _, _ = d07.fs_from_transcript(input)
      local del = nil

      local totalsz = dirs[1][3]
      local available = 70000000 - totalsz
      local required = 30000000 - available

      for _, dir in ipairs(dirs) do
        if dir[3] >= required then
          if not del or del[3] > dir[3] then
            del = dir
          end 
        end
      end

      assert.is.equal(5883165, del[3])
    end)
  end)
end)
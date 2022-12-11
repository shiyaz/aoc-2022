local util = require "util"
local d11 = require "d11"

describe("day 11", function ()
  describe("part a", function ()
    it("can read the input notes", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)
      assert.is.equal(4, #monkeys)
      assert.is.same({ { id = 1, init = 79, wl = 79 }, { id = 2, init = 98, wl = 98 }, }, monkeys[1].items)
      assert.is.same({ "old", "*", 19 }, monkeys[1].operation)
      assert.is.same({ "divisible", 23 }, monkeys[1].test)
      assert.is.same({ 3, 4, }, monkeys[1].throw_to)
      assert.is.same({ 3, 1, }, monkeys[2].throw_to)
      assert.is.same({ 2, 4, }, monkeys[3].throw_to)
      assert.is.same({ 1, 2, }, monkeys[4].throw_to)
    end)
    it("after one round", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)
      monkeys = d11.do_rounds(1, monkeys)
      assert.is.equal(4, #monkeys[1].items)
      assert.is.equal(6, #monkeys[2].items)
      assert.is.equal(2080, monkeys[2].items[1].wl)
      assert.is.equal(2, monkeys[1].i_ct)
      assert.is.equal(4, monkeys[2].i_ct)
      assert.is.equal(3, monkeys[3].i_ct)
      assert.is.equal(5, monkeys[4].i_ct)
    end)
    it("after twenty rounds", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(20, monkeys)

      assert.is.equal(5, #monkeys[1].items)
      assert.is.equal(10, monkeys[1].items[1].wl)
      assert.is.equal(5, #monkeys[2].items)
      assert.is.equal(245, monkeys[2].items[1].wl)

      assert.is.equal(101, monkeys[1].i_ct)
      assert.is.equal(95, monkeys[2].i_ct)
      assert.is.equal(7, monkeys[3].i_ct)
      assert.is.equal(105, monkeys[4].i_ct)

      table.sort(monkeys, function (a, b)
        return a.i_ct > b.i_ct 
      end)

      assert.is.equal(105, monkeys[1].i_ct)
      assert.is.equal(101, monkeys[2].i_ct)
    end)
    it("with actual input", function ()
      local notes = util.lines_from_file("d11_input.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(20, monkeys)

      table.sort(monkeys, function (a, b)
        return a.i_ct > b.i_ct 
      end)

      assert.is.equal(113220, monkeys[1].i_ct * monkeys[2].i_ct)
    end)
  end)
  describe("part b", function ()
    local manage_wl = function (wl)
      return wl % (23*19*13*17)
    end

    it("after one round", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)
      monkeys = d11.do_rounds(1, monkeys, manage_wl)
      assert.is.equal(2, monkeys[1].i_ct)
      assert.is.equal(4, monkeys[2].i_ct)
      assert.is.equal(3, monkeys[3].i_ct)
      assert.is.equal(6, monkeys[4].i_ct)
    end)
    it("after twenty rounds", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(20, monkeys, manage_wl)

      assert.is.equal(99, monkeys[1].i_ct)
      assert.is.equal(97, monkeys[2].i_ct)
      assert.is.equal(8, monkeys[3].i_ct)
      assert.is.equal(103, monkeys[4].i_ct)
    end)
    it("after one thousand rounds", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(1000, monkeys, manage_wl)

      assert.is.equal(5204, monkeys[1].i_ct)
      assert.is.equal(4792, monkeys[2].i_ct)
      assert.is.equal(199, monkeys[3].i_ct)
      assert.is.equal(5192, monkeys[4].i_ct)
    end)
    it("after ten thousand rounds", function ()
      local notes = util.lines_from_file("d11a_test.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(10000, monkeys, manage_wl)

      assert.is.equal(52166, monkeys[1].i_ct)
      assert.is.equal(47830, monkeys[2].i_ct)
      assert.is.equal(1938, monkeys[3].i_ct)
      assert.is.equal(52013, monkeys[4].i_ct)

      table.sort(monkeys, function (a, b)
        return a.i_ct > b.i_ct 
      end)

      assert.is.equal(2713310158, monkeys[1].i_ct * monkeys[2].i_ct)
    end)
    it("with actual input", function ()
      local manage_wl = function (wl)
        return wl % (5*2*19*7*17*13*3*11)
      end
  
      local notes = util.lines_from_file("d11_input.txt")
      local monkeys = d11.get_monkeys(notes)

      monkeys = d11.do_rounds(10000, monkeys, manage_wl)

      table.sort(monkeys, function (a, b)
        return a.i_ct > b.i_ct 
      end)

      assert.is.equal(30599555965, monkeys[1].i_ct*monkeys[2].i_ct)
    end)
  end)
end)

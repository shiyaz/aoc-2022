
local function get_monkeys(text)
  local monkeys = {}
  local all_items = {}

  for i = 1, #text, 7 do
    local monkey = { items = {}, }

    for i in text[i+1]:gmatch("%d+") do
      local next_id = #all_items + 1
      local item = { id = next_id, wl = tonumber(i), init = tonumber(i),  }
      table.insert(all_items, item)
      table.insert(monkey.items, item)
    end

    local operand1, operation, operand2 = text[i+2]:match("^.*=%s+(%-?%w+)%s+([%+%*%/%-])%s+(%-?%w+)$")

    monkey.operation = { tonumber(operand1) or operand1, operation, tonumber(operand2) or operand2 }

    local testop, testoperand = text[i+3]:match("^.*(divisible).*%s(%d+)$") 

    monkey.test = { testop, tonumber(testoperand) }

    local throw_to_if_true = text[i+4]:match("^.*%s(%d+)$")
    local throw_to_if_false = text[i+5]:match("^.*%s(%d+)$")

    monkey.throw_to = { 1+throw_to_if_true, 1+throw_to_if_false, }

    monkeys[#monkeys+1] = monkey
  end

  return monkeys, all_items
end

local function calculate_new_wl(wl, operation)
  local a, op, b = table.unpack(operation)

  a, b = (a == "old" and wl) or a, (b == "old" and wl) or b

  if (op == "*") then
    return a*b
  elseif (op == "+") then
    return a+b
  end
end

local function do_test(wl, test)
  return wl%test[2] == 0
end

local function manage_wl_default(wl)
  return wl//3
end

local function next_throw_to(monkey, manage_wl)
  local throw_to = monkey.throw_to[2]
  local item = monkey.items[1]

  manage_wl = manage_wl or manage_wl_default

  item.wl = calculate_new_wl(item.wl, monkey.operation)
  item.wl = manage_wl(item.wl)
  
  if do_test(item.wl, monkey.test) then
    throw_to = monkey.throw_to[1]
  end

  return throw_to
end

local function do_round(monkeys, manage_wl)
  for i, monkey in ipairs(monkeys) do
    while #monkey.items > 0 do
      monkey.i_ct = (monkey.i_ct or 0) + 1
      t = next_throw_to(monkey, manage_wl)
      local item = table.remove(monkey.items, 1)
      table.insert(monkeys[t].items, item)
    end 
  end

  return monkeys
end

local function do_rounds(n, monkeys, manage_wl)
  for r = 1, n do
    monkeys = do_round(monkeys, manage_wl)
  end
  return monkeys
end

return {
  get_monkeys = get_monkeys,
  do_rounds = do_rounds,
}

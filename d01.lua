inventory = {}

Elf = {}

function Elf:add_item (item)
  local items = inventory[self] or {}
  items[#items + 1] = item
  inventory[self] = items
end

function Elf:calories_carried ()
  local calories = 0
  local items = inventory[self]
  for _, item in ipairs(items) do
    calories = calories + tonumber(item)
  end
  return calories
end

function Elf:new (o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

local elves_from_item_list = function (items)
  local elf_list = { Elf:new() }

  for _, l in ipairs(items) do
    if l ~= "" then
      elf_list[#elf_list]:add_item(l)
    else
      elf_list[#elf_list + 1] = Elf:new()
    end
  end

  return elf_list
end

local elf_with_the_most = function (items)
  local elves = elves_from_item_list(items)
  local pick = nil

  for i, e in ipairs(elves) do
    if pick == nil then
      pick = elves[1]
    elseif pick:calories_carried() < e:calories_carried() then
      pick = e
    end
  end

  return pick
end

local three_elves_with_the_most = function (items)
  local elves = elves_from_item_list(items)

  table.sort(elves, function (e1, e2) 
    return e1:calories_carried() > e2:calories_carried()
  end)

  return { elves[1], elves[2], elves[3] }
end

return {
  elf_with_the_most = elf_with_the_most,
  three_elves_with_the_most = three_elves_with_the_most
}

inventory = {}

Elf = {}

function Elf:addItem (item)
  local items = inventory[self] or {}
  items[#items + 1] = item
  inventory[self] = items
end

function Elf:caloriesCarried ()
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

local elvesFromItemList = function (items)
  local elfList = { Elf:new() }

  for _, l in ipairs(items) do
    if l ~= "" then
      elfList[#elfList]:addItem(l)
    else
      elfList[#elfList + 1] = Elf:new()
    end
  end

  return elfList
end

local elfWithTheMost = function (items)
  local elves = elvesFromItemList(items)
  local pick = nil

  for i, e in ipairs(elves) do
    if pick == nil then
      pick = elves[1]
    elseif pick:caloriesCarried() < e:caloriesCarried() then
      pick = e
    end
  end

  return pick
end

local threeElvesWithTheMost = function (items)
  local elves = elvesFromItemList(items)

  table.sort(elves, function (e1, e2) 
    return e1:caloriesCarried() > e2:caloriesCarried()
  end)

  return { elves[1], elves[2], elves[3] }
end

return {
  elfWithTheMost = elfWithTheMost,
  threeElvesWithTheMost = threeElvesWithTheMost
}

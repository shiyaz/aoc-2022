local function get_priority(item)
  local c = string.byte(item)

  if c >= string.byte("a") and c <= string.byte("z") then
    return c - string.byte("a") + 1
  else
    return c - string.byte("A") + 27
  end 
end

local function find_shared_item(rucksack)
  local count = string.len(rucksack)
  local second_half = string.sub(rucksack, count/2+1, count)

  for i = 1, count/2 do
    local item = string.sub(rucksack, i, i)
    if string.find(second_half, item) then
      return item, get_priority(item)
    end
  end
end

local function find_shared_items(rucksacks)
  local items, sum_of_item_priorities = "", 0

  for _, rucksack in ipairs(rucksacks) do
    local item, priority = find_shared_item(rucksack)
    items = items..item
    sum_of_item_priorities = sum_of_item_priorities + priority
  end

  return items, sum_of_item_priorities
end

local function find_badges(rucksacks)
  local badges, sum_of_badge_priorities = "", 0

  for i = 1, #rucksacks, 3 do
    local r1, r2, r3 = rucksacks[i], rucksacks[i+1], rucksacks[i+2]

    for j = 1, string.len(r1) do
      local item = string.sub(r1, j, j)

      if string.find(r2, item) and string.find(r3, item) then
        badges = badges..item
        sum_of_badge_priorities = sum_of_badge_priorities + get_priority(item)
        break
      end
    end
  end

  return badges, sum_of_badge_priorities
end

return {
  find_shared_item = find_shared_item,
  find_shared_items = find_shared_items,
  find_badges = find_badges,
}
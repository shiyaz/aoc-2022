
local function split(str, sep)
  local p = str:find(sep)
  return str:sub(1, p-1), str:sub(p+1)
end

local function range(a)
  local l, u = split(a, "-")
  return { l_bound = tonumber(l), u_bound = tonumber(u) }
end

local function has_full_overlap(assignments)
  local a1, a2 = split(assignments, ",")
  local a1_s, a2_s = range(a1), range(a2)

  if (a1_s.l_bound >= a2_s.l_bound) and (a1_s.u_bound <= a2_s.u_bound) then
    return true 
  end

  if (a2_s.l_bound >= a1_s.l_bound) and (a2_s.u_bound <= a1_s.u_bound) then
    return true 
  end

  return false
end

local function has_overlap(assignments)
  local a1, a2 = split(assignments, ",")
  local a1_s, a2_s = range(a1), range(a2)

  local l, u = math.min(a1_s.l_bound, a2_s.l_bound), math.max(a1_s.u_bound, a2_s.u_bound)

  return u - l < a1_s.u_bound - a1_s.l_bound + a2_s.u_bound - a2_s.l_bound + 1
end


local function count_of_overlaps(list, full)
  local count = 0

  local check = has_overlap
  if full then check = has_full_overlap end

  for _, assignments in ipairs(list) do
    if check(assignments) then
      count = count + 1
    end
  end

  return count
end

return {
  has_overlap = has_overlap,
  has_full_overlap = has_full_overlap,
  count_of_overlaps = count_of_overlaps,
}

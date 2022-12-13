local function array_parser()
  local function parse_number(str, p)
    p = p or 1
    local c = str:sub(p, p)
    local n = ""
    repeat
      n = n..c
      p = p + 1
      c = str:sub(p, p)
    until not c:match("%d")
    return tonumber(n), p
  end
  
  local function skip(str, p)
    while str:sub(p, p) == "," do
      p = p + 1
    end
    return p
  end
  
  local function parse(str, p, res)
    p = p or 1
  
    while p < str:len() do
      local c, val = str:sub(p, p), nil
  
      if c == "[" then
        val, p = parse(str, p + 1, {})
        if res then
          res[#res+1] = val
        else
          res = val
        end
        p = skip(str, p)
      elseif c == "-" or c:match("%d") then
        val, p = parse_number(str, p)
        res[#res + 1] = val
        p = skip(str, p)
      elseif c == "]" then
        p = skip(str, p)
        return res, p + 1
      end
  
      p = skip(str, p)
    end
  
    return res, p
  end

  return parse
end

local function compare(a, b)
  local function compare_numbers(a, b)
    if a > b then
      return -1
    elseif a < b then
      return 1
    else
      return 0
    end
  end
  
  local ta, tb = type(a), type(b)

  if ta == "number" and tb == "number" then
    return compare_numbers(a, b)
  elseif ta == "number" then
    return compare({a}, b)
  elseif tb == "number" then
    return compare(a, {b})
  else
    local m = math.min(#a, #b)
    for i = 1, m do
      local res = compare(a[i], b[i]) 
      if (res ~= 0) then
        return res
      end
    end

    return compare_numbers(#a, #b)
  end
end

local function read_pkt_pairs(text)
  local parse, pkt_pairs = array_parser(), {}
  for i = 1, #text, 3 do
    pkt_pairs[#pkt_pairs+1] = { parse(text[i]), parse(text[i+1]), }
  end
  return pkt_pairs
end

local function sum_indices_in_order(pkt_pairs)
  local s = 0
  for i, p in ipairs(pkt_pairs) do
    if compare(p[1], p[2]) >= 0 then
      s = s + i
    end
  end
  return s
end

local function all_pkts(pkt_pairs)
  local function sort(pkts)
    table.sort(pkts, function (a, b) 
      return compare(a, b) == 1
    end)
  end
  
  local all = {{{2}}, {{6}}, }

  for _, pp in ipairs(pkt_pairs) do
    table.insert(all, pp[1])
    table.insert(all, pp[2])
  end

  sort(all)

  return all
end

local function find_dividers(pkts, p)
  local function array_to_string(a)
    if type(a) == "number" then
      return a
    else
      local s = "["
      for _, v in ipairs(a) do
        s = s .. array_to_string(v) .. ","
      end
      return s.."]"
    end
  end
  
  local d1i, d2i
  local d1s, d2s = array_to_string({{2}}), array_to_string({{6}})

  for i, ithp in ipairs(pkts) do
    if array_to_string(ithp) == d1s then
      d1i = i
    end
    if array_to_string(ithp) == d2s then
      d2i = i
    end
    if d1i and d2i then
      return d1i, d2i
    end
  end
end

return {
  read_pkt_pairs = read_pkt_pairs,
  all_pkts = all_pkts,
  sum_indices_in_order = sum_indices_in_order,
  find_dividers = find_dividers,
}

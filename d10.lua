local function addx (m, a)
  m.cycle = m.cycle + 1
  coroutine.yield(m.cycle, m.X)
  m.cycle = m.cycle + 1
  coroutine.yield(m.cycle, m.X)
  m.X = m.X + a
end

local function noop (m)
  m.cycle = m.cycle + 1
  coroutine.yield(m.cycle, m.X)
end

local function execute (m)
  while m.pc <= #m do
    local op = m[m.pc]

    if op[1] == "addx" then
      addx(m, op[2])
    elseif op[1] == "noop" then
      noop(m)
    end

    m.pc = m.pc + 1
  end
end

local function run (m)
  return coroutine.wrap(function () execute(m) end)
end

local function load (text)
  local m = { X = 1, pc = 1, cycle = 0 }

  for _, line in ipairs(text) do
    local instr, param = string.match(line, "^(%a+)%s?(.*)$")
    param = param and tonumber(param)
    table.insert(m, { instr, param })
  end
  return m
end

return {
  load = load,
  run = run,
}
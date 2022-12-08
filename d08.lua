local function tree_height (grid, tx, ty)
  return grid.hs[grid.width*(ty - 1) + tx]
end

local function left_blocker (grid, tx, ty)
  if tx == 1 then
    return
  end

  local th = grid:tree_height(tx, ty)

  for x = tx - 1, 1, -1 do
    local h = grid:tree_height(x, ty)
    if h >= th then
      return {x, ty}
    end
  end
end

local function right_blocker (grid, tx, ty)
  if tx == grid.width then
    return
  end

  local th = grid:tree_height(tx, ty)

  for x = tx + 1, grid.width do
    local h = grid:tree_height(x, ty)
    if h >= th then
      return {x, ty}
    end
  end
end

local function top_blocker (grid, tx, ty)
  if ty == 1 then
    return
  end

  local th = grid:tree_height(tx, ty)

  for y = ty - 1, 1, -1 do
    local h = grid:tree_height(tx, y)
    if h >= th then
      return {tx, y}
    end
  end
end

local function bottom_blocker (grid, tx, ty)
  if ty == grid.height then
    return
  end

  local th = grid:tree_height(tx, ty)

  for y = ty + 1, grid.height do
    local h = grid:tree_height(tx, y)
    if h >= th then
      return {tx, y}
    end
  end
end

local function blocking_trees (grid, x, y)
  return { 
    left = left_blocker(grid, x, y) or false, 
    right = right_blocker(grid, x, y) or false, 
    top = top_blocker(grid, x, y) or false, 
    bottom = bottom_blocker(grid, x, y) or false, 
  }
end

local function is_blocked (grid, x, y)
  local blockers = grid:blocking_trees(x, y)
  for _, b in pairs(blockers) do
  end
  return blockers.left and blockers.right and blockers.top and blockers.bottom
end

local function scenic_score (grid, x, y)
  local score = 1
  local blockers = grid:blocking_trees(x, y)
  for dir, b in pairs(blockers) do
    if dir == "left" then
      b = b or { 1, y }
      score = score * (x - b[1])
    elseif dir == "right" then
      b = b or { grid.width, y }
      score = score * (b[1] - x)
    elseif dir == "top" then
      b = b or { x, 1 }
      score = score * (y - b[2])
    elseif dir == "bottom" then
      b = b or { x, grid.height }
      score = score * (b[2] - y)
    end 
  end
  return score, table.concat(blockers.left or {}, ",").."-"..table.concat(blockers.right or {}, ",").."-"..table.concat(blockers.top or {}, ",").."-"..table.concat(blockers.bottom or {}, ",")
end

local function visible_tree_count (grid)
  local visible_count = 0
  for x = 1, grid.width do
    for y = 1, grid.height do
      if not is_blocked(grid, x, y) then
        visible_count = visible_count + 1
      end
    end
  end
  return visible_count
end

local function max_tree_scenic_score (grid)
  local max_score = 0
  local a = ""
  for x = 1, grid.width do
    for y = 1, grid.height do
      local score, b = scenic_score(grid, x, y)
      if score > max_score then
        max_score = score
        a = b
      end
    end
  end
  return max_score, a
end

local function create_tree_grid (input)
  local xs, ys, hs = {}, {}, {}
  local w, h = false, #input

  for y, line in ipairs(input) do
    local x = 1
    w = w or line:len()
    for h in line:gmatch"%d" do
      ys[#ys+1], xs[#xs+1], hs[#hs+1], x = y, x, tonumber(h), x + 1
    end 
  end

  local grid = { width = w, height = h, xs = xs, ys = ys, hs = hs, }

  grid.tree_height = tree_height
  grid.blocking_trees = blocking_trees
  grid.visible_tree_count = visible_tree_count
  grid.max_tree_scenic_score = max_tree_scenic_score

  return grid
end

return {
  create_tree_grid = create_tree_grid,
}
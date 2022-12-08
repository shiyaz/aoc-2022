local function tree_height (grid, tx, ty)
  return grid.hs[grid.width*(ty - 1) + tx]
end

local function visible_from_left_edge (grid, tx, ty)
  if tx == 1 then -- left edge
    return 1 + 32
  end

  local th = grid:tree_height(tx, ty)

  for x = 1, tx - 1 do
    local h = grid:tree_height(x, ty)
    if h >= th then
      return 0
    end
  end

  return 1
end

local function visible_from_right_edge (grid, tx, ty)
  if tx == grid.width then -- right edge
    return 2 + 32
  end

  local th = grid:tree_height(tx, ty)

  for x = tx + 1, grid.width do
    local h = grid:tree_height(x, ty)
    if h >= th then
      return 0
    end
  end

  return 2
end

local function visible_from_top_edge (grid, tx, ty)
  if ty == 1 then -- top edge
    return 4 + 32
  end

  local th = grid:tree_height(tx, ty)

  for y = 1, ty - 1 do
    local h = grid:tree_height(tx, y)
    if h >= th then
      return 0
    end
  end

  return 4
end

local function visible_from_bottom_edge (grid, tx, ty)
  if ty == grid.height then -- bottom edge
    return 8 + 32
  end

  local th = grid:tree_height(tx, ty)

  for y = ty + 1, grid.height do
    local h = grid:tree_height(tx, y)
    if h >= th then
      return 0
    end
  end

  return 8
end

local function visibility (grid, x, y)
  return grid:visible_from_left_edge(x, y) + grid:visible_from_right_edge(x, y) + grid:visible_from_top_edge(x, y) + grid:visible_from_bottom_edge(x, y)
end

local function find_visible_trees (grid)
  local visible, visible_count = {}, 0
  for x = 1, grid.width do
    for y = 1, grid.height do
      local visibility = grid:visibility(x, y)
      if visibility > 0 then
        visible_count = visible_count + 1
        visible[{x, y}] = visibility
      end
    end
  end
  return visible, visible_count
end

local function create_tree_grid (input)
  local xs, ys, hs = {}, {}, {}
  local w, h = false, #input

  for y, line in ipairs(input) do
    local x = 1
    w = w or line:len()
    for h in line:gmatch"%d" do
      ys[#ys+1] = y
      xs[#xs+1] = x
      hs[#hs+1] = tonumber(h)
      x = x + 1
    end 
  end

  local grid = { width = w, height = h, xs = xs, ys = ys, hs = hs, }
  grid.find_visible_trees = find_visible_trees
  grid.visibility = visibility
  grid.tree_height = tree_height
  grid.visible_from_left_edge = visible_from_left_edge
  grid.visible_from_right_edge = visible_from_right_edge
  grid.visible_from_top_edge = visible_from_top_edge
  grid.visible_from_bottom_edge = visible_from_bottom_edge

  return grid
end

return {
  create_tree_grid = create_tree_grid,
}
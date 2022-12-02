local score_guide = {
  ["R R"] = { 4, 4 },
  ["R P"] = { 1, 8 },
  ["R S"] = { 7, 3 },
  ["P R"] = { 8, 1 },
  ["P P"] = { 5, 5 },
  ["P S"] = { 2, 9 },
  ["S R"] = { 3, 7 },
  ["S P"] = { 9, 2 },
  ["S S"] = { 6, 6 },
}

local move_guide = {
  R = { "S", "R", "P"},
  P = { "R", "P", "S"},
  S = { "P", "S", "R"},
}

local function first_strategy (game)
  aliases = {A = "R", B = "P", C = "S", X = "R", Y = "P", Z = "S"}
  for alias, play in pairs(aliases) do
    game = string.gsub(game, alias, play)
  end
  return game
end

local function second_strategy (game)
  aliases = {A = "R", B = "P", C = "S"}

  for alias, play in pairs(aliases) do
    game = string.gsub(game, alias, play)
  end

  player1_move = string.sub(game, 1, 1)
  player2_move = string.sub(game, 3, 3)

  local option = 0

  if player2_move == "X" then
    option = 1
  elseif player2_move == "Y" then
    option = 2
  elseif player2_move == "Z" then
    option = 3
  end

  local move = move_guide[player1_move][option]

  game = string.gsub(game, player2_move, move)

  return game
end


local function score_game (game, strategy_to_apply)
  strategy_to_apply = strategy_to_apply or first_strategy

  game = strategy_to_apply(game)

  local result = score_guide[game] or { 0, 0 }

  return table.unpack(result)
end

local function score_games (games, strategy)
  local player1_final_score, player2_final_score = 0, 0
  local strategy_to_apply = strategy_to_apply or first_strategy

  for _, game in ipairs(games) do
    local player1_score, player2_score = score_game(game, strategy)
    player1_final_score = player1_final_score + player1_score
    player2_final_score = player2_final_score + player2_score
  end

  return player1_final_score, player2_final_score
end

return {
  score_game = score_game,
  second_strategy = second_strategy,
  score_games = score_games
}

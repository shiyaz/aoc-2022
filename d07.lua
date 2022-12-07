local function parse_cmd (input)
  local result = table.pack(input:match("^%$ (%a+)%s*(.*)$"))

  if (result[1]) then
    return result
  end
end

local function parse_dir (input)
  local result = table.pack(input:match("^(dir) (%a+)$"))

  if (result[1]) then
    return result
  end
end

local function parse_file (input)
  local result = table.pack(("file "..input):match("^(file) (%d+) (.+)$"))

  if (result[1]) then
    result[2] = tonumber(result[2])
    return result
  end
end

local function parse (input)
  return parse_cmd(input) or parse_dir(input) or parse_file(input)
end

local function fs_from_transcript (transcript)
  local root = { "/", nil, 0 }
  local file_table = { [root] = {} }
  local dir_table = { [root] = {} }
  local dirs = { root }
  local cwd = root

  local function aux_ls (parsed)
  end

  local function aux_cd (parsed)
    local d = parsed[2]

    if d == "/" then
      cwd = root
    elseif d == ".." then
      cwd = cwd[2]
    else
      for _, my_dir in ipairs(dir_table[cwd]) do
        if d == my_dir[1] then
          cwd = my_dir
          break
        end
      end
    end
  end

  local function aux_file (parsed)
    local fn, fsz = parsed[3], parsed[2]
    local f = { fn, fsz, cwd, }
    file_table[cwd][#file_table[cwd]+1] = f
    local d = cwd
    while d do
      d[3] = d[3] + fsz
      d = d[2]
    end
  end

  local function aux_dir (parsed)
    local d = { parsed[2], cwd, 0 }
    dirs[#dirs+1] = d
    dir_table[cwd] = dir_table[cwd] or {}
    dir_table[cwd][#dir_table[cwd] + 1] = d
    file_table[d] = file_table[d] or {}
  end

  local function aux (parsed)
    if parsed[1] == "ls" then
      aux_ls(parsed)
    end

    if parsed[1] == "cd" then
      aux_cd(parsed)
    end

    if parsed[1] == "dir" then
      aux_dir(parsed)
    end

    if parsed[1] == "file" then
      aux_file(parsed)
    end
  end

  for _, line in ipairs(transcript) do
    local parsed = parse(line)
    if parsed then
      aux(parsed)
    end
  end
  
  return dirs, file_table, dir_table
end


return {
  fs_from_transcript = fs_from_transcript,
}

return {
  linesFromFile = function(filename)
    local f = io.open(filename, "r")
    local lines = {}
    for line in f:lines() do
      lines[#lines + 1] = line
    end
    return lines
  end
}

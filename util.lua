return {
  lines_from_file = function(filename)
    local lines = {}
    for line in io.lines(filename) do
      lines[#lines + 1] = line
    end
    return lines
  end
}

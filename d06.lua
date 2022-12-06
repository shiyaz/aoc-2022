local function start_of_marker(datastream, marker_len)
  local marker = ""
  
  for i = 1, string.len(datastream) do
    local c = string.sub(datastream, i, i)

    marker = string.sub(marker, (string.find(marker, c) or 0) + 1)..c

    if string.len(marker) == marker_len then
      return marker, i
    end
  end
end

local function start_of_packet_marker(datastream)
  return start_of_marker(datastream, 4)
end

local function start_of_message_marker(datastream)
  return start_of_marker(datastream, 14)
end

return {
  start_of_packet_marker = start_of_packet_marker,
  start_of_message_marker = start_of_message_marker,
}
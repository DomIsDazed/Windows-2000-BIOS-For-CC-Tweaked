term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)

local sides = {"left","right","top","bottom","front","back"}

local function findBootDisk()
  for _,side in ipairs(sides) do
    if disk.isPresent(side) then
      local bootFile = disk.getMountPath(side).."/startup"
      if fs.exists(bootFile) then
        return bootFile
      end
    end
  end
  return nil
end

local function drawScreen(showCursor)
  term.clear()
  term.setCursorPos(1,1)
  print("No bootable medium found!")
  print("Please insert a bootable medium and reboot.")
  term.setCursorPos(1,3)
  if showCursor then
    io.write("_")
  end
end

local cursorVisible = true
local blinkTimer = os.startTimer(0.5)

while true do
  local bootFile = findBootDisk()
  if bootFile then
    term.clear()
    term.setCursorPos(1,1)
    print("Bootable medium found. Booting...")
    sleep(1)
    shell.run(bootFile)
    break
  end
  drawScreen(cursorVisible)
  local event,id = os.pullEvent()
  if event == "timer" and id == blinkTimer then
    cursorVisible = not cursorVisible
    blinkTimer = os.startTimer(0.5)
  end
end

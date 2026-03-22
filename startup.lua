term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
term.clear()

local w, h = term.getSize()

local function writeBottom(text, bgCol, textCol)
  term.setBackgroundColor(bgCol or colors.gray)
  term.setTextColor(textCol or colors.white)
  term.setCursorPos(1, h)
  local padded = " " .. text .. string.rep(" ", w - #text - 1)
  io.write(padded)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
end

local function showQuitDialog()
  local w, h = term.getSize()
  local w0, h0 = math.min(50, w - 1), 10
  local x0 = math.floor((w - w0) / 2) + 1
  local y0 = math.max(6, math.floor((h - h0) / 2))   -- start below the title region

  -- Outer red border (on top of blue screen background)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.red)
  term.setCursorPos(x0, y0)
  io.write("+" .. string.rep("-", w0 - 2) .. "+")
  term.setCursorPos(x0, y0 + h0 - 1)
  io.write("+" .. string.rep("-", w0 - 2) .. "+")

  for y = y0 + 1, y0 + h0 - 2 do
    term.setCursorPos(x0, y)
    io.write("|")
    term.setCursorPos(x0 + w0 - 1, y)
    io.write("|")
  end

  -- Fill interior in gray
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  for y = y0 + 1, y0 + h0 - 2 do
    term.setCursorPos(x0 + 1, y)
    io.write(string.rep(" ", w0 - 2))
  end

  -- Text inside prompt
  term.setTextColor(colors.red)
  term.setCursorPos(x0 + 2, y0 + 1)
  io.write("Windows 2000 is not completely set up on your")
  term.setCursorPos(x0 + 2, y0 + 2)
  io.write("computer.  If you quit Setup now, you will need")
  term.setCursorPos(x0 + 2, y0 + 3)
  io.write("to run Setup again to set up Windows 2000.")

  term.setTextColor(colors.red)
  term.setCursorPos(x0 + 2, y0 + 5)
  io.write("  * To continue Setup, press ENTER.")
  term.setCursorPos(x0 + 2, y0 + 6)
  io.write("  * To quit Setup, press F3.")

  term.setTextColor(colors.red)
  term.setCursorPos(x0 + 2, y0 + 8)
  io.write(" F3=Quit    ENTER=Continue")

  while true do
    local event, key = os.pullEvent("key")
    if key == keys.enter then
      return false
    elseif key == keys.f3 then
      return true
    end
  end
end

local function drawHeader(title)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  print(" " .. title)
  print(" " .. string.rep("-", #title))
end
local function showScreen3()
  term.setBackgroundColor(colors.blue)
  term.clear()
  term.setBackgroundColor(colors.blue)
  drawHeader("Windows 2000 Professional Setup")
  term.setCursorPos(3, 4)
  io.write("Welcome to Setup.")
  term.setCursorPos(3, 6)
  io.write("This portion of the Setup program prepares")
  term.setCursorPos(3, 7)
  io.write("Microsoft(R) Windows 2000(TM) to run on your")
  term.setCursorPos(3, 8)
  io.write("computer.")
  term.setCursorPos(3, 10)
  io.write("  * To set up Windows 2000 now, press ENTER.")
  term.setCursorPos(3, 12)
  io.write("  * To repair a Windows 2000 installation,")
  term.setCursorPos(3, 13)
  io.write("    press R.")
  term.setCursorPos(3, 15)
  io.write("  * To quit Setup without installing Windows")
  term.setCursorPos(3, 16)
  io.write("    2000, press F3.")
  writeBottom("ENTER=Continue   R=Repair   F3=Quit")
end
-- SCREEN 1: Press F6
term.clear()
term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
term.setCursorPos(1, 2)
print(" Windows 2000 Setup")
print(" " .. string.rep("-", #"Windows 2000 Setup"))
writeBottom("Press F6 if you need to install a third party SCSI or RAID driver...")
sleep(3)

-- SCREEN 2: Setup is starting
term.clear()
drawHeader("Windows 2000 Setup")
writeBottom("Setup is starting Windows 2000")
sleep(3)

-- SCREEN 3: Welcome to Setup
showScreen3()

-- Wait for keypress
while true do
  local event, key = os.pullEvent("key")
  if key == keys.enter then
    -- continue to next screen (add more here later)
    break
  elseif key == keys.f3 then
    if showQuitDialog() then
      os.reboot()
    else
      showScreen3() -- redraw screen 3 after canceling F3 prompt
    end
  end
end

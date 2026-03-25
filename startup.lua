-- Windows 2000 Setup for CC: Tweaked from the original by @SvenDowideit
local w, h = term.getSize()

-- HELPER: write text at the bottom of the screen with gray background
local function writeBottom(text1, text2)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  if text2 then
    term.setCursorPos(1, h - 1)
    local padded1 = " " .. text1 .. string.rep(" ", w - #text1 - 1)
    io.write(padded1)
    term.setCursorPos(1, h)
    local padded2 = " " .. text2 .. string.rep(" ", w - #text2 - 1)
    io.write(padded2)
  else
    term.setCursorPos(1, h)
    local padded = " " .. text1 .. string.rep(" ", w - #text1 - 1)
    io.write(padded)
  end
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
end

-- HELPER: header with title and underline
local function drawHeader(title)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  print(" " .. title)
  print(string.rep("-", #title + 2))
end

-- SCREEN: F6 driver screen (only used from screen 1)
local function drawDriverScreen()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  while true do
    os.pullEvent()
  end
end

-- SCREEN 1
local function drawScreen1()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  writeBottom("Press F6 if you need to install a third party SCSI", "or RAID driver...")
  local timer = os.startTimer(3)
while true do
  local event, p1 = os.pullEvent()
    if event == "timer" and p1 == timer then
      break
    elseif event == "key" and p1 == keys.f6 then
    drawDriverScreen()
    end
  end
end

-- SCREEN 2
local function drawScreen2()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  writeBottom("Setup is starting Windows 2000")
  sleep(3)
end

-- SCREEN 3
local function drawScreen3()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Professional Setup")
  term.setCursorPos(3, 4)
  io.write("Welcome to Setup.")
  term.setCursorPos(3, 6)
  io.write("This portion of the Setup program prepares")
  term.setCursorPos(3, 7)
  io.write("Microsoft<R> Windows 2000<TM> to run on your")
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

-- DIALOG: Quit confirmation dialog (only used from screen 3)
local function showQuitDialog()
  local w0, h0 = math.min(50, w - 1), 10
  local x0 = math.floor((w - w0) / 2) + 1
  local y0 = math.max(6, math.floor((h - h0) / 2))
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
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  for y = y0 + 1, y0 + h0 - 2 do
    term.setCursorPos(x0 + 1, y)
    io.write(string.rep(" ", w0 - 2))
  end
  term.setTextColor(colors.red)
  term.setCursorPos(x0 + 2, y0 + 1)
  io.write("Windows 2000 is not completely set up on your")
  term.setCursorPos(x0 + 2, y0 + 2)
  io.write("computer. If you quit Setup now, you will need")
  term.setCursorPos(x0 + 2, y0 + 3)
  io.write("to run Setup again to set up Windows 2000.")
  term.setCursorPos(x0 + 2, y0 + 5)
  io.write("  * To continue Setup, press ENTER.")
  term.setCursorPos(x0 + 2, y0 + 6)
  io.write("  * To quit Setup, press F3.")
  term.setCursorPos(x0 + 2, y0 + 8)
  io.write(" F3=Quit    ENTER=Continue")
  while true do
    local event, key = os.pullEvent("key")
    if key == keys.enter then return false
    elseif key == keys.f3 then return true
    end
  end
end

-- MAIN (run)

drawScreen1()
drawScreen2()
drawScreen3()

while true do
  local event, key = os.pullEvent("key")
  if key == keys.enter then
    break
  elseif key == keys.f3 then
    if showQuitDialog() then
      os.reboot()
    else
      drawScreen3()
    end
  end
end

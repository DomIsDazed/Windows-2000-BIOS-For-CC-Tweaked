-- Windows 2000 Setup Simulator for CC: Tweaked by @Searge
-- forward declerations
local w, h = term.getSize()
local drawDriverScreen

-- ==============================
-- HELPERS
-- ==============================

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

local function drawHeader(title)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  print(" " .. title)
  print(string.rep("-", #title + 2))
end

local function showQuitDialog(keepContent)
  term.setBackgroundColor(colors.gray)
  if keepContent then
    term.setCursorPos(1, h)
    term.write(string.rep(" ", w))
  else
    term.setCursorPos(1, h - 1)
    term.write(string.rep(" ", w))
    term.setCursorPos(1, h)
    term.write(string.rep(" ", w))
    term.setBackgroundColor(colors.blue)
    for y = 3, h - 2 do
      term.setCursorPos(1, y)
      term.write(string.rep(" ", w))
    end
  end
  local w0, h0 = 44, 10
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
  io.write("Windows 2000 is not completely set up")
  term.setCursorPos(x0 + 2, y0 + 2)
  io.write("If you quit Setup, you will need to run")
  term.setCursorPos(x0 + 2, y0 + 3)
  io.write("Setup again to set up Windows 2000.")
  term.setCursorPos(x0 + 2, y0 + 5)
  io.write("  * To continue Setup, press ENTER.")
  term.setCursorPos(x0 + 2, y0 + 6)
  io.write("  * To quit Setup, press F3.")
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

local function drawRebootScreen(showCountdown)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  term.setCursorPos(3, 4)
  io.write("Windows 2000 has not been installed on this")
  term.setCursorPos(3, 6)
  io.write("computer. If there is a floppy disk in drive A:")
  term.setCursorPos(3, 8)
  io.write("remove it. Press ENTER to restart your computer.")
  writeBottom("ENTER=Restart Computer")

  if showCountdown then
    local bw = 46
    local bx = math.floor((w - bw) / 2) + 1
    local by = 11
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(bx, by)
    io.write("+" .. string.rep("-", bw - 2) .. "+")
    term.setCursorPos(bx, by + 4)
    io.write("+" .. string.rep("-", bw - 2) .. "+")
    for y = by + 1, by + 3 do
      term.setCursorPos(bx, y)
      io.write("|")
      term.setCursorPos(bx + bw - 1, y)
      io.write("|")
    end
    for y = by + 1, by + 3 do
      term.setCursorPos(bx + 1, y)
      term.write(string.rep(" ", bw - 2))
    end
    local barX = bx + 2
    local barW = bw - 4
    local barY = by + 3
    local countdown = 15
    local timer = os.startTimer(1)
    while countdown >= 0 do
      term.setCursorPos(bx + 1, by + 1)
      local msg = "Your computer will reboot in " .. countdown .. " seconds...."
      local pad = math.floor((bw - 2 - #msg) / 2)
      term.write(string.rep(" ", pad) .. msg .. string.rep(" ", bw - 2 - #msg - pad))
      local filled = math.floor((15 - countdown) / 15 * barW)
      paintutils.drawFilledBox(barX, barY, barX + filled, barY, colors.red)
      if filled < barW then
        paintutils.drawFilledBox(barX + filled + 1, barY, barX + barW - 1, barY, colors.blue)
      end
      local event, p1 = os.pullEvent()
      if event == "key" and p1 == keys.enter then
        os.reboot()
      elseif event == "timer" and p1 == timer then
        countdown = countdown - 1
        timer = os.startTimer(1)
      end
    end
  else
    -- simple version, just wait for enter
    while true do
      local event, p1 = os.pullEvent()
      if event == "key" and p1 == keys.enter then
        break
      end
    end
  end

  os.reboot()
end

-- ==============================
-- SCREENS
-- ==============================

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

local function drawScreen2()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  writeBottom("Setup is starting Windows 2000")
  sleep(3)
end

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
  while true do
    local event, key = os.pullEvent("key")
    if key == keys.enter then
      break
    elseif key == keys.f3 then
      if showQuitDialog(true) then
        drawRebootScreen(true)  -- countdown version
      else
        drawScreen3()
      end
    end
  end
end

-- ==============================
-- SUB-SCREENS
-- ==============================

drawDriverScreen = function()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
  drawHeader("Windows 2000 Setup")
  term.setCursorPos(2, 4)
  io.write("Setup could not determine the type of one or more")
  term.setCursorPos(2, 5)
  io.write("mass storage devices installed on your system.")
  term.setCursorPos(2, 6)
  io.write("Currently, Setup will load support for the")
  term.setCursorPos(2, 7)
  io.write("following mass storage devices(s):")
  writeBottom("S=Specify Additional Device   ENTER=Continue", "F3=Exit")
  while true do
    local event, p1 = os.pullEvent()
    if event == "key" and p1 == keys.enter then
      drawScreen2()
      drawScreen3()
      break
    elseif event == "key" and p1 == keys.s then
      -- specify device (add later)
    elseif event == "key" and p1 == keys.f3 then
      if showQuitDialog(false) then
        drawRebootScreen(false)  -- simple version
      else
        drawDriverScreen()
        break
      end
    end
  end
end

-- ==============================
-- MAIN
-- ==============================

drawScreen1()
drawScreen2()
drawScreen3()

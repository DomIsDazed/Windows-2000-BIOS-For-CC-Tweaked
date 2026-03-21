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
  -- Draw the dialog box background and border
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  
  -- Draw border and fill background
  for y = 5, 15 do
    term.setCursorPos(8, y)
    io.write(string.rep(" ", 65))
  end
  
  -- Draw box border
  term.setCursorPos(8, 5)
  io.write("\219" .. string.rep("\196", 63) .. "\219")
  term.setCursorPos(8, 15)
  io.write("\219" .. string.rep("\196", 63) .. "\219")
  
  for y = 6, 14 do
    term.setCursorPos(8, y)
    io.write("\179")
    term.setCursorPos(72, y)
    io.write("\179")
  end
  
  -- Draw text
  term.setTextColor(colors.red)
  term.setCursorPos(10, 6)
  io.write("Windows 2000 is not completely set up on your")
  term.setCursorPos(10, 7)
  io.write("computer.  If you quit Setup now, you will need")
  term.setCursorPos(10, 8)
  io.write("to run Setup again to set up Windows 2000.")
  
  term.setCursorPos(10, 10)
  io.write("  * To continue Setup, press ENTER.")
  term.setCursorPos(10, 11)
  io.write("  * To quit Setup, press F3.")
  
  term.setTextColor(colors.white)
  term.setCursorPos(10, 13)
  io.write("F3=Quit    ENTER=Continue")
  
  while true do
    local event, key = os.pullEvent("key")
    if key == keys.enter then
      return false  -- go back to setup
    elseif key == keys.f3 then
      return true   -- quit setup
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

-- Wait for keypress
while true do
  local event, key = os.pullEvent("key")
  if key == keys.enter then
    -- continue to next screen (add more here later)
    break
  elseif key == keys.f3 then
    if showQuitDialog() then
      os.reboot()
    end
  end
end

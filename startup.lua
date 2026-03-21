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

local function drawHeader(title)
  term.setBackgroundColor(colors.blue)
  term.setCursorPos(1, 1)
  term.setTextColor(colors.white)
  print(" " .. title)
  print(" " .. string.rep("-", #title))
end

-- SCREEN 1: Press F6
term.clear()
drawHeader("Windows 2000 Setup")
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
print("Welcome to Setup.")
term.setCursorPos(3, 6)
print("This portion of the Setup program prepares Microsoft(R)")
term.setCursorPos(3, 7)
print("Windows 2000(TM) to run on your computer.")
term.setCursorPos(3, 9)
print("  * To set up Windows 2000 now, press ENTER.")
term.setCursorPos(3, 11)
print("  * To repair a Windows 2000 installation, press R.")
term.setCursorPos(3, 13)
print("  * To quit Setup without installing Windows 2000, press F3.")
writeBottom("ENTER=Continue   R=Repair   F3=Quit")

-- Wait for keypress
while true do
  local event, key = os.pullEvent("key")
  if key == keys.enter then
    -- continue to next screen (add more here later)
    break
  elseif key == keys.f3 then
    term.clear()
    term.setCursorPos(1,1)
    print("Setup aborted.")
    sleep(2)
    os.reboot()
  end
end

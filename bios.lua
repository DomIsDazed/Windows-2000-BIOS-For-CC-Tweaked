-- startup.lua
-- A faithful BIOS-style bootloader. Blinks a cursor, locks the
-- keyboard, and boots from a disk the moment one is inserted.

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)

local sides = {"left", "right", "top", "bottom", "front", "back"}

local function findBootDisk()
  for _, side in ipairs(sides) do
    if disk.isPresent(side) then
      local bootFile = disk.getMountPath(side) .. "/startup"
      if fs.exists(bootFile) then
        return bootFile
      end
    end
  end
  return nil
end

-- This draws the error message and places the blinking cursor
-- on the line below, just like in your screenshot.
local function drawScreen(showCursor)
  term.clear()
  term.setCursorPos(1, 1)
  print("No bootable medium found!")
  print("Please insert a bootable medium and reboot.")
  -- Move to the next line and draw the underscore if it's
  -- the "on" phase of the blink cycle.
  term.setCursorPos(1, 3)
  if showCursor then
    io.write("_")  -- io.write won't add a newline, keeping it in place
  end
end

-- We use os.startTimer to drive the blinking, and os.pullEvent
-- to wait for events. Crucially, we ONLY act on "timer" and "disk"
-- events -- all keypresses and other events are silently swallowed,
-- which is what locks the keyboard completely.
local cursorVisible = true
local blinkTimer = os.startTimer(0.5)  -- blink every half second

while true do
  local bootFile = findBootDisk()

  if bootFile then
    term.clear()
    term.setCursorPos(1, 1)
    print("Bootable medium found. Booting...")
    sleep(1)
    shell.run(bootFile)
    break
  end

  -- Draw the screen with the current cursor state
  drawScreen(cursorVisible)

  -- Wait for the next event, but ONLY respond to timer and disk events.
  -- Any keypress events are pulled and thrown away -- the user is locked out.
  local event, id = os.pullEvent()

  if event == "timer" and id == blinkTimer then
    -- Flip the cursor visibility and restart the timer
    cursorVisible = not cursorVisible
    blinkTimer = os.startTimer(0.5)
  end
  -- "disk" events don't need handling here -- the loop restarts
  -- and findBootDisk() will catch the newly inserted disk naturally.
end

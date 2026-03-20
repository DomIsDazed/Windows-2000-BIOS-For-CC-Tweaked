term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

local function noBootScreen()
  term.setCursorPos(1,1)
  term.clear()
  print("No bootable medium found!")
  print("Please insert a bootable medium and reboot.")
end

local function findFloppy()
  for _, side in ipairs({"left","right","top","bottom","front","back"}) do
    if disk.isPresent(side) and disk.hasData(side) then
      local path = disk.getMountPath(side)
      if fs.exists(path.."/startup.lua") or fs.exists(path.."/startup") then
        return side, path
      end
    end
  end
  return nil
end

while true do
  local side, path = findFloppy()
  if side then
    local bootFile = fs.exists(path.."/startup.lua") and path.."/startup.lua" or path.."/startup"
    term.clear()
    term.setCursorPos(1,1)
    print("Booting from floppy...")
    sleep(0.5)
    dofile(bootFile)
    break
  else
    noBootScreen()
    sleep(0.5)
  end
end
```

---

## Then on any CC computer just run:
```
wget run https://raw.githubusercontent.com/DomIsDazed/Windows-2000-BIOS-For-CC-Tweaked/main/install.lua

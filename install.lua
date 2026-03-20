local baseUrl = "https://raw.githubusercontent.com/DomIsDazed/Windows-2000-BIOS-For-CC-Tweaked/main/"

print("Installing Windows 2000 BIOS...")

local req = http.get(baseUrl .. "bios.lua")
if req then
  local f = fs.open("startup.lua", "w")
  f.write(req.readAll())
  f.close()
  req.close()
  print("Done! Rebooting...")
  sleep(1)
  os.reboot()
else
  print("Failed to download. Check your internet/HTTP settings.")
end

pcall(require, "hs.ipc")

local hotkeyMods = { "ctrl", "alt", "cmd" }
local hotkeyKey = "S"
local captureMods = { "ctrl", "alt", "cmd", "shift" }

-- Fallback click target relative to the top-left of Chrome's focused window.
-- Adjust if Chrome's native vertical-tabs button is in a different spot.
local fallbackOffset = { x = 34, y = 140 }
local templatePath = hs.configdir .. "/assets/chrome-vertical-tabs-template.png"
local templateCaptureSize = { w = 44, h = 44 }
local matchThreshold = 0.78
local searchRegion = { x = 0, y = 92, w = 96, h = 170 }

local candidateNeedles = {
  "vertical tab",
  "sidebar",
  "collapse",
  "expand",
  "side panel",
}

local cachedMask = nil

local function normalize(value)
  if type(value) ~= "string" then
    return ""
  end

  return string.lower(value)
end

local function brightness(color)
  if type(color) ~= "table" then
    return 0
  end

  local red = color.red or 0
  local green = color.green or 0
  local blue = color.blue or 0
  return (red * 0.299) + (green * 0.587) + (blue * 0.114)
end

local function fileExists(path)
  local attributes = hs.fs.attributes(path)
  return attributes and attributes.mode == "file"
end

local function ensureAssetDir()
  hs.fs.mkdir(hs.configdir .. "/assets")
end

local function elementText(element)
  local attributes = {
    "AXDescription",
    "AXTitle",
    "AXHelp",
    "AXIdentifier",
    "AXRoleDescription",
    "AXValue",
  }

  local parts = {}
  for _, attribute in ipairs(attributes) do
    local ok, value = pcall(function()
      return element:attributeValue(attribute)
    end)
    if ok and type(value) == "string" and value ~= "" then
      table.insert(parts, value)
    end
  end

  return normalize(table.concat(parts, " "))
end

local function matchesCandidate(element)
  local text = elementText(element)
  if text == "" then
    return false
  end

  for _, needle in ipairs(candidateNeedles) do
    if string.find(text, needle, 1, true) then
      return true
    end
  end

  return false
end

local function pressElement(element)
  local actions = { "AXPress", "AXShowMenu" }
  for _, action in ipairs(actions) do
    local ok = pcall(function()
      element:performAction(action)
    end)
    if ok then
      return true
    end
  end

  return false
end

local function searchElements(root, depth)
  if not root or depth > 9 then
    return nil
  end

  local okRole, role = pcall(function()
    return root:attributeValue("AXRole")
  end)
  if okRole and role == "AXButton" and matchesCandidate(root) then
    return root
  end

  local okChildren, children = pcall(function()
    return root:attributeValue("AXChildren")
  end)
  if not okChildren or type(children) ~= "table" then
    return nil
  end

  for _, child in ipairs(children) do
    local found = searchElements(child, depth + 1)
    if found then
      return found
    end
  end

  return nil
end

local function chromeWindowElement(app)
  local axApp = hs.axuielement.applicationElement(app)
  if not axApp then
    return nil
  end

  local focusedWindow = axApp:attributeValue("AXFocusedWindow")
  if focusedWindow then
    return focusedWindow
  end

  local windows = axApp:attributeValue("AXWindows")
  if type(windows) == "table" then
    return windows[1]
  end

  return nil
end

local function clickFallback(app)
  local win = app:focusedWindow()
  if not win then
    return false
  end

  local frame = win:frame()
  local point = hs.geometry.point(frame.x + fallbackOffset.x, frame.y + fallbackOffset.y)
  hs.mouse.absolutePosition(point)
  hs.eventtap.leftClick(point)
  return true
end

local function loadTemplateMask()
  if cachedMask then
    return cachedMask
  end

  if not fileExists(templatePath) then
    return nil
  end

  local image = hs.image.imageFromPath(templatePath)
  if not image then
    return nil
  end

  local size = image:size()
  local points = {}
  for y = 1, size.h, 2 do
    for x = 1, size.w, 2 do
      local color = image:colorAt({ x = x, y = y })
      local alpha = color and color.alpha or 1
      if alpha > 0.4 and brightness(color) > 0.62 then
        table.insert(points, { x = x, y = y })
      end
    end
  end

  if #points < 12 then
    return nil
  end

  cachedMask = {
    size = size,
    points = points,
  }

  return cachedMask
end

local function captureTemplate()
  local screen = hs.mouse.getCurrentScreen() or hs.screen.mainScreen()
  if not screen then
    hs.alert.show("No screen available")
    return
  end

  ensureAssetDir()

  local mouse = hs.mouse.absolutePosition()
  local rect = {
    x = math.floor(mouse.x - (templateCaptureSize.w / 2)),
    y = math.floor(mouse.y - (templateCaptureSize.h / 2)),
    w = templateCaptureSize.w,
    h = templateCaptureSize.h,
  }

  local image = screen:snapshot(rect)
  if not image then
    hs.alert.show("Template capture failed")
    return
  end

  image:saveToFile(templatePath, "PNG")
  cachedMask = nil
  hs.alert.show("Template captured")
end

local function findTemplateMatch(app)
  local mask = loadTemplateMask()
  if not mask then
    return nil
  end

  local win = app:focusedWindow()
  if not win then
    return nil
  end

  local frame = win:frame()
  local screen = win:screen() or hs.screen.mainScreen()
  if not screen then
    return nil
  end

  local rect = {
    x = math.floor(frame.x + searchRegion.x),
    y = math.floor(frame.y + searchRegion.y),
    w = searchRegion.w,
    h = searchRegion.h,
  }

  local snapshot = screen:snapshot(rect)
  if not snapshot then
    return nil
  end

  local maxX = math.max(0, math.floor(rect.w - mask.size.w))
  local maxY = math.max(0, math.floor(rect.h - mask.size.h))
  local bestScore = 0
  local bestPoint = nil

  for y = 0, maxY, 2 do
    for x = 0, maxX, 2 do
      local hits = 0
      for _, point in ipairs(mask.points) do
        local color = snapshot:colorAt({ x = x + point.x, y = y + point.y })
        if brightness(color) > 0.56 then
          hits = hits + 1
        end
      end

      local score = hits / #mask.points
      if score > bestScore then
        bestScore = score
        bestPoint = {
          x = rect.x + x + (mask.size.w / 2),
          y = rect.y + y + (mask.size.h / 2),
        }
      end
    end
  end

  if bestScore >= matchThreshold then
    return bestPoint
  end

  return nil
end

local function toggleChromeVerticalTabs()
  local app = hs.application.get("Google Chrome")
  if not app then
    hs.alert.show("Google Chrome is not running")
    return
  end

  app:activate()

  local windowElement = chromeWindowElement(app)
  if windowElement then
    local button = searchElements(windowElement, 0)
    if button and pressElement(button) then
      return
    end
  end

  local imagePoint = findTemplateMatch(app)
  if imagePoint then
    hs.mouse.absolutePosition(imagePoint)
    hs.eventtap.leftClick(imagePoint)
    return
  end

  if clickFallback(app) then
    hs.alert.show("Used fallback click for Chrome sidebar")
    return
  end

  hs.alert.show("Chrome sidebar toggle not found")
end

local function showCalibration()
  local app = hs.application.get("Google Chrome")
  if not app then
    hs.alert.show("Google Chrome is not running")
    return
  end

  local win = app:focusedWindow()
  if not win then
    hs.alert.show("No focused Chrome window")
    return
  end

  local frame = win:frame()
  local mouse = hs.mouse.absolutePosition()
  local relX = math.floor(mouse.x - frame.x)
  local relY = math.floor(mouse.y - frame.y)
  local message = string.format("Fallback offset: x=%d y=%d", relX, relY)
  hs.pasteboard.setContents(message)
  hs.alert.show(message)
end

hs.hotkey.bind(hotkeyMods, hotkeyKey, toggleChromeVerticalTabs)
hs.hotkey.bind(captureMods, hotkeyKey, captureTemplate)
hs.hotkey.bind({ "ctrl", "alt", "cmd", "shift", "fn" }, hotkeyKey, showCalibration)

hs.alert.show("Hammerspoon loaded")

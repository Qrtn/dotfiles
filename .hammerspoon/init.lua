pcall(require, "hs.ipc")

local hotkeyMods = { "ctrl", "alt", "cmd" }
local hotkeyKey = "S"

-- Fallback click target relative to the top-left of Chrome's focused window.
-- Adjust if Chrome's native vertical-tabs button is in a different spot.
local fallbackOffset = { x = 34, y = 140 }

local candidateNeedles = {
  "vertical tab",
  "sidebar",
  "collapse",
  "expand",
  "side panel",
}

local function normalize(value)
  if type(value) ~= "string" then
    return ""
  end

  return string.lower(value)
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
hs.hotkey.bind({ "ctrl", "alt", "cmd", "shift" }, hotkeyKey, showCalibration)

hs.alert.show("Hammerspoon loaded")

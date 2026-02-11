local ADDON_NAME, CC = ...

-------------------------------------------------------------------------------
--- Setup

CC.crosshair = CreateFrame("Frame", "CursorCrosshairFrame", UIParent)
CC.crosshair:SetAllPoints(UIParent)
CC.crosshair:SetFrameStrata("TOOLTIP")

local h_line = CC.crosshair:CreateLine(nil, "OVERLAY")
h_line:SetThickness(1)
h_line:SetColorTexture(1, 1, 1, 0.5)

local v_line = CC.crosshair:CreateLine(nil, "OVERLAY")
v_line:SetThickness(1)
v_line:SetColorTexture(1, 1, 1, 0.5)

local screen_width = 0
local screen_height = 0
local y_offset = -1 -- offset the cursor by 1 pixel
local x_offset = 1

-------------------------------------------------------------------------------
--- Functions

function CC:UpdateCrosshair()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()

    x = x / scale
    y = y / scale
    -- x = PixelUtil.GetNearestPixelSize((x / scale), scale)
    -- y = PixelUtil.GetNearestPixelSize((y / scale), scale)

    width  = screen_width
    height = screen_height

    h_line:ClearAllPoints()
    h_line:SetStartPoint("BOTTOMLEFT", 0,     y + y_offset)
    h_line:SetEndPoint(  "BOTTOMLEFT", width, y + y_offset)

    v_line:ClearAllPoints()
    v_line:SetStartPoint("BOTTOMLEFT", x + x_offset, 0)
    v_line:SetEndPoint(  "BOTTOMLEFT", x + x_offset, height)

end

local throttle_size_check = false
function CC:getScreenSize()
    if throttle_size_check then return end
    throttle_size_check = true

    -- Checking the screen size immedeatly on the event triggers is showing
    --   the size before the change happens. Delay slightly to get correct
    --   width and add a throttle so we don't check multiple times for similar
    --   events.
    C_Timer.After(0.25, function()
        throttle_size_check = false

        screen_width  = UIParent:GetWidth()
        screen_height = UIParent:GetHeight()
    end)
end

-------------------------------------------------------------------------------
--- Listeners

CC.crosshair:SetScript("OnUpdate", CC.UpdateCrosshair)

-- All registered events should update the screen size,
--   no need to check for specific events.
CC.crosshair:SetScript("OnEvent", CC.getScreenSize)

--- Hook UIParent:SetScale for addons like ElvUI that
---   change scale directly without firing UI_SCALE_CHANGED
hooksecurefunc(UIParent, "SetScale", CC.getScreenSize)

-------------------------------------------------------------------------------
--- Event Registrations
---   Watch for Display changes and Player logins

CC.crosshair:RegisterEvent("PLAYER_LOGIN")
CC.crosshair:RegisterEvent("DISPLAY_SIZE_CHANGED")
CC.crosshair:RegisterEvent("UI_SCALE_CHANGED")

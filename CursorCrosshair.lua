local ADDON_NAME, CC = ...

-------------------------------------------------------------------------------
--- Setup

CC.crosshair = CreateFrame("Frame", "CursorCrosshairFrame", UIParent)
CC.crosshair:SetAllPoints(UIParent)
CC.crosshair:SetFrameStrata("TOOLTIP")

local h_line = CC.crosshair:CreateLine(nil, "OVERLAY")
h_line:SetThickness(1)
h_line:SetColorTexture(1, 1, 1, 0.4)

local v_line = CC.crosshair:CreateLine(nil, "OVERLAY")
v_line:SetThickness(1)
v_line:SetColorTexture(1, 1, 1, 0.4)

local screen_width = 0
local screen_height = 0

-------------------------------------------------------------------------------
--- Functions

function CC:UpdateCrosshair()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    x = x / scale
    y = y / scale

    h_line:ClearAllPoints()
    h_line:SetStartPoint("BOTTOMLEFT", x - screen_width, y)
    h_line:SetEndPoint  ("BOTTOMLEFT", x + screen_width, y)

    v_line:ClearAllPoints()
    v_line:SetStartPoint("BOTTOMLEFT", x, y - screen_height)
    v_line:SetEndPoint  ("BOTTOMLEFT", x, y + screen_height)
end

function CC:getScreenSize()
    screen_width  = UIParent:GetWidth()
    screen_height = UIParent:GetHeight()
end

-------------------------------------------------------------------------------
--- Listeners

CC.crosshair:SetScript("OnUpdate", CC.UpdateCrosshair)

CC.crosshair:SetScript("OnEvent", function(self, event, addon_name, ...)
    -- All registered events should update the screen size,
    --   no need to check for specific events.
    CC:getScreenSize()
end)

CC.crosshair:RegisterEvent("DISPLAY_SIZE_CHANGED")
CC.crosshair:RegisterEvent("UI_SCALE_CHANGED")

-------------------------------------------------------------------------------
--- Init

CC:getScreenSize()

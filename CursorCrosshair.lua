local addon = CreateFrame("Frame", "CursorCrosshairFrame", UIParent)
addon:SetAllPoints(UIParent)
addon:SetFrameStrata("TOOLTIP")

local h_line = addon:CreateLine(nil, "OVERLAY")
h_line:SetThickness(1)
h_line:SetColorTexture(1, 1, 1, 0.5)

local v_line = addon:CreateLine(nil, "OVERLAY")
v_line:SetThickness(1)
v_line:SetColorTexture(1, 1, 1, 0.5)

local function UpdateCrosshair()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    x = x / scale
    y = y / scale

    local width  = UIParent:GetWidth()
    local height = UIParent:GetHeight()

    h_line:ClearAllPoints()
    h_line:SetStartPoint("BOTTOMLEFT", x - width, y)
    h_line:SetEndPoint  ("BOTTOMLEFT", x + width, y)

    v_line:ClearAllPoints()
    v_line:SetStartPoint("BOTTOMLEFT", x, y - height)
    v_line:SetEndPoint  ("BOTTOMLEFT", x, y + height)
end

addon:SetScript("OnUpdate", UpdateCrosshair)

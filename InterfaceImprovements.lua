----------------------------------------------------------------------------------------------------
-- Tables
----------------------------------------------------------------------------------------------------
local defaults = {
    hideExtraButtonArtwork = false,
    hideHotkeys = false,
    hideLOCBackground = false,
    hideMacroNames = false,
    hideStanceBar = false,
    hideXPBar = false,
}

local bars = {
    MainMenuBar,
    MultiBarBottomLeft,
    MultiBarBottomRight,
    MultiBarLeft,
    MultiBarRight,
    MultiBar5,
    MultiBar6,
    MultiBar7,
}
----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------
local function updateExtraButtonArtwork()
    local alpha = InterfaceImprovementsDB.hideExtraButtonArtwork and 0 or 1
    ExtraActionButton1.style:SetAlpha(alpha)
    ZoneAbilityFrame.Style:SetAlpha(alpha)
end

local function updateHotkeys()
    local alpha = InterfaceImprovementsDB.hideHotkeys and 0 or 1
    for _, bar in pairs(bars) do
        for _, button in pairs(bar.actionButtons) do
            button.HotKey:SetAlpha(alpha)
        end
    end
    for _, button in pairs(PetActionBar.actionButtons) do
        button.HotKey:SetAlpha(alpha)
    end
end

local function updateLOCBackground()
    local alpha = InterfaceImprovementsDB.hideLOCBackground and 0 or 1
    LossOfControlFrame.RedLineTop:SetAlpha(alpha)
    LossOfControlFrame.RedLineBottom:SetAlpha(alpha)
    LossOfControlFrame.blackBg:SetAlpha(alpha)
end

local function updateMacroNames()
    local alpha = InterfaceImprovementsDB.hideMacroNames and 0 or 1
    for _, bar in pairs(bars) do
        for _, button in pairs(bar.actionButtons) do
            button.Name:SetAlpha(alpha)
        end
    end
end

local function updateStanceBar()
    local alpha = InterfaceImprovementsDB.hideStanceBar and 0 or 1
    StanceBar:SetAlpha(alpha)
end

local function updateXPBar()
    local alpha = InterfaceImprovementsDB.hideXPBar and 0 or 1
    StatusTrackingBarManager:SetAlpha(alpha)
end

local function shortenHotkeys(self)
    local hotkey = self.HotKey
    local text = hotkey:GetText()
    
    text = gsub(text, "(s%-)", "S")
    text = gsub(text, "(c%-)", "C")
    text = gsub(text, "(a%-)", "A")
    text = gsub(text, KEY_MOUSEWHEELUP, "WU")
    text = gsub(text, KEY_MOUSEWHEELDOWN, "WD")
    
    for i = 1, 12 do
        text = gsub(text, _G["KEY_BUTTON"..i], "M"..i)
    end
    
    hotkey:SetText(text)
end

for _, bar in pairs(bars) do
    for _, button in pairs(bar.actionButtons) do
        hooksecurefunc(button, "UpdateHotkeys", shortenHotkeys)
    end
end

for _, button in pairs(PetActionBar.actionButtons) do
    hooksecurefunc(button, "SetHotkeys", shortenHotkeys)
end

for i = 1, 6 do
    hooksecurefunc(_G["OverrideActionBarButton"..i], "UpdateHotkeys", shortenHotkeys)
end

hooksecurefunc(ExtraActionButton1, "UpdateHotkeys", shortenHotkeys)
----------------------------------------------------------------------------------------------------
-- Config
----------------------------------------------------------------------------------------------------
local panel = CreateFrame("Frame")
panel.name = "InterfaceImprovements"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", panel, 15, -15)
title:SetText("InterfaceImprovements")

local offsetY = -10
local function createCheckButton(name)
    offsetY = offsetY - 30
    local checkButton = CreateFrame("CheckButton", nil, panel, "ChatConfigCheckButtonTemplate")
    checkButton:SetPoint("TOPLEFT", panel, 15, offsetY)
    checkButton.Text:SetText(name)
    checkButton.Text:SetPoint("LEFT", checkButton, "RIGHT")
    return checkButton
end

local updateExtraButtonArtworkCB = createCheckButton("Hide Extra Button Artwork")
updateExtraButtonArtworkCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideExtraButtonArtwork = not InterfaceImprovementsDB.hideExtraButtonArtwork
    updateExtraButtonArtwork()
end)

local updateHotkeysCB = createCheckButton("Hide Hotkeys")
updateHotkeysCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideHotkeys = not InterfaceImprovementsDB.hideHotkeys
    updateHotkeys()
end)

local updateLOCBackgroundCB = createCheckButton("Hide Loss of Control Background")
updateLOCBackgroundCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideLOCBackground = not InterfaceImprovementsDB.hideLOCBackground
    updateLOCBackground()
end)

local updateMacroNamesCB = createCheckButton("Hide Macro Names")
updateMacroNamesCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideMacroNames = not InterfaceImprovementsDB.hideMacroNames
    updateMacroNames()
end)

local updateStanceBarCB = createCheckButton("Hide Stance Bar")
updateStanceBarCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideStanceBar = not InterfaceImprovementsDB.hideStanceBar
    updateStanceBar()
end)

local updateXPBarCB = createCheckButton("Hide XP Bar")
updateXPBarCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideXPBar = not InterfaceImprovementsDB.hideXPBar
    updateXPBar()
end)
----------------------------------------------------------------------------------------------------
-- Events
----------------------------------------------------------------------------------------------------
local event = CreateFrame("Frame")
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("PLAYER_LOGIN")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function event:ADDON_LOADED(name)
    if name == "InterfaceImprovements" then
        InterfaceImprovementsDB = InterfaceImprovementsDB or {}
        for k, v in pairs(defaults) do
            if InterfaceImprovementsDB[k] == nil then
                InterfaceImprovementsDB[k] = v
            end
        end
    end
end

function event:PLAYER_LOGIN()
    updateExtraButtonArtworkCB:SetChecked(InterfaceImprovementsDB.hideExtraButtonArtwork)
    updateHotkeysCB:SetChecked(InterfaceImprovementsDB.hideHotkeys)
    updateLOCBackgroundCB:SetChecked(InterfaceImprovementsDB.hideLOCBackground)
    updateMacroNamesCB:SetChecked(InterfaceImprovementsDB.hideMacroNames)
    updateStanceBarCB:SetChecked(InterfaceImprovementsDB.hideStanceBar)
    updateXPBarCB:SetChecked(InterfaceImprovementsDB.hideXPBar)
end

function event:PLAYER_ENTERING_WORLD()
    updateExtraButtonArtwork()
    updateHotkeys()
    updateLOCBackground()
    updateMacroNames()
    updateStanceBar()
    updateXPBar()
end
----------------------------------------------------------------------------------------------------
-- Slash Commands
----------------------------------------------------------------------------------------------------
SLASH_reloadUI1 = "/rl"
SlashCmdList.reloadUI = ReloadUI

SLASH_fStack1 = "/fs"
SlashCmdList.fStack = function()
LoadAddOn("Blizzard_DebugTools")
FrameStackTooltip_Toggle()
end

SLASH_InterfaceImprovements1 = "/ii"
SlashCmdList.InterfaceImprovements = function()
InterfaceOptionsFrame_OpenToCategory("InterfaceImprovements")
end

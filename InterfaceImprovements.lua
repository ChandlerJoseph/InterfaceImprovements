----------------------------------------------------------------------------------------------------
-- Tables
----------------------------------------------------------------------------------------------------
local defaults = {
    hideEmptyButtons = false,
    hideExtraButtonArtwork = false,
    hideHotkeys = false,
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
local function updateButtons(forceShow)
    for _, button in pairs(MainMenuBar.actionButtons) do
        if InterfaceImprovementsDB.hideEmptyButtons and forceShow or GetCursorInfo() then
            button:SetAlpha(1)
        elseif InterfaceImprovementsDB.hideEmptyButtons and not SpellBookFrame:IsShown() and (not IsAddOnLoaded("Blizzard_ClassTalentUI") or not ClassTalentFrame:IsShown()) and not button:HasAction() then
            button:SetAlpha(0)
        else
            button:SetAlpha(1)
        end
    end
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

local function updateMacroNames()
    local alpha = InterfaceImprovementsDB.hideMacroNames and 0 or 1
    for _, bar in pairs(bars) do
        for _, button in pairs(bar.actionButtons) do
            button.Name:SetAlpha(alpha)
        end
    end
end

local function updateExtraButtonArtwork()
    local alpha = InterfaceImprovementsDB.hideExtraButtonArtwork and 0 or 1
    ExtraActionButton1.style:SetAlpha(alpha)
    ZoneAbilityFrame.Style:SetAlpha(alpha)
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

SpellBookFrame:HookScript("OnShow", function()
    updateButtons(true)
end)

SpellBookFrame:HookScript("OnHide", function()
    updateButtons()
end)

QuickKeybindFrame:HookScript("OnShow", function()
    updateButtons(true)
end)

QuickKeybindFrame:HookScript("OnHide", function()
    updateButtons()
end)
----------------------------------------------------------------------------------------------------
-- Config
----------------------------------------------------------------------------------------------------
local panel = CreateFrame("Frame")
panel.name = "InterfaceImprovements"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", panel, 16, -16)
title:SetText("InterfaceImprovements")

local hideEmptyButtonsCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideEmptyButtonsCB:SetPoint("TOPLEFT", title, -3, -24)
hideEmptyButtonsCB.Text:SetText("Hide Empty Buttons")
hideEmptyButtonsCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideEmptyButtons = not InterfaceImprovementsDB.hideEmptyButtons
    updateButtons()
end)

local hideExtraButtonArtworkCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideExtraButtonArtworkCB:SetPoint("CENTER", hideEmptyButtonsCB, 0, -31)
hideExtraButtonArtworkCB.Text:SetText("Hide Extra Button Artwork")
hideExtraButtonArtworkCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideExtraButtonArtwork = not InterfaceImprovementsDB.hideExtraButtonArtwork
    updateExtraButtonArtwork()
end)

local hideHotkeysCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideHotkeysCB:SetPoint("CENTER", hideExtraButtonArtworkCB, 0, -31)
hideHotkeysCB.Text:SetText("Hide Hotkeys")
hideHotkeysCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideHotkeys = not InterfaceImprovementsDB.hideHotkeys
    updateHotkeys()
end)

local hideMacroNamesCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideMacroNamesCB:SetPoint("CENTER", hideHotkeysCB, 0, -31)
hideMacroNamesCB.Text:SetText("Hide Macro Names")
hideMacroNamesCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideMacroNames = not InterfaceImprovementsDB.hideMacroNames
    updateMacroNames()
end)

local hideStanceBarCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideStanceBarCB:SetPoint("CENTER", hideMacroNamesCB, 0, -31)
hideStanceBarCB.Text:SetText("Hide Stance Bar")
hideStanceBarCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideStanceBar = not InterfaceImprovementsDB.hideStanceBar
    updateStanceBar()
end)

local hideXPBarCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideXPBarCB:SetPoint("CENTER", hideStanceBarCB, 0, -31)
hideXPBarCB.Text:SetText("Hide XP Bar")
hideXPBarCB:SetScript("OnClick", function()
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
event:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
event:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
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

function event:ADDON_LOADED(name)
    if name == "Blizzard_ClassTalentUI" then
        ClassTalentFrame:HookScript("OnShow", function()
            updateButtons(true)
        end)
        ClassTalentFrame:HookScript("OnHide", function()
            updateButtons()
        end)
    end
end

function event:PLAYER_LOGIN()
    hideEmptyButtonsCB:SetChecked(InterfaceImprovementsDB.hideEmptyButtons)
    hideExtraButtonArtworkCB:SetChecked(InterfaceImprovementsDB.hideExtraButtonArtwork)
    hideHotkeysCB:SetChecked(InterfaceImprovementsDB.hideHotkeys)
    hideMacroNamesCB:SetChecked(InterfaceImprovementsDB.hideMacroNames)
    hideStanceBarCB:SetChecked(InterfaceImprovementsDB.hideStanceBar)
    hideXPBarCB:SetChecked(InterfaceImprovementsDB.hideXPBar)
end

function event:PLAYER_ENTERING_WORLD()
    updateButtons()
    updateExtraButtonArtwork()
    updateHotkeys()
    updateMacroNames()
    updateStanceBar()
    updateXPBar()
end

function event:ACTIONBAR_SLOT_CHANGED()
    updateButtons()
end

function event:UPDATE_BONUS_ACTIONBAR()
    updateButtons()
end
----------------------------------------------------------------------------------------------------
-- Slash Commands
----------------------------------------------------------------------------------------------------
SLASH_reloadUI1 = "/rl"
SlashCmdList.reloadUI = reloadUI

SLASH_fStack1 = "/fs"
SlashCmdList.fStack = function()
LoadAddOn("Blizzard_DebugTools")
FrameStackTooltip_Toggle()
end

SLASH_InterfaceImprovements1 = "/ii"
SlashCmdList.InterfaceImprovements = function()
InterfaceOptionsFrame_OpenToCategory("InterfaceImprovements")
end

----------------------------------------------------------------------------------------------------
-- Tables
----------------------------------------------------------------------------------------------------
local defaults = {
	hideEmptyButtons = false,
    hideHotkeys = false,
    hideMacroNames = false,
	hideStanceBar = false,
    hideXPBar = false
}

local buttons = {
    ExtraActionButton1
}

for i = 1, 12 do
    tinsert(buttons, _G["ActionButton"..i])
    tinsert(buttons, _G["MultiBarBottomLeftButton"..i])
    tinsert(buttons, _G["MultiBarBottomRightButton"..i])
    tinsert(buttons, _G["MultiBarLeftButton"..i])
    tinsert(buttons, _G["MultiBarRightButton"..i])
    tinsert(buttons, _G["MultiBar5Button"..i])
    tinsert(buttons, _G["MultiBar6Button"..i])
    tinsert(buttons, _G["MultiBar7Button"..i])
end

for i = 1, 6 do
    tinsert(buttons, _G["OverrideActionBarButton"..i])
end

local petButtons = {}

for i = 1, 10 do
    tinsert(petButtons, _G["PetActionButton"..i])
end
----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------
ExtraActionButton1.style:SetAlpha(0)
ZoneAbilityFrame.Style:SetAlpha(0)

local function showEmptyButtons()
	for i = 1, 12 do
		_G["ActionButton"..i]:SetAlpha(1)
	end
end

local function hideEmptyButtons()
	for i = 1, 12 do
		if not _G["ActionButton"..i]:HasAction() then
			_G["ActionButton"..i]:SetAlpha(0)
		end
	end
end

local function toggleEmptyButtons()
	if InterfaceImprovementsDB.hideEmptyButtons then
		hideEmptyButtons()
	else
		showEmptyButtons()
	end
end

SpellBookFrame:HookScript("OnShow", function()
	if InterfaceImprovementsDB.hideEmptyButtons then
		showEmptyButtons()
	end
end)

SpellBookFrame:HookScript("OnHide", function()
	if InterfaceImprovementsDB.hideEmptyButtons then
		if not GetCursorInfo() then
			hideEmptyButtons()
		end
	end
end)

QuickKeybindFrame:HookScript("OnShow", function()
	if InterfaceImprovementsDB.hideEmptyButtons then
		showEmptyButtons()
	end
end)

QuickKeybindFrame:HookScript("OnHide", function()
	if InterfaceImprovementsDB.hideEmptyButtons then
		hideEmptyButtons()
	end
end)

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

local function hookHotkeys(table)
    for _, v in pairs(table) do
        hooksecurefunc(v, "UpdateHotkeys", shortenHotkeys)
    end
end
hookHotkeys(buttons)

local function hookPetHotkeys(table)
    for _, v in pairs(table) do
        hooksecurefunc(v, "SetHotkeys", shortenHotkeys)
    end
end
hookPetHotkeys(petButtons)

local function toggleHotkeys()
    local alpha = InterfaceImprovementsDB.hideHotkeys and 0 or 1
    for i = 1, 12 do
        _G["ActionButton"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBar5Button"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBar6Button"..i.."HotKey"]:SetAlpha(alpha)
        _G["MultiBar7Button"..i.."HotKey"]:SetAlpha(alpha)
    end
end

local function toggleMacroNames()
    local alpha = InterfaceImprovementsDB.hideMacroNames and 0 or 1
    for i = 1, 12 do
        _G["ActionButton"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBarLeftButton"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBarRightButton"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBar5Button"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBar6Button"..i.."Name"]:SetAlpha(alpha)
        _G["MultiBar7Button"..i.."Name"]:SetAlpha(alpha)
    end
end

local function toggleStanceBar()
	local alpha = InterfaceImprovementsDB.hideStanceBar and 0 or 1
	StanceBar:SetAlpha(alpha)
end

local function toggleXPBar()
    local alpha = InterfaceImprovementsDB.hideXPBar and 0 or 1
    StatusTrackingBarManager:SetAlpha(alpha)
end
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
    toggleEmptyButtons()
end)

local hideHotkeysCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideHotkeysCB:SetPoint("CENTER", hideEmptyButtonsCB, 0, -31)
hideHotkeysCB.Text:SetText("Hide Hotkeys")
hideHotkeysCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideHotkeys = not InterfaceImprovementsDB.hideHotkeys
    toggleHotkeys()
end)

local hideMacroNamesCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideMacroNamesCB:SetPoint("CENTER", hideHotkeysCB, 0, -31)
hideMacroNamesCB.Text:SetText("Hide Macro Names")
hideMacroNamesCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideMacroNames = not InterfaceImprovementsDB.hideMacroNames
    toggleMacroNames()
end)

local hideStanceBarCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideStanceBarCB:SetPoint("CENTER", hideMacroNamesCB, 0, -31)
hideStanceBarCB.Text:SetText("Hide Stance Bar")
hideStanceBarCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideStanceBar = not InterfaceImprovementsDB.hideStanceBar
    toggleStanceBar()
end)

local hideXPBarCB = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
hideXPBarCB:SetPoint("CENTER", hideStanceBarCB, 0, -31)
hideXPBarCB.Text:SetText("Hide XP Bar")
hideXPBarCB:SetScript("OnClick", function()
    InterfaceImprovementsDB.hideXPBar = not InterfaceImprovementsDB.hideXPBar
    toggleXPBar()
end)
----------------------------------------------------------------------------------------------------
-- Events
----------------------------------------------------------------------------------------------------
local event = CreateFrame("Frame")
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("PLAYER_LOGIN")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("ACTIONBAR_SHOWGRID")
event:RegisterEvent("ACTIONBAR_HIDEGRID")
event:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
event:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
event:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == "InterfaceImprovements" then
            InterfaceImprovementsDB = InterfaceImprovementsDB or {}
            for k, v in pairs(defaults) do
                if InterfaceImprovementsDB[k] == nil then
                    InterfaceImprovementsDB[k] = v
                end
            end
        end
		if name == "Blizzard_ClassTalentUI" then
			ClassTalentFrame:HookScript("OnShow", function()
				if InterfaceImprovementsDB.hideEmptyButtons then
					showEmptyButtons()
				end
			end)
			ClassTalentFrame:HookScript("OnHide", function()
				if InterfaceImprovementsDB.hideEmptyButtons then
					if not GetCursorInfo() then
						hideEmptyButtons()
					end
				end
			end)
		end
    elseif event == "PLAYER_LOGIN" then
		hideEmptyButtonsCB:SetChecked(InterfaceImprovementsDB.hideEmptyButtons)
        hideHotkeysCB:SetChecked(InterfaceImprovementsDB.hideHotkeys)
        hideMacroNamesCB:SetChecked(InterfaceImprovementsDB.hideMacroNames)
		hideStanceBarCB:SetChecked(InterfaceImprovementsDB.hideStanceBar)
        hideXPBarCB:SetChecked(InterfaceImprovementsDB.hideXPBar)
    elseif event == "PLAYER_ENTERING_WORLD" then
		toggleEmptyButtons()
        toggleHotkeys()
        toggleMacroNames()
		toggleStanceBar()
        toggleXPBar()
	elseif event == "ACTIONBAR_SHOWGRID" then
		if InterfaceImprovementsDB.hideEmptyButtons then
			showEmptyButtons()
		end
	elseif event == "ACTIONBAR_HIDEGRID" then
		if InterfaceImprovementsDB.hideEmptyButtons then
			if not SpellBookFrame:IsShown() and (not IsAddOnLoaded("Blizzard_ClassTalentUI") or not ClassTalentFrame:IsShown()) then
				C_Timer.After(0, function()
					hideEmptyButtons()
				end)
			end
		end
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		if InterfaceImprovementsDB.hideEmptyButtons then
			if not SpellBookFrame:IsShown() and (not IsAddOnLoaded("Blizzard_ClassTalentUI") or not ClassTalentFrame:IsShown()) then
				if GetCursorInfo() then
					C_Timer.After(0.01, function()
						showEmptyButtons()
					end)
				else
					hideEmptyButtons()
				end
			end
		end
	elseif event == "UPDATE_BONUS_ACTIONBAR" then
		if InterfaceImprovementsDB.hideEmptyButtons then
			if not SpellBookFrame:IsShown() and (not IsAddOnLoaded("Blizzard_ClassTalentUI") or not ClassTalentFrame:IsShown()) then
				for i = 1, 12 do
					if not _G["ActionButton"..i]:HasAction() then
						_G["ActionButton"..i]:SetAlpha(0)
					else
						_G["ActionButton"..i]:SetAlpha(1)
					end
				end
			end
		end
	end
end)
----------------------------------------------------------------------------------------------------
-- Slash commands
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
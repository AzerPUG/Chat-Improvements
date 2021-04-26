if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["Chat Improvements"] = 23
if AZP.ChatImprovements == nil then AZP.ChatImprovements = {} end

local defaultBehaviour = SendChatMessage
local AZPCISelfOptionPanel = nil
local optionHeader = "|cFF00FFFFChat Improvements|r"
local EventFrame, UpdateFrame = nil, nil

local HaveShowedUpdateNotification = false

function AZP.ChatImprovements:OnLoadBoth()
    SendChatMessage = function(message, ...)
        if AZPChatPrefix ~= nil and AZPChatPrefix ~= "" then
            defaultBehaviour("(" .. AZPChatPrefix .. ") " .. message, ...)
        else
            defaultBehaviour(message, ...)
        end
    end

    if AZPChatPrefix == nil then AZPChatPrefix = "" end

    local function AZPFilterChat(self, event, msg, author, ...)
        local filtered = false
        local lmsg = string.lower(msg)
        for phrase = 1, #AZP.ChatImprovements.KeyPhrases do
            if lmsg:find(string.lower(AZP.ChatImprovements.KeyPhrases[phrase])) then
                filtered = true
            end
        end
        if filtered == true then
            return true
        else
            return false, msg, author, ...
        end
    end

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", AZPFilterChat)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", AZPFilterChat)
end

function AZP.ChatImprovements:OnLoadCore()
    AZP.ChatImprovements:OnLoadBoth()
    AZP.Core:RegisterEvents("VARIABLES_LOADED", function() AZP.ChatImprovements:eventVariablesLoaded() end)
    AZP.OptionsPanels:RemovePanel("Chat Improvements")
    AZP.OptionsPanels:Generic("Chat Improvements", optionHeader, function (frame)
        AZP.ChatImprovements:FillOptionsPanel(frame)
    end)
end

function AZP.ChatImprovements:OnLoadSelf()
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")

    EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    EventFrame:SetScript("OnEvent", function(...) AZP.ChatImprovements:OnEvent(...) end)

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(400, 200)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG's ToolTips is out of date!|r")

    UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
    UpdateFrame.text:SetPoint("TOP", 0, -40)
    UpdateFrame.text:SetText("Error!")

    UpdateFrame:Hide()

    AZPCISelfOptionPanel = CreateFrame("FRAME", nil)
    AZPCISelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPCISelfOptionPanel)
    AZPCISelfOptionPanel.header = AZPCISelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPCISelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPCISelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's Chat Improvements Options!|r")

    AZPCISelfOptionPanel.footer = AZPCISelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPCISelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPCISelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )
    AZP.ChatImprovements:FillOptionsPanel(AZPCISelfOptionPanel)
    AZP.ChatImprovements:OnLoadBoth()
end

function AZP.ChatImprovements:eventVariablesLoaded()
    if AZPChatPrefix == nil then
        AZPChatPrefix = ""
    end
end

function AZP.ChatImprovements:FillOptionsPanel(frameToFill)
    local AZPChatPrefixLabel = CreateFrame("Frame", "AZPChatPrefixLabel", frameToFill)
    AZPChatPrefixLabel:SetSize(500, 15)
    AZPChatPrefixLabel:SetPoint("TOPLEFT", 25, -50)
    AZPChatPrefixLabel.contentText = AZPChatPrefixLabel:CreateFontString("AZPChatPrefixLabel", "ARTWORK", "GameFontNormalLarge")
    AZPChatPrefixLabel.contentText:SetPoint("TOPLEFT")
    AZPChatPrefixLabel.contentText:SetText("Chat message Prefix (Requires reload if changed!)")

    local AZPChatPrefixEditBox = CreateFrame("EditBox", "AZPAutoInviteEditBox", frameToFill, "InputBoxTemplate")
    AZPChatPrefixEditBox:SetSize(150, 35)
    AZPChatPrefixEditBox:SetWidth(150)
    AZPChatPrefixEditBox:SetPoint("TOPLEFT", 25, -65)
    AZPChatPrefixEditBox:SetAutoFocus(false)
    AZPChatPrefixEditBox:SetScript("OnEditFocusLost", function() AZPChatPrefix = AZPChatPrefixEditBox:GetText() end)
    frameToFill:SetScript("OnShow", function()
        AZPChatPrefixEditBox:SetText(AZPChatPrefix)
    end)
    AZPChatPrefixEditBox:SetFrameStrata("DIALOG")
    AZPChatPrefixEditBox:SetMaxLetters(100)
    AZPChatPrefixEditBox:SetFontObject("ChatFontNormal")

    frameToFill:Hide() -- Hide, so OnShow gets called when the user opens interface options.
end

function AZP.ChatImprovements:ShareVersion()
    local versionString = string.format("|CI:%d|", AZP.VersionControl["Chat Improvements"])
    if IsInGroup() then
        if IsInRaid() then
            C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
        else
            C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
        end
    end
    if IsInGuild() then
        C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
    end
end

function AZP.ChatImprovements:ReceiveVersion(version)
    if version > AZP.VersionControl["Chat Improvements"] then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" .. 
                "Newer Version: v" .. version .. "\n" .. 
                "Your version: v" .. AZP.VersionControl["Chat Improvements"]
            )
        end
    end
end

function AZP.ChatImprovements:GetSpecificAddonVersion(versionString, addonWanted)
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1
    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        if addon == addonWanted then
            return tonumber(version)
        end
    end
end


function AZP.ChatImprovements:OnEvent(_, event, ...)
    if event == "VARIABLES_LOADED" then
        AZP.ChatImprovements:eventVariablesLoaded(...)
        AZP.ChatImprovements:ShareVersion()
    elseif event == "GROUP_ROSTER_UPDATE" then
        AZP.ChatImprovements:ShareVersion()
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, payload, _, sender = ...
        if prefix == "AZPVERSIONS" then
            local version = AZP.ChatImprovements:GetSpecificAddonVersion(payload, "CI")
            if version ~= nil then
                AZP.ChatImprovements:ReceiveVersion(version)
            end
        end
    end
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.ChatImprovements:OnLoadSelf()
end
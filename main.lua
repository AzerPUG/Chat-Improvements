local GlobalAddonName, AGU = ...

local AZPGUChattyThingsVersion = 0.1
local dash = " - "
local name = "GameUtility" .. dash .. "ChattyThings"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPGUChattyThingsVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("GameUtility-ChattyThings", "AceConsole-3.0")
local defaultBehaviour = SendChatMessage
function AZP.GU.VersionControl:ChattyThings()
    return AZPGUChattyThingsVersion
end

function AZP.GU.OnLoad:ChattyThings(self)
    GameUtilityAddonFrame:RegisterEvent("CHAT_MSG_CHANNEL")
    SendChatMessage = function(message, ...)
        if AZPChatPrefix ~= nil and AZPChatPrefix ~= "" then
            defaultBehaviour("(" .. AZPChatPrefix .. ") " .. message, ...)
        else
            defaultBehaviour(message, ...)
        end
    end
    ChattyThingsSubPanel:Hide()
    addonMain:ChangeOptionsText()

    if AZPChatPrefix == nil then AZPChatPrefix = "" end
end

function AZP.GU.OnEvent:ChattyThings(event, ...)
    if event == "CHAT_MSG_CHANNEL" then
        --local pName, pServer = UnitFullName("player")
        --local playerFullName = (pName .. "-" .. pServer)
        local msgText, msgSender, _, msgChannelName = ...
    end
end

function addonMain:ChangeOptionsText()
    ChattyThingsSubPanelPHTitle:Hide()
    ChattyThingsSubPanelPHText:Hide()
    ChattyThingsSubPanelPHTitle:SetParent(nil)
    ChattyThingsSubPanelPHText:SetParent(nil)

    local ChattyThingsSubPanelHeader = ChattyThingsSubPanel:CreateFontString("ChattyThingsSubPanelHeader", "ARTWORK", "GameFontNormalHuge")
    ChattyThingsSubPanelHeader:SetText(promo)
    ChattyThingsSubPanelHeader:SetWidth(ChattyThingsSubPanel:GetWidth())
    ChattyThingsSubPanelHeader:SetHeight(ChattyThingsSubPanel:GetHeight())
    ChattyThingsSubPanelHeader:SetPoint("TOP", 0, -10)

    local AZPChatPrefixLabel = CreateFrame("Frame", "AZPChatPrefixLabel", ChattyThingsSubPanel)
    AZPChatPrefixLabel:SetSize(500, 15)
    AZPChatPrefixLabel:SetPoint("TOPLEFT", 25, -50)
    AZPChatPrefixLabel.contentText = AZPChatPrefixLabel:CreateFontString("AZPChatPrefixLabel", "ARTWORK", "GameFontNormalLarge")
    AZPChatPrefixLabel.contentText:SetPoint("TOPLEFT")
    AZPChatPrefixLabel.contentText:SetText("Chat message Prefix")

    local AZPChatPrefixEditBox = CreateFrame("EditBox", "AZPAutoInviteEditBox", ChattyThingsSubPanel, "InputBoxTemplate")
    AZPChatPrefixEditBox:SetSize(150, 35)
    AZPChatPrefixEditBox:SetWidth(150)
    AZPChatPrefixEditBox:SetPoint("TOPLEFT", 25, -65)
    AZPChatPrefixEditBox:SetAutoFocus(false)
    AZPChatPrefixEditBox:SetScript("OnEditFocusLost", function() AZPChatPrefix = AZPChatPrefixEditBox:GetText() end)
    ChattyThingsSubPanel:SetScript("OnShow", function()
        AZPChatPrefixEditBox:SetText(AZPChatPrefix)
    end)
    AZPChatPrefixEditBox:SetFrameStrata("DIALOG")
    AZPChatPrefixEditBox:SetMaxLetters(100)
    AZPChatPrefixEditBox:SetFontObject("ChatFontNormal")
end

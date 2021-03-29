local GlobalAddonName, AGU = ...

local AZPGUChattyThingsVersion = 23
local dash = " - "
local name = "GameUtility" .. dash .. "ChattyThings"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPGUChattyThingsVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("GameUtility-ChattyThings", "AceConsole-3.0")

local defaultBehaviour = SendChatMessage
local KeyPhrases = AGU.KeyPhrases

function AZP.GU.VersionControl:ChattyThings()
    return AZPGUChattyThingsVersion
end

function AZP.GU.OnLoad:ChattyThings(self)
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

    local function AZPFilterChat(self, event, msg, author, ...)
        local filtered = false
        local lmsg = string.lower(msg)
        for phrase = 1, #KeyPhrases do
            if lmsg:find(string.lower(KeyPhrases[phrase])) then
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

function AZP.GU.OnEvent:ChattyThings(event, ...)
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
    AZPChatPrefixLabel.contentText:SetText("Chat message Prefix (Requires reload if changed!)")

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
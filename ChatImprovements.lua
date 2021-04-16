if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.ChatImprovements = 23
if AZP.ChatImprovements == nil then AZP.ChatImprovements = {} end

local defaultBehaviour = SendChatMessage
local AZPCISelfOptionPanel = nil
local optionHeader = "|cFF00FFFFChat Improvements|r"

function AZP.VersionControl:ChatImprovements()
    return AZP.VersionControl.ChatImprovements
end

function AZP.ChatImprovements:OnLoadBoth()
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

    AZP.OptionsPanels:Generic("Chat Improvements", optionHeader, function (frame)
        AZP.ChatImprovements:FillOptionsPanel(frame)
    end)
end

function AZP.ChatImprovements:OnLoadSelf()
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
end

function AZP.OnEvent:ChatImprovements(event, ...)
end

-- function AZP.ChatImprovements:ChangeOptionsText()
--     ChattyThingsSubPanelPHTitle:Hide()
--     ChattyThingsSubPanelPHText:Hide()
--     ChattyThingsSubPanelPHTitle:SetParent(nil)
--     ChattyThingsSubPanelPHText:SetParent(nil)

--     local ChattyThingsSubPanelHeader = ChattyThingsSubPanel:CreateFontString("ChattyThingsSubPanelHeader", "ARTWORK", "GameFontNormalHuge")
--     ChattyThingsSubPanelHeader:SetText(promo)
--     ChattyThingsSubPanelHeader:SetWidth(ChattyThingsSubPanel:GetWidth())
--     ChattyThingsSubPanelHeader:SetHeight(ChattyThingsSubPanel:GetHeight())
--     ChattyThingsSubPanelHeader:SetPoint("TOP", 0, -10)

    
-- end

if not IsAddOnLoaded("AzerPUG's Core") then
    AZP.ChatImprovements:OnLoadSelf()
end
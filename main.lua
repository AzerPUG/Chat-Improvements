local GlobalAddonName, AGU = ...

local AZPGUChatyThingsVersion = 0.1
local dash = " - "
local name = "GameUtility" .. dash .. "ChatyThings"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPGUChatyThingsVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("GameUtility-ChatyThings", "AceConsole-3.0")

function AZP.GU.VersionControl:ChatyThings()
    return AZPGUChatyThingsVersion
end

function AZP.GU.OnLoad:ChatyThings(self)
    GameUtilityAddonFrame:RegisterEvent("CHAT_MSG_CHANNEL")
end

function AZP.GU.OnEvent:ChatyThings(event, ...)
    print("\124cffff00fftest321\124r")
    if event == "CHAT_MSG_CHANNEL" then
        --local pName, pServer = UnitFullName("player")
        --local playerFullName = (pName .. "-" .. pServer)
        local msgText, msgSender, _, msgChannelName = ...
    end
end

-- local function myChatFilter(self, event, msg, author, ...)
--     if msg:find("buy gold") then
--       return true
--     end
--     if author == "Knownspammer" then
--       return true
--     end
--     if msg:find("lol") then
--       return false, gsub(msg, "lol", ""), author, ...
--     end
--   end
  
--   ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
--   ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
--   ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
--   ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
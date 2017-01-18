--
-- TSAnnoy callback functions
--
-- To avoid function name collisions, you should use local functions and export them with a unique package name.
--

local MenuIDs = {
	MENU_ID_CLIENT_1  = 1,
	MENU_ID_CLIENT_2  = 2,
	MENU_ID_CHANNEL_1 = 3,
	MENU_ID_CHANNEL_2 = 4,
	MENU_ID_CHANNEL_3 = 5,
	MENU_ID_GLOBAL_1  = 6,
	MENU_ID_GLOBAL_2  = 7
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

local function onConnectStatusChangeEvent(serverConnectionHandlerID, status, errorNumber)
    print("TSAnnoy: onConnectStatusChangeEvent: " .. serverConnectionHandlerID .. " " .. status .. " " .. errorNumber)
end

local function onNewChannelEvent(serverConnectionHandlerID, channelID, channelParentID)
    print("TSAnnoy: onNewChannelEvent: " .. serverConnectionHandlerID .. " " .. channelID .. " " .. channelParentID)
end

local function onTalkStatusChangeEvent(serverConnectionHandlerID, status, isReceivedWhisper, clientID)
    print("TSAnnoy: onTalkStatusChangeEvent: " .. serverConnectionHandlerID .. " " .. status .. " " .. isReceivedWhisper .. " " .. clientID)
end

local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
    print("TSAnnoy: onTextMessageEvent: " .. serverConnectionHandlerID .. " " .. targetMode .. " " .. toID .. " " .. fromID .. " " .. fromName .. " " .. fromUniqueIdentifier .. " " .. message .. " " .. ffIgnored)
	return 0
end

local function onPluginCommandEvent(serverConnectionHandlerID, pluginName, pluginCommand)
	print("TSAnnoy: onPluginCommandEvent: " .. serverConnectionHandlerID .. " " .. pluginName .. " " .. pluginCommand)
end

--
-- Called when a plugin menu item (see ts3plugin_initMenus) is triggered. Optional function, when not using plugin menus, do not implement this.
--
-- Parameters:
--  serverConnectionHandlerID: ID of the current server tab
--  type: Type of the menu (ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CHANNEL, ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CLIENT or ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL)
--  menuItemID: Id used when creating the menu item
--  selectedItemID: Channel or Client ID in the case of PLUGIN_MENU_TYPE_CHANNEL and PLUGIN_MENU_TYPE_CLIENT. 0 for PLUGIN_MENU_TYPE_GLOBAL.
--
local function onMenuItemEvent(serverConnectionHandlerID, menuType, menuItemID, selectedItemID)
	print("TSAnnoy: onMenuItemEvent: " .. serverConnectionHandlerID .. " " .. menuType .. " " .. menuItemID .. " " .. selectedItemID)
end

TSAnnoy_events = {
	MenuIDs = MenuIDs,
	moduleMenuItemID = moduleMenuItemID,
	onConnectStatusChangeEvent = onConnectStatusChangeEvent,
	onNewChannelEvent = onNewChannelEvent,
	onTalkStatusChangeEvent = onTalkStatusChangeEvent,
	onTextMessageEvent = onTextMessageEvent,
	onPluginCommandEvent = onPluginCommandEvent,
	onMenuItemEvent = onMenuItemEvent
}

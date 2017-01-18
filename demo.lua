-- Basic teamspeak lua script for the teamspeak lua scripting addon
-- By Travis Leeden

require("ts3defs")
require("ts3errors")

-- Call these function from the TeamSpeak 3 client console via: /lua run testmodule.<function>
-- Note the serverConnectionHandlerID of the current server is always passed.

-- Pokes a selected user by their nickname
-- userName = user to be poked
-- pokeText = text to be used in the poke
-- pokeAmount = amount of times the poke is to be sent to the user
local function pokeUser(serverConnectionHandlerID, userName, pokeText, pokeAmount)
	local userToBePoked

	-- Get Client List
	local clients, error = ts3.getClientList(serverConnectionHandlerID)
	if error == ts3errors.ERROR_not_connected then
		ts3.printMessageToCurrentTab("Not connected")
		return
	elseif error ~= ts3errors.ERROR_ok then
		print("Error getting client list: " .. error)
		return
	end

	local msg = ("There are currently " .. #clients .. " visible clients:")
	for i=1, #clients do
		local clientName, error = ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_NICKNAME)
		if error == ts3errors.ERROR_ok then
			if clientName == userName then
				userToBePoked = clients[i]
			end
		else
			clientName = "Error getting client name"
		end
	end
	for i = 1, pokeAmount, 1 do
		ts3.requestClientPoke(serverConnectionHandlerID, userToBePoked, pokeText)
	end
	ts3.printMessageToCurrentTab("Poking user " .. userToBePoked)
end

-- Pokes all users on the teamspeak server
-- pokeText = text to be sent to all connected users
local function pokeAllUsers(serverConnectionHandlerID,pokeText)
	-- Get Client List
	local clients, error = ts3.getClientList(serverConnectionHandlerID)
	if error == ts3errors.ERROR_not_connected then
		ts3.printMessageToCurrentTab("Not connected")
		return
	elseif error ~= ts3errors.ERROR_ok then
		print("Error getting client list: " .. error)
		return
	end

	for i=1, #clients do
		if error == ts3errors.ERROR_ok then
				ts3.requestClientPoke(serverConnectionHandlerID, clients[i], pokeText)
		else
			ts3.printMessageToCurrentTab("An error has occured ")
		end
	end
end

--Helper functions

--Return own clientID
local function getMyClientID(serverConnectionHandlerID)
	return ts3.getClientID(serverConnectionHandlerID)
end

--Return all clientIDs in current channel
local function getAllClientsInChannel(serverConnectionHandlerID)
	local currentChannelID = ts3.getChannelOfClient(serverConnectionHandlerID, getMyClientID(serverConnectionHandlerID))
	return ts3.getChannelClientList(serverConnectionHandlerID, currentChannelID)
end

--Test function for checking if the module has being loaded
local function testFunction(serverConnectionHandlerID)
	ts3.printMessageToCurrentTab("Working...")
end

--Specify all functions that you want to be usable in TS here
TSAnnoy = {
	pokeUser = pokeUser,
	pokeAllUsers = pokeAllUsers,
	testFunction = testFunction,
}

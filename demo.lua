-- Basic teamspeak lua script for the teamspeak lua scripting addon
-- By Travis Leeden

require("ts3defs")
require("ts3errors")

-- Call these function from the TeamSpeak 3 client console via: /lua run testmodule.<function>
-- Note the serverConnectionHandlerID of the current server is always passed.

--Function for delaying for seconds
math.randomseed( os.time() )
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

--Return all clientIDs in current channel
local function getAllClientsInChannel(serverConnectionHandlerID)
	local currentChannelID, error = ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID))
	if error == ts3errors.ERROR_not_connected then
		ts3.printMessageToCurrentTab("Not connected")
		return
	elseif error ~= ts3errors.ERROR_ok then
		print("Error getting client list: " .. error)
		return
	end
	return ts3.getChannelClientList(serverConnectionHandlerID, currentChannelID)
end

--Returns the amount of elements in a table
local function getTableSize(T)
	local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function printAllCurrentClients(serverConnectionHandlerID)
  local clients = getAllClientsInChannel(serverConnectionHandlerID)

  for i=1, #clients do
    ts3.printMessageToCurrentTab(clients[i])
    ts3.printMessageToCurrentTab(ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_NICKNAME))
  end
end

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
    sleep(0.5)
		ts3.requestClientPoke(serverConnectionHandlerID, userToBePoked, pokeText)
	end
	ts3.printMessageToCurrentTab("Poking user " .. userToBePoked)
end

local function pokeUserWithID(serverConnectionHandlerID,clientID, pokeText, pokeAmount)
  for i = 1, pokeAmount, 1 do
    sleep(0.5)
    ts3.requestClientPoke(serverConnectionHandlerID, clientID, pokeText)
  end
  ts3.printMessageToCurrentTab("Poking user " .. ts3.getClientVariableAsString(serverConnectionHandlerID, clientID, ts3defs.ClientProperties.CLIENT_NICKNAME))
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

--Kick yourself from the current server
local function kickOwnClientFromServer(serverConnectionHandlerID, index)
	ts3.requestClientKickFromServer(serverConnectionHandlerID,ts3.getClientID(serverConnectionHandlerID), "Good idea")
	ts3.printMessageToCurrentTab("Kicking yourself")
end
--Kick a client from the server based on their ID
local function kickClientFromServer(serverConnectionHandlerID, clientID)
	ts3.requestClientKickFromServer(serverConnectionHandlerID,clientID, "You lose")
	ts3.printMessageToCurrentTab("Kicking user " .. clientID)
end

--Picks a random person in the channel to kick
-- Note it can also kick your own client
local function kickRoulette(serverConnectionHandlerID)
	local clients = getAllClientsInChannel(serverConnectionHandlerID)
	local clientToBeKicked = math.random(1, getTableSize(clients))

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "3", ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)))
	sleep(1)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "2", ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)))
	sleep(1)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "1", ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)))
	sleep(1)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "Kicking Client " .. ts3.getClientVariableAsString(serverConnectionHandlerID, clients[clientToBeKicked], ts3defs.ClientProperties.CLIENT_NICKNAME), ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)))

	kickClientFromServer(serverConnectionHandlerID,clients[clientToBeKicked])
end

--Helper functions

--Test function for checking if the module has being loaded
local function testFunction(serverConnectionHandlerID)
	ts3.printMessageToCurrentTab("Working...")
end

--Specify all functions that you want to be usable in TS here
TSAnnoy = {
  printAllCurrentClients = printAllCurrentClients,
	pokeUser = pokeUser,
  pokeUserWithID = pokeUserWithID,
	pokeAllUsers = pokeAllUsers,
	kickOwnClientFromServer = kickOwnClientFromServer,
	kickRoulette = kickRoulette,
	testFunction = testFunction,
}

--
-- Testmodule initialisation, this script is called via autoload mechanism when the
-- TeamSpeak 3 client starts.
--

require("ts3init")            -- Required for ts3RegisterModule
require("TSAnnoy/Annoy")    -- Some demo functions callable from TS3 client chat input

local MODULE_NAME = "TSAnnoy"

--
-- Initialize menus. Optional function, if not using menus do not implement this.
-- This function is called automatically by the TeamSpeak client.
--
-- Register your callback functions with a unique module name.
ts3RegisterModule(MODULE_NAME, registeredEvents)

local LUCI_SYS = require("luci.sys")

local t = Map("wolplus", translate("Wakeup On LAN +"), translate("Wakeup On LAN + is a mechanism to remotely boot computers in the local network.") .. [[<br/><br/><a href="https://github.com/sundaqiang/o[...]</a>]])
t.template = "wolplus/index"

local e = t:section(TypedSection, "macclient", translate("Host Clients"))
e.template = "cbi/tblsection"
e.anonymous = true
e.addremove = true

-- Add device section
local a = e:option(Value, "name", translate("Name"))
a.optional = false

-- MAC address
local nolimit_mac = e:option(Value, "macaddr", translate("MAC Address"))
nolimit_mac.rmempty = false
LUCI_SYS.net.mac_hints(function(mac, name) nolimit_mac:value(mac, "%s (%s)" % {mac, name}) end)

-- Network interface
local nolimit_eth = e:option(Value, "maceth", translate("Network Interface"))
nolimit_eth.rmempty = false
for _, dev in ipairs(LUCI_SYS.net.devices()) do
	if dev ~= "lo" then
		nolimit_eth:value(dev)
	end
end

-- Wake device
local btn = e:option(Button, "_awake", translate("Wake Up Host"))
btn.inputtitle = translate("Awake")
btn.inputstyle = "apply"
btn.disabled = false
btn.template = "wolplus/awake"

-- Generate UUID
local function gen_uuid(format)
	local uuid = LUCI_SYS.exec("cat /proc/sys/kernel/random/uuid")
	return format == nil and uuid:gsub("-", "") or uuid
end

-- Create function
function e.create(_, uuid)
	uuid = gen_uuid()
	TypedSection.create(e, uuid)
end

return t
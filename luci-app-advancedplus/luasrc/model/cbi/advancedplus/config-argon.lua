local NIXIO_FS = require("nixio.fs")
local LUCI_UCI = require("luci.model.uci").cursor()
local LUCI_SYS = require("luci.sys")
local LUCI_HTTP = require("luci.http")
local LUCI_DISPATCHER = require("luci.dispatcher")

local name = 'Argon'
local m, s, o

local primary, dark_primary, blur, blur_dark, transparency, transparency_dark, mode, online_wallpaper, progressbar_font
if NIXIO_FS.access('/etc/config/argon') then
	primary = LUCI_UCI:get_first('argon', 'global', 'primary')
	dark_primary = LUCI_UCI:get_first('argon', 'global', 'dark_primary')
	blur = LUCI_UCI:get_first('argon', 'global', 'blur')
	blur_dark = LUCI_UCI:get_first('argon', 'global', 'blur_dark')
	transparency = LUCI_UCI:get_first('argon', 'global', 'transparency')
	transparency_dark = LUCI_UCI:get_first('argon', 'global', 'transparency_dark')
	mode = LUCI_UCI:get_first('argon', 'global', 'mode')
	online_wallpaper = LUCI_UCI:get_first('argon', 'global', 'online_wallpaper')
	progressbar_font = LUCI_UCI:get_first('argon', 'global', 'progressbar_font')
end

m = Map("advancedplus")
m.title = name..translate("Theme Config")
m.description = translate("Here you can adjust various settings.")..

s = m:section(TypedSection, "basic")
s.anonymous = true

o = s:option(ListValue, 'online_wallpaper', translate("Wallpaper Source"))
o:value('none', translate("Local Wallpaper"))
o:value('bing', translate("Bing Wallpaper"))
o.default = online_wallpaper
o.rmempty = false

o = s:option(ListValue, 'mode', translate("Theme Mode"))
o:value('normal', translate("Follow System"))
o:value('light', translate("Force Light"))
o:value('dark', translate("Force Dark"))
o.default = mode
o.rmempty = false
o.description = translate("You can choose Theme color mode here")

o = s:option(Value, 'primary', translate("[Light Mode]")..translate("Primary Color"), translate("A HEX Color"))
o.default = primary
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'transparency', translate("[Light Mode]")..translate("Transparency"), translate("0 Transparent - 1 Opaque"))
o.default = transparency
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'blur', translate("[Light Mode]")..translate("Frosted Glass Radius"), translate("0 Clear - 10 Blur"))
o.default = blur
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'dark_primary', translate("[Dark Mode]")..translate("Primary Color"), translate("A HEX Color"))
o.default = dark_primary
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'transparency_dark', translate("[Dark Mode]")..translate("Transparency"), translate("0 Transparent - 1 Opaque"))
o.default = transparency_dark
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'blur_dark', translate("[Dark Mode]")..translate("Frosted Glass Radius"), translate("0 Clear - 10 Blur"))
o.default = blur_dark
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'progressbar_font', translate("Bar Font Color"), translate("A HEX Color"))
o.default = progressbar_font
o.datatype = ufloat
o.rmempty = false

m.apply_on_parse = true
m.on_after_apply = function(self,map)
	LUCI_SYS.exec("/etc/init.d/advancedplus start >/dev/null 2>&1")
	LUCI_HTTP.redirect(LUCI_DISPATCHER.build_url("admin", "system", "advancedplus", "config-argon"))
end

return m
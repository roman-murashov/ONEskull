--[[ 
	ONEskull Vita.
	The lua script compiler for Play Station Vita.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- DevDavisNunez (https://twitter.com/DevDavisNunez).
	
	Version 1.0 at 08:00 pm - 05/09/17
	
]]

__RELEASE = true -- Uncomment in release
__DEBUGIP, __DEBUGPORT = "192.168.1.79", 18194

color.loadpalette()
dofile("lib/debug.lua")
dofile("git/updater.lua")
dofile("utils.lua")
dofile("lib/wave.lua")
dofile("lib/compiler.lua")
dofile("lib/explorer.lua")

-- ## Resources ##
local wave = newWave()
wave:begin("res/wave.png") --wave:alfa(100)
local mimes = image.load("res/icons.png",16,16)
local back = image.load("sce_sys/livearea/contents/bg0.png")

local icons = {
	pbp=2,prx=2,
	png=3,gif=3,jpg=3,bmp=3,
	mp3=4,s3m=4,wav=4,at3=4,
	rar=5,zip=5,vpk=5,
	cso=6,iso=6,dax=6
}
local scroll = newScroll()
local path = "ux0:/"
local list = files.list(path)
scroll:set(list, 20)
buttons.interval(8,8)
while true do
	buttons.read()
	if back then back:blit(0,0) end
	wave:blit(4)
	draw.fillrect(0,0,960,25,color.shine)
	screen.print(5,5,tostring(path),1, color.white)
	screen.print(950,5,"Count: "..#list,1, color.white, 0x0, __ARIGHT)
	y = 35
	for i=scroll.ini, scroll.lim do
		
		if not list[i].directory then
			if icons[list[i].ext] then mimes:blitsprite(5, y, icons[list[i].ext]) -- mime type
			else mimes:blitsprite(5, y, 0) end -- file unk
		else
			mimes:blitsprite(5, y, 1) -- folder xD
		end
		
		local cc = color.white
		if list[i].directory then cc = color.yellow end
		if i==scroll.sel then cc = color.green end
		screen.print(25, y, list[i].name, 1, cc)
		local text = "<DIR>"
		if not list[i].directory then text = tostring(files.sizeformat(list[i].size)) end
		screen.print(950, y, text, 1, cc,0x0, __ARIGHT)
		
		y += 20
	end
	screen.flip()
	
	if buttons.up or buttons.analogly < -60 then
		scroll:up()
	elseif buttons.down or buttons.analogly > 60 then
		scroll:down()
	end
	
	if buttons.circle then
		path = files.nofile(path)
		list = files.list(path)
		scroll:set(list, 20)
	elseif buttons.cross then
		if list[scroll.sel].directory then
			path = list[scroll.sel].path
			list = files.list(path)
			scroll:set(list, 20)
		else
			if list[scroll.sel].ext and list[scroll.sel].ext == 'lua' then -- compile
				local res, msg = files.compile(list[scroll.sel].path);
				if res == 0 then
					os.message("Success in compiling!")
					list = files.list(path)
					scroll:set(list, 20)
				elseif res == -1 then
					os.message("Compiled previously.")
				elseif res == -2 and msg then
					os.message("The script has run-time errors.\n".. msg)
				end
			end
			
		end
	elseif buttons.triangle then
	elseif buttons.left then
	elseif buttons.right then
	elseif buttons.select then
	end
end
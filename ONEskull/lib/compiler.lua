
-- Compile a lua script and generate lue script...
function files.compile(path)
	local newpath = path:gsub('.lua', '.lue')
	local fp, fd, err, str
	-- Script to ram
	fp = io.open(path, "r")
	fd = fp:read("*a")
	fp:close()
	-- Temporal Compiler script
	local fn = files.nopath(os.tmpname())
	fp = io.open(fn, "w+")
	fp:write("function __tmp()\n")
	fp:write(fd.."\n".."end\n")
	fp:write('fp = io.open("'..newpath..'","w+")\n')
	fp:write('fp:write(string.dump(__tmp))\n')
	fp:write('fp:close()\n')
	fp:write('__tmp = nil')
	fp:close()
	-- Lauch Compiler script
	err, str = pcall(dofile, fn)
	-- Delete Compiler script
	files.delete(fn)
	if not err then
		if string.find(str, "unexpected symbol near 'char(27)'",1,true) then return -1 else return -2,str end
	else return 0 end
end
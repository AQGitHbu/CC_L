AI = {

[1000] = function ()
	local m = {}
	m.ok = function()
		return true
	end
	
	m.msg = function()
		CCLuaLog("a()")
	end
 	CCLuaLog("testAI--------")
 	
 	return m
end
,
}
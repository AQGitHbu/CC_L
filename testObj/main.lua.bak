--相互对战
local function main()
	--内存回收
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)
	
	--场景
	local Scene_fight = CCScene:create()
	
	require "testObj/Layers"
	--背景层
	local bgLayer = createBackgroundLayer()
	Scene_fight:addChild(bgLayer)

	--角色层
	local roleLayer = createRoleLayer()
	Scene_fight:addChild(roleLayer)

	CCDirector:sharedDirector():runWithScene(Scene_fight)
end


function __G__TRACKBACK__(msg)
	CCLuaLog("------------------------------------")
	CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
	cclog(debug.traceback())
	CCLuaLog("------------------------------------")
end

xpcall(main, __G__TRACKBACK__)
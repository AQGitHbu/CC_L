--输入场上目标进行攻击运算
math.randomseed(os.time())
require "fight/fight_Skills"	--技能

-----分组，站位
local function grouping(RoleLayer)
	require "testObj/roleConfTbl"	--角色数据
	require "testObj/role"	--角色类
	--
	local roleTbl = {}	--根据数据建立场上所有对象
	
	require "testObj/Position"	--位置坐标
	for i, roleConf in pairs(roleConfTbl) do
		local role = Role:initCreate(roleConf)	
		role:setPosition(fight_Position[i][1], fight_Position[i][2])
		table.insert(roleTbl, role)
		RoleLayer:addChild(role)
	end
	
	--分组
	local Aarr = {}
	local Barr = {}	
	--取出A方
	for i, v in ipairs(roleTbl) do
		if v.Horde == "A" then
		table.insert(Aarr, v)
		end
	end
	--取出B方
	for i, v in ipairs(roleTbl) do
		if v.Horde == "B" then		
		table.insert(Barr, v)
		end
	end
	
	return Aarr, Barr
end


--目标选择(输入指令)
local function FightOrder(AUndeadRoleArr, BUndeadRoleArr, array)
	--取出A方攻击
	for _, roleAtt in ipairs(AUndeadRoleArr) do
		if #BUndeadRoleArr <= 0 then
			break
		end
		
		--随机取出被攻击目标			
		local random_i = math.random(1, #BUndeadRoleArr)
		local roleDef = BUndeadRoleArr[random_i]
		
		--使用技能(攻击动画)
		local attAnimate = roleAtt:action("att")
		local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
		array:addObject(t1)
		
		--随机选择1个技能
		local randi = math.random(1, #roleAtt.Skills)
		randskill = roleAtt.Skills[randi]
		Skills[randskill](roleAtt, roleDef, array)
		
		--被攻击方气血为0则移除
		if roleDef.Hp <= 0 then
			roleDef.dead = true
			--死亡动画
			local deadAnimate = roleDef:action("dead")
			local t1 = CCTargetedAction:create(roleDef.mRoleSprite, deadAnimate)
			array:addObject(t1)
			
			table.remove(BUndeadRoleArr, random_i)
			
		end
	end

	--B方攻击
	for _, roleAtt in ipairs(BUndeadRoleArr) do
		if #AUndeadRoleArr <= 0 then
			break
		end			
		
		--取出被攻击目标
		local random_i = math.random(1, #AUndeadRoleArr)
		local roleDef = AUndeadRoleArr[random_i]
				
		--使用技能
		local attAnimate = roleAtt:action("att")
		local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
		array:addObject(t1)	

		--随机技能
		local randi = math.random(1, #roleAtt.Skills)
		randskill = roleAtt.Skills[randi]
		Skills[randskill](roleAtt, roleDef, array)

		--被攻击方气血为0则移除
		if roleDef.Hp <= 0 then
			roleDef.dead = true
			--死亡动画
			local deadAnimate = roleDef:action("dead")
			local t1 = CCTargetedAction:create(roleDef.mRoleSprite, deadAnimate)
			array:addObject(t1)
			
			table.remove(AUndeadRoleArr, random_i)
			
		end
	end
				
	---------log--------------	
	CCLuaLog("----Tbout:"..tostring(Tbout).."----")
	
	for _, role in pairs(AUndeadRoleArr) do	
		CCLuaLog(tostring(role.name)..":"..tostring(role.Hp))
		
	end
	for _, role in pairs(BUndeadRoleArr) do	
		CCLuaLog(tostring(role.name)..":"..tostring(role.Hp))
		
	end
	CCLuaLog("Aarr.len:"..tostring(#AUndeadRoleArr))
	CCLuaLog("Barr.len:"..tostring(#BUndeadRoleArr))
	---------log--------------	


end

----------
function doFight(RoleLayer)
	--接受分组
	local Aarr, Barr = grouping(RoleLayer)
	
	--做行走动作
	local array = CCArray:create()
	for _, role in pairs(Aarr) do
		local animate = role:action("walk")
		local t1 = CCTargetedAction:create(role.mRoleSprite, animate)
		--array:addObject(t1)
		RoleLayer:runAction(t1)
	end
	--local action = CCSequence:create(array)
	--RoleLayer:runAction(action)	

--[[
---------------	
	local Tbout = 0	--回合数
	local fightStart = true	--战斗标识
	local array = CCArray:create()
	--循环检查战斗
	while fightStart == true do
		--记录A方未死目标
		local AUndeadRoleArr = {}
		local BUndeadRoleArr = {}
		
		for _, role in pairs(Aarr) do		
			if (role.dead == false) then
				table.insert(AUndeadRoleArr, role)				
			end
		end
		
		for _, role in pairs(Barr) do		
			if (role.dead == false) then
				table.insert(BUndeadRoleArr, role)
			end
		end

		--如果AB两方其中一方单位为0则结束战斗
		if (#AUndeadRoleArr > 0) and (#BUndeadRoleArr > 0) then
			--记录回合数
			Tbout = Tbout + 1
			--输入指令
			FightOrder(AUndeadRoleArr, BUndeadRoleArr, array)
		else
			fightStart = false
			
			CCLuaLog("begin actions")
			
			local action = CCSequence:create(array)
			RoleLayer:runAction(action)			
			
		end
	end
			
----------------
]]
end




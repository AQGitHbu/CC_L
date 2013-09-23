--输入场上目标进行攻击运算
math.randomseed(os.time())
require "testObj/Skills"	--技能

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
		role:HeartBeat()
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
	
	return Aarr, Barr, roleTbl
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
	local Aarr, Barr, roleTbl = grouping(RoleLayer)
	
	for _, role in pairs(roleTbl) do
		role:ai(roleTbl)
	end
	
	for _, role in pairs(Barr) do
		role:ai(Aarr)
	end
	
	--[[
	local roleb	
	for _, role in pairs(roleTbl) do
		
		if role.Horde == "B" then
			roleb = role
			CCLuaLog(tostring(roleb))
		end

	end
	
	for _, role in pairs(roleTbl) do
		role:ai(roleb)
	
	end
	]]
	--[[
	local roleb	
	for _, role in pairs(roleTbl) do
		
		if role.Horde == "B" then
			roleb = role
			CCLuaLog(tostring(roleb))
		end

	end

	for _, role in pairs(roleTbl) do
		
		if role.Horde == "A" then
		
			local function ai()
				role:ai(roleb)
			end
			
			CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(ai, 0.02, false)
		end	
	end
	--------
	local rolea	
	for _, role in pairs(roleTbl) do
		
		if role.Horde == "A" then
			rolea = role
			CCLuaLog(tostring(rolea))
		end

	end

	for _, role in pairs(roleTbl) do
		
		if role.Horde == "B" then
		
			local function ai()
				role:ai(rolea)
			end
			
			CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(ai, 0.02, false)
		end	
	end
	
	]]
	
	
--[[
	local countfight = 0
	local endfight = false
	while endfight == false do
	--做行走动作
	--local array = CCArray:create()
	for _, role in pairs(roleTbl) do
		
		--是否在战斗中，如果不是，则移动，是则停止
		if role.onfight == false then
		
			local arr
			if role.Horde == "A" then
				arr = Barr
				
			else
				arr = Aarr
			end
			local tox, toy
			--local tempdx= 999999999999
			--barr 的坐标	
			for _, brole in pairs(arr) do
				local bx, by = brole:getPosition()
				local ax, ay = role:getPosition()
				dx = bx - ax
				dy = by - ay
				
				--CCLuaLog(bx..","..by.."----"..tostring(dx^2 + dy^2).."view"..role.view)
				
				--如果双方距离小于view则onfight=ture，不再移动
				local dxy = math.sqrt(dx^2 + dy^2)
				CCLuaLog(dxy)
				if dxy < role.view then
					tox = ax
					toy = ay
					role.onfight = true
					CCLuaLog("111111")
				else
					--CCLuaLog(role.speed)
					--if (dxy < tempdx) then
						tox = ax + dx / dxy * role.speed
						toy = ay + dy / dxy * role.speed
						tempdx = dxy
						CCLuaLog(dxy)
					--end 
				
				end
			end
			local array = CCArray:create()
			local animate = role:action("walk")
			local move1 = CCMoveTo:create(0 ,ccp(10+1, 10+1))
			local t1 = CCTargetedAction:create(role.mRoleSprite, animate)
			local t2 = CCTargetedAction:create(role, move1) 
			array:addObject(t1)
			array:addObject(t2)
			local action = CCSequence:create(array)
			RoleLayer:runAction(action)	
		else		
			CCLuaLog("stop onfight")
			countfight = countfight + 1
			if countfight >= 4 then
				endfight = true
			end
		end
	end
	--local action = CCSequence:create(array)
	--RoleLayer:runAction(action)	
	end
]]
	
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




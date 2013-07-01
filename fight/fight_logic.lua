--输入场上目标进行攻击运算
math.randomseed(os.time())

-----分组，站位
local function grouping(RoleLayer)
	require "fight/roleConfTbl"	--角色数据
	require "fight/fight_role"	--角色类
	--
	local roleTbl = {}	--根据数据建立场上所有对象
	
	require "fight/fight_Position"	--位置坐标
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

------攻击和动画
local function fightAB(roleAtt, roleDef, array)

	--攻击动作
	local attAnimate = roleAtt:action("att")
	local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
	array:addObject(t1)
	
	--一定几率不中--
	require "fight/otherAction"
	local probability = math.random(1, 100)
	if probability > 50 then		
		local function missBegin()
			effectFactory(roleDef, "miss")		
		end
		local function missEnd()
			--roleDef.meffectSprite:setVisible(false)
			roleDef.meffectSprite:setTexture(nil)		
		end
		array:addObject(CCCallFuncN:create(missBegin))
		array:addObject(CCDelayTime:create(1))
		array:addObject(CCCallFuncN:create(missEnd))
		
		
	else	
		--原始气血
		local oldHP = roleDef.Hp
		
	----数值逻辑------
		--有50%几率暴击
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--火特效
			local function clearEffect()
				--roleDef.meffectSprite:setVisible(false)
				roleDef.meffectSprite:setTexture(nil)		
			end
			local to_effect_fire = effectFactory(roleDef, "fire", array)
			CCLuaLog(tostring(tofire))
			array:addObject(to_effect_fire)
			array:addObject(CCCallFuncN:create(clearEffect))
		else
			roleDef.Hp = roleDef.Hp - roleAtt.Att
		end
		
	----动画表现------
		--防守方受击
		local hitAnimate = roleDef:hit()
		--更新气血
		local updateHp = roleDef:updateHp(oldHP)
			
		local to_hit = CCTargetedAction:create(roleDef.mRoleSprite, hitAnimate)
		local to_updateHp = CCTargetedAction:create(roleDef.mHpSprite, updateHp)
		
		
		array:addObject(to_hit)
		array:addObject(to_updateHp)
	end	
end

----------
function doFight(RoleLayer)
	--接受分组
	local Aarr, Barr = grouping(RoleLayer)

---------------	
	local Tbout = 0	--回合数
	local fightStart = true	--战斗标识
	local array = CCArray:create()
	--循环检查战斗
	while fightStart == true do

		--如果AB两方其中一方单位为0则结束战斗
		if (#Aarr > 0) and (#Barr > 0) then
			--记录回合数
			Tbout = Tbout + 1
			
			--取出A方攻击
			for _, v in ipairs(Aarr) do
				--随机取出被攻击目标			
				local random_i = math.random(1, #Barr)
				
				fightAB(v, Barr[random_i], array)
				v.bout = Tbout
				--被攻击方气血为0则移除
				if Barr[random_i].Hp <= 0 then
					--死亡动画
					local deadAnimate = Barr[random_i]:action("dead")
					local t1 = CCTargetedAction:create(Barr[random_i].mRoleSprite, deadAnimate)
					array:addObject(t1)
					
					table.remove(Barr, random_i)
					--CCLuaLog("removeB")
				end
			end
	
			--B方攻击
			for _, v in ipairs(Barr) do
				--取出被攻击目标
				local random_i = math.random(1, #Aarr)
				
				fightAB(v, Aarr[random_i], array)
				v.bout = Tbout
				--被攻击方气血为0则移除
				if Aarr[random_i].Hp <= 0 then
					CCLuaLog("removeA")
					--死亡动画
					local deadAnimate = Aarr[random_i]:action("dead")
					local t1 = CCTargetedAction:create(Aarr[random_i].mRoleSprite, deadAnimate)
					array:addObject(t1)
					
					table.remove(Aarr, random_i)
					
				end
			end
						
			---------log--------------	
			CCLuaLog("----Tbout:"..tostring(Tbout).."----")
			
			for _, role in pairs(Aarr) do	
				CCLuaLog(tostring(role.name)..":"..tostring(role.Hp))
				
			end
			for _, role in pairs(Barr) do	
				CCLuaLog(tostring(role.name)..":"..tostring(role.Hp))
				
			end
			CCLuaLog("Aarr.len:"..tostring(#Aarr))
			CCLuaLog("Barr.len:"..tostring(#Barr))
			---------log--------------	
		else
			fightStart = false
			
			CCLuaLog("begin actions")
			
			local action = CCSequence:create(array)
			RoleLayer:runAction(action)			
			
		end
	end
			
----------------

end




--���볡��Ŀ����й�������
math.randomseed(os.time())

-----���飬վλ
local function grouping(RoleLayer)
	require "fight/roleConfTbl"	--��ɫ����
	require "fight/fight_role"	--��ɫ��
	--
	local roleTbl = {}	--�������ݽ����������ж���
	
	require "fight/fight_Position"	--λ������
	for i, roleConf in pairs(roleConfTbl) do
		local role = Role:initCreate(roleConf)	
		role:setPosition(fight_Position[i][1], fight_Position[i][2])
		table.insert(roleTbl, role)
		RoleLayer:addChild(role)
	end
	
	--����
	local Aarr = {}
	local Barr = {}	
	--ȡ��A��
	for i, v in ipairs(roleTbl) do
		if v.Horde == "A" then
		table.insert(Aarr, v)
		end
	end
	--ȡ��B��
	for i, v in ipairs(roleTbl) do
		if v.Horde == "B" then		
		table.insert(Barr, v)
		end
	end
	
	return Aarr, Barr
end

------�����Ͷ���
local function fightAB(roleAtt, roleDef, array)

	--��������
	local attAnimate = roleAtt:action("att")
	local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
	array:addObject(t1)
	
	--һ�����ʲ���--
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
		--ԭʼ��Ѫ
		local oldHP = roleDef.Hp
		
	----��ֵ�߼�------
		--��50%���ʱ���
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--����Ч
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
		
	----��������------
		--���ط��ܻ�
		local hitAnimate = roleDef:hit()
		--������Ѫ
		local updateHp = roleDef:updateHp(oldHP)
			
		local to_hit = CCTargetedAction:create(roleDef.mRoleSprite, hitAnimate)
		local to_updateHp = CCTargetedAction:create(roleDef.mHpSprite, updateHp)
		
		
		array:addObject(to_hit)
		array:addObject(to_updateHp)
	end	
end

----------
function doFight(RoleLayer)
	--���ܷ���
	local Aarr, Barr = grouping(RoleLayer)

---------------	
	local Tbout = 0	--�غ���
	local fightStart = true	--ս����ʶ
	local array = CCArray:create()
	--ѭ�����ս��
	while fightStart == true do

		--���AB��������һ����λΪ0�����ս��
		if (#Aarr > 0) and (#Barr > 0) then
			--��¼�غ���
			Tbout = Tbout + 1
			
			--ȡ��A������
			for _, v in ipairs(Aarr) do
				--���ȡ��������Ŀ��			
				local random_i = math.random(1, #Barr)
				
				fightAB(v, Barr[random_i], array)
				v.bout = Tbout
				--����������ѪΪ0���Ƴ�
				if Barr[random_i].Hp <= 0 then
					--��������
					local deadAnimate = Barr[random_i]:action("dead")
					local t1 = CCTargetedAction:create(Barr[random_i].mRoleSprite, deadAnimate)
					array:addObject(t1)
					
					table.remove(Barr, random_i)
					--CCLuaLog("removeB")
				end
			end
	
			--B������
			for _, v in ipairs(Barr) do
				--ȡ��������Ŀ��
				local random_i = math.random(1, #Aarr)
				
				fightAB(v, Aarr[random_i], array)
				v.bout = Tbout
				--����������ѪΪ0���Ƴ�
				if Aarr[random_i].Hp <= 0 then
					CCLuaLog("removeA")
					--��������
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




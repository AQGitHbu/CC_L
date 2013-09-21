--���볡��Ŀ����й�������
math.randomseed(os.time())
require "fight/fight_Skills"	--����

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


--Ŀ��ѡ��(����ָ��)
local function FightOrder(AUndeadRoleArr, BUndeadRoleArr, array)
	--ȡ��A������
	for _, roleAtt in ipairs(AUndeadRoleArr) do
		if #BUndeadRoleArr <= 0 then
			break
		end
		
		--���ȡ��������Ŀ��			
		local random_i = math.random(1, #BUndeadRoleArr)
		local roleDef = BUndeadRoleArr[random_i]
		
		--ʹ�ü���(��������)
		local attAnimate = roleAtt:action("att")
		local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
		array:addObject(t1)
		
		--���ѡ��1������
		local randi = math.random(1, #roleAtt.Skills)
		randskill = roleAtt.Skills[randi]
		Skills[randskill](roleAtt, roleDef, array)
		
		--����������ѪΪ0���Ƴ�
		if roleDef.Hp <= 0 then
			roleDef.dead = true
			--��������
			local deadAnimate = roleDef:action("dead")
			local t1 = CCTargetedAction:create(roleDef.mRoleSprite, deadAnimate)
			array:addObject(t1)
			
			table.remove(BUndeadRoleArr, random_i)
			
		end
	end

	--B������
	for _, roleAtt in ipairs(BUndeadRoleArr) do
		if #AUndeadRoleArr <= 0 then
			break
		end			
		
		--ȡ��������Ŀ��
		local random_i = math.random(1, #AUndeadRoleArr)
		local roleDef = AUndeadRoleArr[random_i]
				
		--ʹ�ü���
		local attAnimate = roleAtt:action("att")
		local t1 = CCTargetedAction:create(roleAtt.mRoleSprite, attAnimate)
		array:addObject(t1)	

		--�������
		local randi = math.random(1, #roleAtt.Skills)
		randskill = roleAtt.Skills[randi]
		Skills[randskill](roleAtt, roleDef, array)

		--����������ѪΪ0���Ƴ�
		if roleDef.Hp <= 0 then
			roleDef.dead = true
			--��������
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
	--���ܷ���
	local Aarr, Barr = grouping(RoleLayer)

---------------	
	local Tbout = 0	--�غ���
	local fightStart = true	--ս����ʶ
	local array = CCArray:create()
	--ѭ�����ս��
	while fightStart == true do
		--��¼A��δ��Ŀ��
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

		--���AB��������һ����λΪ0�����ս��
		if (#AUndeadRoleArr > 0) and (#BUndeadRoleArr > 0) then
			--��¼�غ���
			Tbout = Tbout + 1
			--����ָ��
			FightOrder(AUndeadRoleArr, BUndeadRoleArr, array)
		else
			fightStart = false
			
			CCLuaLog("begin actions")
			
			local action = CCSequence:create(array)
			RoleLayer:runAction(action)			
			
		end
	end
			
----------------

end



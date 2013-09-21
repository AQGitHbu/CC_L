------����
Skills = {

[100] = function(roleAtt, roleDef, array)	
	
	require "fight/otherAction"	--���ֶ���
	
	--һ�����ʲ���--
	local probability = math.random(1, 100)
	if probability > 90 then		
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
		
		--��50%���ʱ���
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--����Ч
			local function clearEffect()
				--roleDef.meffectSprite:setVisible(false)
				roleDef.meffectSprite:setTexture(nil)		
			end
			local to_effect_fire = effectFactory(roleDef, "fire")
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
,

[101] = function(roleAtt, roleDef, array)	
	
	require "fight/otherAction"	--���ֶ���
	
	--һ�����ʲ���--
	local probability = math.random(1, 100)
	if probability > 90 then		
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
		
		--��50%���ʱ���
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--����Ч
			local function clearEffect()
				--roleDef.meffectSprite:setVisible(false)
				roleDef.meffectSprite:setTexture(nil)		
			end
			local to_effect_fire = effectFactory(roleDef, "water")
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

}
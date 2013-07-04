------技能
Skills = {

[100] = function(roleAtt, roleDef, array)	
	
	require "fight/otherAction"	--表现动画
	
	--一定几率不中--
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
		--原始气血
		local oldHP = roleDef.Hp
		
		--有50%几率暴击
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--火特效
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
,

[101] = function(roleAtt, roleDef, array)	
	
	require "fight/otherAction"	--表现动画
	
	--一定几率不中--
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
		--原始气血
		local oldHP = roleDef.Hp
		
		--有50%几率暴击
		local probability = math.random(1, 100)
		if probability > 50 then
			roleDef.Hp = roleDef.Hp - roleAtt.Att * 2
			--火特效
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

}
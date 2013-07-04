--场景动画

function effectFactory(role, effectString)
	--特效sprite设置可见
	--role.meffectSprite:setVisible(true)
	if effectString == "miss" then
		local rect = CCRectMake(0, 0, 64, 64)
		local texture = CCTextureCache:sharedTextureCache():addImage("image/miss.png")
		role.meffectSprite:setTexture(texture)
		local rect = CCRectMake(0, 0, 64, 64)
		role.meffectSprite:setTextureRect(rect)
		
	end
	
	if effectString == "fire" then
		require "animationHelper"
		local framesList = CCArray:create()
		local texture = CCTextureCache:sharedTextureCache():addImage("image/skilleffect/fire.png")
		framesList = CutTextureToFrames_CCArray(texture, 10, 1)
		local animation = CCAnimation:createWithSpriteFrames(framesList, 0.15)
		local fireAnimate = CCAnimate:create(animation)
		local to = CCTargetedAction:create(role.meffectSprite, fireAnimate)
		
		return to
	end
	
	if effectString == "water" then
		require "animationHelper"
		local framesList = CCArray:create()
		local texture = CCTextureCache:sharedTextureCache():addImage("image/skilleffect/water.png")
		framesList = CutTextureToFrames_CCArray(texture, 12, 1)
		local animation = CCAnimation:createWithSpriteFrames(framesList, 0.15)
		local fireAnimate = CCAnimate:create(animation)
		local to = CCTargetedAction:create(role.meffectSprite, fireAnimate)
		
		return to
	end

end
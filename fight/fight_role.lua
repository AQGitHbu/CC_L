--实例对象，所有角色的基类
require "extern"

Role = class("Role", 
	function()
		return CCNode:create()
	end
)
Role.__index = Role


--建立一个实例
function Role:initCreate(RoleObjData)
	local mRole = Role.new()
	
	mRole:setObjData(RoleObjData)
	
	local msprite, mHpSprite, meffectSprite, mRoleSprite = mRole:SpriteCreate()	
	mRole.msprite = msprite
	mRole.mHpSprite = mHpSprite
	mRole.meffectSprite = meffectSprite
	mRole.mRoleSprite = mRoleSprite
	
	mRole:addChild(msprite)
	
	return mRole
end

--属性设置
function Role:setObjData(RoleObjData)
	--要赋值的属性
	local varTbl = {
		"name",
		"RoleImgSrc_walk",
		"RoleImgSrc_att",
		"RoleImgSrc_dead",
		"Hp",
		"HpMax",
		"Att",
		"Horde",
	}
	
	--建立角色数据
	for _, v in pairs(varTbl) do
		self[v] = RoleObjData[v]
		--self.v = RoleObjData.v
	end
	
	self.bout = 0	--攻击回合数
end


--将hp条和角色造型条拼成1个大的sprite
function Role:SpriteCreate()
	local msprite = CCSprite:create()

	local HpMaxSprite = CCSprite:create("image/HpMaxImg.png")	--最大值血条
	local HpSprite = CCProgressTimer:create(CCSprite:create("image/HpImg.png"))	--当前气血
	local effectSprite = CCSprite:create()	--特效
	
	local rect
	if self.Horde == "A" then
		rect = CCRectMake(0, 128, 48, 64)
	else
		rect = CCRectMake(0, 64, 48, 64)
	end
	local RoleSprite = CCSprite:create(self.RoleImgSrc_walk, rect)	--角色
	HpMaxSprite:setPosition(0, 32)
	HpSprite:setPosition(0, 32)
	effectSprite:setPosition(0, 0)
	RoleSprite:setPosition(0, 0)
	
	--特效sprite不可见
	--effectSprite:setVisible(false)
		
	--进度条类型
	HpSprite:setType(kCCProgressTimerTypeBar)	
	HpSprite:setMidpoint(ccp(0, 0))
	HpSprite:setBarChangeRate(ccp(1, 0))
	
	HpSprite:setPercentage(100)
	
	msprite:addChild(HpMaxSprite)
	msprite:addChild(HpSprite)
	msprite:addChild(RoleSprite)
	msprite:addChild(effectSprite)

	--self:addChild(msprite)
	return msprite, HpSprite, effectSprite, RoleSprite
end

--更新血条
function Role:updateHp(oldHP)
	local to = CCProgressFromTo:create(1, oldHP*100/self.HpMax, self.Hp*100/self.HpMax)
	return to
end

--攻击动作
function Role:action(actionString)

	--动画列表
	local framesList = CCArray:create()
	
	require "animationHelper"
	
	--根据输入名称选择图片
	if actionString == "walk" then
		RoleImgSrc = self.RoleImgSrc_walk
	elseif actionString == "att" then
		RoleImgSrc = self.RoleImgSrc_att
	elseif actionString == "dead" then
		RoleImgSrc = self.RoleImgSrc_dead
	end
	
	local texture_Hero = CCTextureCache:sharedTextureCache():addImage(RoleImgSrc)
	framesList = CutTextureToFrames_CCArray(texture_Hero, 4, 4)
	
	--根据阵营选择动画
	local frames_player = CCArray:create()
	if self.Horde == "A" then
		frames_player = ChooseInFrames_CCArray(framesList, 8, 11)
	else
		frames_player = ChooseInFrames_CCArray(framesList, 4, 7)
	end
	
	--动画
	local animation = CCAnimation:createWithSpriteFrames(frames_player, 0.15)
	--animation:setLoops(-1)
	local attAnimate = CCAnimate:create(animation)

	return attAnimate
	
end

--受击
function Role:hit()

	local frames_player = CCArray:create()
	--dead第一帧
	local texture = CCTextureCache:sharedTextureCache():addImage(self.RoleImgSrc_dead)
	local rect = CCRectMake(0, 0, 48, 48)
	
	local frame = CCSpriteFrame:createWithTexture(texture, rect)
	frames_player:addObject(frame)
	
	--walk第一帧
	local texture = CCTextureCache:sharedTextureCache():addImage(self.RoleImgSrc_walk)
	if self.Horde == "A" then
		rect = CCRectMake(0, 128, 48, 64)
	else
		rect = CCRectMake(0, 64, 48, 64)
	end
	
	frame = CCSpriteFrame:createWithTexture(texture, rect)
	frames_player:addObject(frame)
	
	--动画
	local animation = CCAnimation:createWithSpriteFrames(frames_player, 0.15)
	--animation:setLoops(-1)
	local attAnimate = CCAnimate:create(animation)

	return attAnimate
	
end


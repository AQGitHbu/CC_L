--ʵ���������н�ɫ�Ļ���
require "extern"

Role = class("Role", 
	function()
		return CCNode:create()
	end
)
Role.__index = Role


--����һ��ʵ��
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

--��������
function Role:setObjData(RoleObjData)
	--Ҫ��ֵ������
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
	
	--������ɫ����
	for _, v in pairs(varTbl) do
		self[v] = RoleObjData[v]
		--self.v = RoleObjData.v
	end
	
	self.bout = 0	--�����غ���
end


--��hp���ͽ�ɫ������ƴ��1�����sprite
function Role:SpriteCreate()
	local msprite = CCSprite:create()

	local HpMaxSprite = CCSprite:create("image/HpMaxImg.png")	--���ֵѪ��
	local HpSprite = CCProgressTimer:create(CCSprite:create("image/HpImg.png"))	--��ǰ��Ѫ
	local effectSprite = CCSprite:create()	--��Ч
	
	local rect
	if self.Horde == "A" then
		rect = CCRectMake(0, 128, 48, 64)
	else
		rect = CCRectMake(0, 64, 48, 64)
	end
	local RoleSprite = CCSprite:create(self.RoleImgSrc_walk, rect)	--��ɫ
	HpMaxSprite:setPosition(0, 32)
	HpSprite:setPosition(0, 32)
	effectSprite:setPosition(0, 0)
	RoleSprite:setPosition(0, 0)
	
	--��Чsprite���ɼ�
	--effectSprite:setVisible(false)
		
	--����������
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

--����Ѫ��
function Role:updateHp(oldHP)
	local to = CCProgressFromTo:create(1, oldHP*100/self.HpMax, self.Hp*100/self.HpMax)
	return to
end

--��������
function Role:action(actionString)

	--�����б�
	local framesList = CCArray:create()
	
	require "animationHelper"
	
	--������������ѡ��ͼƬ
	if actionString == "walk" then
		RoleImgSrc = self.RoleImgSrc_walk
	elseif actionString == "att" then
		RoleImgSrc = self.RoleImgSrc_att
	elseif actionString == "dead" then
		RoleImgSrc = self.RoleImgSrc_dead
	end
	
	local texture_Hero = CCTextureCache:sharedTextureCache():addImage(RoleImgSrc)
	framesList = CutTextureToFrames_CCArray(texture_Hero, 4, 4)
	
	--������Ӫѡ�񶯻�
	local frames_player = CCArray:create()
	if self.Horde == "A" then
		frames_player = ChooseInFrames_CCArray(framesList, 8, 11)
	else
		frames_player = ChooseInFrames_CCArray(framesList, 4, 7)
	end
	
	--����
	local animation = CCAnimation:createWithSpriteFrames(frames_player, 0.15)
	--animation:setLoops(-1)
	local attAnimate = CCAnimate:create(animation)

	return attAnimate
	
end

--�ܻ�
function Role:hit()

	local frames_player = CCArray:create()
	--dead��һ֡
	local texture = CCTextureCache:sharedTextureCache():addImage(self.RoleImgSrc_dead)
	local rect = CCRectMake(0, 0, 48, 48)
	
	local frame = CCSpriteFrame:createWithTexture(texture, rect)
	frames_player:addObject(frame)
	
	--walk��һ֡
	local texture = CCTextureCache:sharedTextureCache():addImage(self.RoleImgSrc_walk)
	if self.Horde == "A" then
		rect = CCRectMake(0, 128, 48, 64)
	else
		rect = CCRectMake(0, 64, 48, 64)
	end
	
	frame = CCSpriteFrame:createWithTexture(texture, rect)
	frames_player:addObject(frame)
	
	--����
	local animation = CCAnimation:createWithSpriteFrames(frames_player, 0.15)
	--animation:setLoops(-1)
	local attAnimate = CCAnimate:create(animation)

	return attAnimate
	
end


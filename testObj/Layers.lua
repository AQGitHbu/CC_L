--������+��ɫ��
local visibleSize = CCDirector:sharedDirector():getVisibleSize()

--������
function createBackgroundLayer()
	local BackgroundLayer = CCLayer:create()
	----����ͼƬ----
	local bgImg = CCSprite:create("image/farm.jpg")
	
	--ͼƬλ��
	bgImg:setPosition(visibleSize.width / 2, visibleSize.height /2)
	
	----���뱳��ͼ
	BackgroundLayer:addChild(bgImg)
	
	return BackgroundLayer
end

--��ɫ��
function createRoleLayer()
	local RoleLayer = CCLayer:create()
	
	require "testObj/logic"
	doFight(RoleLayer)

----------------	
	return RoleLayer
end
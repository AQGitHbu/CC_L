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
		"Skills",
		"view",
		"AIList"
	}
	
	--建立角色数据
	for _, v in pairs(varTbl) do
		self[v] = RoleObjData[v]
		--self.v = RoleObjData.v
	end
	
	self.bout = 0	--攻击回合数
	self.dead = false	--是否死亡
	self.onfight = false --是否在战斗中
	self.speed = 5 --角色速度
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

--移动
function Role:move(bx, by)

local function move()
	local ax, ay = self:getPosition()
	CCLuaLog(ax..","..ay .."," .. bx .."," .. by)
	
	dx = bx - ax
	dy = by - ay
	
	--如果双方距离小于view则onfight=ture，不再移动
	local dxy = math.sqrt(dx^2 + dy^2)
	CCLuaLog(dxy .. "," .. self.view)
	if dxy < self.view then
		--role.onfight = true
		--CCLuaLog("111111")
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.MoveTimer)
		
				
	else
		--CCLuaLog(role.speed)
		
			ax = ax + dx / dxy * self.speed
			ay = ay + dy / dxy * self.speed
			CCLuaLog(dxy)
	
	end
	
	self:setPosition(ax, ay)

end
	self.MoveTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(move, 0.02, false)
end

--[[
function doAI(Id, roleTbl)
 local t = {}
 local Module = setenv(loadfile("file" .. Id ), t)()
 if Module.OK()  then
 	local Target = Module.Target(roleTbl)
 	Module.Action(Target)
 	return true
 end 
end
]]

function Role:ai(roleTbl)
	
	function ai()
	local ax, ay = self:getPosition()
	CCLuaLog(ax..","..ay)
	
	local mMinDistance 
	local Target 
	for _, torole in pairs(roleTbl) do
		if torole.Horde ~= self.Horde then
			local bx, by = torole:getPosition()
			CCLuaLog(bx..","..by)
		
			dx = bx - ax
			dy = by - ay
		
		--如果双方距离小于view则onfight=ture，不再移动
			local dxy = math.sqrt(dx^2 + dy^2)
			if ((not mMinDistance) or  (mMinDistance >= dxy)) then
				Target = torole
				mMinDistance = dxy
			end
		end
	end
	if Target then
		--如果在行走中，先停止
		if self.MoveTimer then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.MoveTimer)
		end
		local x, y = Target:getPosition()
		self:move(x, y)
		
	end
	end
	
	self.AITimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(ai, 0.3, false)
	
end


function Role:ai(roleTbl)

	for _, Id in pairs(self.AIList) do
		doAI(Id, roleTbl)
	end
	
	
end

--[[上面统一赋值
function Role:AddAIList(List)
	self.AILIst = List
end
]]


function Role:HeartBeat(roleTbl)
	function  HB()
		
			self:ai(roleTbl)
		
	end
	
	 self.HBTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(HB, 0.02, false)
end

--动画制作
--row 排
--col 列
function CutTextureToFrames_CCArray(texture, row, col)
	--每帧的长度和宽度
	local frame_width = texture:getContentSize().width / col
	local frame_height = texture:getContentSize().height / row
	
	local frames = CCArray:create()	--帧组
	--切割图片
	for i = 0, row - 1 do
		for j = 0 , col -1 do
			local rect = CCRectMake(frame_width*j, frame_height*i, frame_width, frame_height)
			local frame = CCSpriteFrame:createWithTexture(texture, rect)			
			frames:addObject(frame)
		end
	end
	return frames
end

function ChooseInFrames_CCArray(frames_ccarray, beginFrame_int, endFrame_int)
	local frames_choose_ccarray = CCArray:create()
	
	for i = beginFrame_int, endFrame_int do
		frames_choose_ccarray:addObject(frames_ccarray:objectAtIndex(i))
	end
	
	return frames_choose_ccarray
end


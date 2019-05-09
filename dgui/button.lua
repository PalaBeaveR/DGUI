local PANE = {}

function PANE:Init()
	self.pos = {}
	self.pos.x = 0
	self.pos.y = 0
	self.size = {}
	self.size.w = 400
	self.size.h = 400
	self.range = 200
	self.text = "LOL"
	self.pressed = false
	self.font = "DermaDefault"
end

function PANE:SetPos(x, y)
	self.pos.x, self.pos.y = x, y
end

function PANE:SetSize(w, h)
	self.size.w, self.size.h = w, h
end

function PANE:SetRange(range)
	self.range = range
end

function PANE:Draw()
	local x, y = DGUI.GetCursorPos()

	DGUI.offsetDraw(self.pos.x, self.pos.y)

	if x and y and !self:IsOutOfReach() then
		if x >= self.pos.x and x <= self.pos.x + self.size.w and y >= self.pos.y and y <= self.pos.y + self.size.h then
			if input.IsKeyDown(_G["KEY_"..input.LookupBinding("+use"):upper()]) then
				if !self.pressed then
					self:OnClick()
					self.pressed = true
				else
					self:OnHold()
				end
			else
				self.pressed = false
				self:OnHover() 
			end
		else
			self:OnIdle()
		end
	else
		self:OnOutOfReach()
	end

	if !self:IsOutOfReach() then
		draw.SimpleText(self.text, self.font, self.size.w / 2, self.size.h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("OUT OF REACH", self.font, self.size.w / 2, self.size.h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	DGUI.offsetDraw(0, 0)

end

function PANE:IsOutOfReach()
	return DGUI.GetCursorVector() and LocalPlayer():EyePos():Distance(DGUI.GetVector(self.pos.x + self.size.w / 2, self.pos.y + self.size.h / 2)) > self.range
end

function PANE:SetFont(font)
	self.font = font
end

function PANE:SetText(txt)
	self.text = txt
end

function PANE:OnIdle()
	surface.SetDrawColor(255, 0, 0)
	self:DrawBG()
end

function PANE:OnOutOfReach()
	surface.SetDrawColor(130, 130, 130)
	self:DrawBG()
end

function PANE:OnHover()
	surface.SetDrawColor(0, 255, 0)
	self:DrawBG()
end

function PANE:OnClick()
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "The button was pressed")
end

function PANE:OnHold()
	surface.SetDrawColor(0, 100, 0)
	self:DrawBG()
end

function PANE:DrawBG()
	surface.DrawRect(0, 0, self.size.w, self.size.h)
end

print("------lol------")

DGUI.Register("Button", PANE)
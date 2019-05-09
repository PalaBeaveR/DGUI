local function addCSDir(path)
	for k, v in pairs(file.Find(path.. "/*.lua", "LUA")) do
		AddCSLuaFile(path.. "/".. v)
		print("[DGUI]".. v.. " loaded!")
	end
end

local function includeDir(path)
	for k, v in pairs(file.Find(path.. "/*.lua", "LUA")) do
		include(path.. "/".. v)
		print("[DGUI]".. v.. " inluded!")
	end
end

if SERVER then
	addCSDir("dgui")
	return
end

local table = table
local print = print
local include = include
local cam = cam
local LocalPlayer = LocalPlayer
local WorldToLocal = WorldToLocal
local util = util
local Angle = Angle
local Vector = Vector
local surface = surface
local oldsurface = table.Copy(surface)
local PanelFactory = {}
local position = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)


module("DGUI")

function Create(name)
	local pnl = table.Copy(PanelFactory[name])
	pnl:Init()
	return pnl
end

function Register(name, tbl)
	PanelFactory[name] = tbl
end

function Start3D2D(pos, ang)
	position = pos
	angle = ang

	cam.Start3D2D(pos, ang, 0.1)
end

function End3D2D()
	cam.End3D2D()
end

function GetCursorPos()
	local origin = LocalPlayer():EyePos()
	local dir = LocalPlayer():GetAimVector()
	local intersectVector = util.IntersectRayWithPlane(origin, dir, position, angle:Up())
	local pos

	if intersectVector then
		pos = WorldToLocal(intersectVector, Angle(0,0,0), position, angle)
		pos = pos * Vector(10, 10, 10)
		return pos.x, -pos.y
	end
end

function GetCursorVector()
	local origin = LocalPlayer():EyePos()
	local dir = LocalPlayer():GetAimVector()
	local intersectVector = util.IntersectRayWithPlane(origin, dir, position, angle:Up())
	local pos

	if intersectVector then
		return position + intersectVector
	end
end

function GetVector(x, y)
	local vector = Vector(x / 10, -y / 10, 0)
	vector:Rotate(angle)
	return position + vector
end

function offsetDraw(offsetX, offsetY)
	surface.DrawRect = function(x, y, w, h)
		oldsurface.DrawRect(x + offsetX, y + offsetY, w, h)
	end

	surface.DrawCircle = function(originX, originY, radius, r, g, b, a)
		a = a or 255
		oldsurface.DrawCircle(originX + offsetX, originY + offsetY, radius, r, g, b, a)
	end

	surface.SetTextPos = function(x, y)
		oldsurface.SetTextPos(x + offsetX, y + offsetY)
	end

	surface.DrawLine = function(startX, startY, endX, endY)
		oldsurface.DrawLine(startX + offsetX, startY + offsetY, endX + offsetX, endY + offsetY)
	end
end

includeDir("dgui")

# DGUI (Abandoned)
A simple work in progress lib to make 3D2D gui elements(Currently only buttons).


## Usage

To create a simple button you need to make something like this:

    local button = DGUI.Create("Button")
    button:SetPos(100, 200)
    button:SetSize(200, 100)
    button:SetText("Oh fuck, here we go again")
    button.OnHold = function(self)
      surface.SetDrawColor(130, 220, 50)
      self:DrawBG()
      draw.RoundedBox(5, 10, 10, 50, 50, Color(200, 45, 145))
    end

    hook.Add("PostDrawOpaqueRenderables", "lulz", function()
      DGUI.Start3D2D(Vector(0, 0, 0), Angle(0, 0, 0))
        button:Draw()
      DGUI.End3D2D()
    end)
    
Which should look like this:

![Idle](/images/idle.jpg)
![Hold](/images/hold.jpg)

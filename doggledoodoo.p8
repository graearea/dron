pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--internal
local doggle
local butcher
local cnt=0

dogisdead=false

function _update()
 if(not dogisdead) then
  cnt+=1
  doggle:move()
  if (cnt%2==0) then
   butcher:move()
  end
 end
 
end

function _draw()
  rectfill(0,0,127,127,3)
  doggleframe=(doggle.walk%3)%2
  butcherframe=(butcher.walk%3%2)+5
  sspr(doggleframe*8,0,8,8,
   doggle.x,doggle.y,
   8,8,doggle.goingleft)
  sspr(butcherframe*8,0,8,8,
   butcher.x,butcher.y,
   8,8,butcher.goingleft)
  if(dogisdead) then
   printstatus("the doggle is dead")  end
end

function _init()
 doggle=doggle()
 butcher=butcher(doggle,0,64)
end

function printstatus(text)
 print(text,0,120,7)
end
-->8
--doggle
function doggle()
 return {
 goingleft=false,
 walk=0,
	x = 64,  
	y = 64,
 move = function(self)

  if (btn(0)) then 
	  self.x=self.x-1
	  self.goingleft=true 
	  self.walk+=1
  end

  if (btn(1)) then 
	  self.x=self.x+1 
	  self.goingleft=false
	  self.walk+=1
  end

  if (btn(2)) then 
	  self.y=self.y-1 
	  self.walk+=1
  end

  if (btn(3)) then 
		 self.y=self.y+1 
  	self.walk+=1
  end  

 end
 }
end
-->8
--butcher
function butcher(doggle,sx,sy)
 return {
  goingleft=false,
  walk=0,
	 x = sx,  
	 y = sy,
	 
	 checkcollision=function(self,doggle)
	  if(doggle.y==self.y and doggle.x==self.x) then
	   dogisdead=true	   
	  end
	 end,
	 
	 move=function(self)
	  if(doggle.x<self.x) then
	   self.x=self.x-1
	   self.goingleft=true
	   self.walk+=1
	  elseif(doggle.x>self.x) then
	   self.x=self.x+1
	   self.goingleft=false
	   self.walk+=1
	  end
	  if(doggle.y<self.y) then
	   self.y=self.y-1
	   self.walk+=1
	  elseif(doggle.y>self.y) then
	   self.y=self.y+1
	   self.walk+=1
	  end
	  self:checkcollision(doggle)
	 end
 }
end
__gfx__
00000f0000000f0000000f0f00040000000400000770000007700000000099000770000000000000000000000000000000000000000000000000000000000000
00000ff000000ff0000008f000fff00000fff0007777000077770000000944007777000000000000000000000000000000000000000000000000000000000000
f0000ff4f0000ff4f0ffffff000f0000000f0000f0f06800f0f0000000044000f0f0000000000000000000000000000000000000000000000000000000000000
0fffff000fffff000ffffff800ff0000000ff0000fff68000fff0000000440000fff000000000000000000000000000000000000000000000000000000000000
0fffff000fffff000ff8ff0000fff00000fff0000770660007700000000440000770000000000000000000000000000000000000000000000000000000000000
0f4444000f4444000f80ff0000fff00000fff0000777400007774666000449000777466600000000000000000000000000000000000000000000000000000000
f0000f000f0000f00f80fff0000ff00000ff00000770000007700688000044000770068800000000000000000000000000000000000000000000000000000000
400004000400000408f00ff000f000000000f0007070000007070000000000000707000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

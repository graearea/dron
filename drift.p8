pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()

car=car(64,64) 
end

function _update()
  if (btn(⬅️)) then car.a-=10 end
  if (btn(➡️)) then car.a+=10 end
  car:move()
end

function _draw()
  rectfill(0,0,127,127,15)
  car:draw()
  print("dx:"..round(car.speed*cos(car.angle),1),0,120)
  print("dy:"..round(car.speed*sin(car.angle),1),32,120)
  print("spd:"..car.speed,64,120)
  print("a:"..car.a,96,120)  
end
function printstatus(text)
 print(text)
end
function round(num,places)
  return flr(num*10^places)/10^places
 end
-->8
--car
function car(ix,iy)
	return {
	a=0,
	x=ix,
	y=iy,
	speed=0,
	move=function(self,v)
		dx=(self.speed*cos(-self.a/360))
  dy=(self.speed*sin(-self.a/360))
  self.x=self.x+dx
  self.y=self.y+dy
	end	,
	draw=function(self)
	 spr_r(0,self.x,self.y,self.a)
 	printstatus(self.a .. " " .. sin(self.a).." ".. cos(self.a).."bob".. self.x)
 end

	}
end


function spr_r(s,x,y,a)
  sw=(32)
  sh=(32)
  sx=(s%18)*18
  sy=flr(s/20)*20
  x0=flr(18)
  y0=flr(14)
  a=a/360
  sa=sin(a)
  ca=cos(a)
  for ix=0,sw-1 do
   for iy=0,sh-1 do
    dx=ix-x0
    dy=iy-y0
    xx=flr(dx*ca-dy*sa+x0)
    yy=flr(dx*sa+dy*ca+y0)
    if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
					sprite=sget(sx+xx,sy+yy)    
					if(sprite!=0) then
		     pset(x+ix,y+iy,sget(sx+xx,sy+yy))
     end
    end
   end
  end
 end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000c777ccc777c00000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000c777ccc777c00000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000001ccccccccccc10000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000001ccccccccccc10000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000001ccccccccccc10000000000000000000000000000000000000000000000
000000c00111100000000111100000000000000c001111000000001111000000000001ccccccccccc10000000000000000000000000000000000000000000000
000000c0ccccccccccccccccccc000000000000c0ccccccccccccccccccc0000000000c111111111c00000000000000000000000000000000000000000000000
000000c08ccccccccc111cccc77000000000000c08ccccccccc111cccc770000000000c111111111c00000000000000000000000000000000000000000000000
000000c08c11ccccc1111cccc77000000000000c08c11ccccc1111cccc770000000000c111111111c00000000000000000000000000000000000000000000000
000000cc8c11ccccc1111cccc77000000000000cc8c11ccccc1111cccc770000000000cc1111111cc00000000000000000000000000000000000000000000000
000000cccc11ccccc1111cccccc000000000000cccc11ccccc1111cccccc0000000000ccccccccccc00000000000000000000000000000000000000000000000
000000cccc11ccccc1111cccccc000000000000cccc11ccccc1111cccccc0000000000ccccccccccc00000000000000000000000000000000000000000000000
000000cccc11ccccc1111cccccc000000000000cccc11ccccc1111cccccc0000000000ccccccccccc00000000000000000000000000000000000000000000000
000000cc8c11ccccc1111cccc77000000000000cc8c11ccccc1111cccc770000000000ccccccccccc00000000000000000000000000000000000000000000000
000000c08c11ccccc1111cccc77000000000000c08c11ccccc1111cccc770000000001ccccccccccc10000000000000000000000000000000000000000000000
000000c08ccccccccc111cccc77000000000000c08ccccccccc111cccc770000000001cc1111111cc10000000000000000000000000000000000000000000000
000000c0ccccccccccccccccccc000000000000c0ccccccccccccccccccc0000000001cc1111111cc10000000000000000000000000000000000000000000000
000000c00111100000000111100000000000000c001111000000001111000000000001ccccccccccc10000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000c888ccc888c00000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000cffffcc0000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000000000000

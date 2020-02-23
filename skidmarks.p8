pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- main
skidding=true
function _init()

car=car(140,64) 
blobs={}
window_x=0
window_y=0
handbrake=false
end

	
function _update()
  if (btn(⬅️)) then 
   car.steer=clamp(car.steer-1,-10,10)  
  elseif (btn(➡️)) then 
   car.steer=clamp(car.steer+1,-10,10)
  else
   if(car.steer>0) then car.steer-=1 end
   if(car.steer<0) then car.steer+=1 end
  end

  if (btn(❎)) then 
   handbrake=true  
  else
   handbrake=false
  end
  
  car.angle=car.angle+car.steer
  car:move()
end

function _draw()
  window_x=car.x-58
  window_y=car.y-58
  camera(window_x,window_y)
  rectfill(0,0,1024,1027,15)
  map(0, 0, 0, 0, 1024, 64)
  car:draw()
  camera()
  --print(car:is_hitting_wall())
  print(bob)
--  print(mget(car.x/8,car.y/8)>8,0,0,11)
end

function printstatus(text)
 print(text)
end

function round(num,places)
  return flr(num*10^places)/10^places
 end
 
function clamp(v,mn,mx)
 return max(mn,min(v,mx))
end
-->8
-- car
bob="asd"
skids_l={}
skids_r={}

function draw_px(x,y,colour)
 pset(x,y,colour)
end

function car(ix,iy)
	return {
	d_travel=0,
	angle=0,
	steer=0,
	x=ix,
	y=iy,
	speed=5,
 dx=0,
 dy=0,
 acc=0.2,
 max_dx=2,
 max_dy=2,
 r_wheels={{y=6,x=7,l="br"},{y=-6,x=7,l="bl"}},
 f_wheels={{y=6,x=-7,l="fr"},{y=-6,x=-7,l="fl"}},
 
 would_hit_wall=function(self,dx,dy)
   sprite= mget((self.x+dx)/8,(self.y+dy)/8)
--			bob=(sprite==59)
   if sprite==59 then
    
--    return true
   end

   for wheel in all(self.r_wheels) do
    wheel_pos={x=self.x+wheel.x,y=self.y+wheel.y}
    locn=self:rotate_wheel_posn(self,wheel)
    bob="x:" .. wheel_pos.x .. "y:".. wheel_pos.y
 		 sprite=mget(locn.x/8,locn.y/8)
    printh(wheel.l)
			 printh("x:" .. locn.x .. "y:" .. locn.y)
			 printh("x:" .. wheel_pos.x .. "y:" .. wheel_pos.y)
			 if(sprite==59) do 
     self.dy=0
			  return true
			 end
   end   
   return false
 end,
 
	move=function(self,v)
	 local dx=self.dx
  local dy=self.dy
	 --delta_angle= self.d_travel-self.angle
	 --self.d_travel= self.d_travel-delta_angle/30
		max_dx=6--abs(5*cos(-self.angle/360))
  max_dy=6--abs(5*sin(-self.angle/360))

		new_dx=(5*cos(-self.angle/360))
  new_dy=(5*sin(-self.angle/360))
  
		delta_dx=(new_dx-dx)/50
		delta_dy=(new_dy-dy)/50
 if (not handbrake) do
		dx=dx+delta_dx
		dy=dy+delta_dy
 end
  dx=clamp(dx,-max_dx,max_dx)
  dy=clamp(dy,-max_dy,max_dy)
  if self:would_hit_wall(dx,dy) then
   dy=0
  else 
   self.y=self.y+dy
  end
  self.x=self.x+dx
  local speed =flr(speed_of(dx,dy))
  sfx(speed*2+1)
  
  angle=self.angle%360
  dangle=(flr(atan2(self.dy,self.dx)*360)+90)%360
  diffangle = abs(dangle-angle)
  
  if (diffangle>20) then
   skidding=true
   sfx(9)
  elseif (diffangle>40) then
   skidding=true
   sfx(8)
  else 
   skidding=false
  end
  
  self.dx=dx
  self.dy=dy
  
  
		-- add skids
		if (skidding) then
	  self:add_skid(skids_r,self.r_wheels[1],true)
	  self:add_skid(skids_l,self.r_wheels[2],true)
		else
	  self:add_skid(skids_r,self.r_wheels[1],false)
   self:add_skid(skids_l,self.r_wheels[2],false)
		end
		
	end,	

	draw=function(self)
	 self:draw_skids(skids_l)
	 self:draw_skids(skids_r)
	 spr_r(0,self.x,self.y,self.angle, draw_px)
  --print(bob,self.x-58,self.y-58)
 end,
 
 draw_skids=function(self,skiddies)
 	local prevx=nil 
	 local prevy=nil
	 for b,skid in pairs(skiddies) do
	 	if(prevx != nil and skid.x !=nil ) do 
	   line(prevx,prevy,skid.x,skid.y,0)
	  end
		 prevx=skid.x
		 prevy=skid.y
	 end
 end,

 rotate_wheel_posn=function(self,pos)
	 local dx=pos.y
	 local dy=pos.x
	 local tx=self.x
	 local ty=self.y
	 local ca=sin(self.angle/360)
	 local sa=cos(self.angle/360)
	 xx=flr(dx*ca-dy*sa+tx)--transofrmed val
	 yy=flr(dx*sa+dy*ca+ty)
		local locn={x=xx,y=yy}
		printh(locn.x..","..locn.y)
		return locn
 end,
 
	add_skid=function(self,skids,pos,add_it)
		skd=self.rotate_wheel_posn(self,pos)
	 if(add_it) then
 	 add(skids,skd)
	 else
	  add(skids,{x=nil,y=nil})
	 end
	end
	}
end

function speed_of(x,y)
  return sqrt(x*x+y*y)
end


function spr_r(s,x,y,a,fn)
  sw=(32)--sprite dimenstions
  sh=(32)
  sx=flr(s%18)*18--0 pos of sprite
  sy=flr(s/18)*18
  x0=(16)--centre of sprite
  y0=(16)
  a=a/360
  sa=sin(a)
  ca=cos(a)
  for ix=0,sw-1 do--for all px
   for iy=0,sh-1 do
    dx=ix-x0-- minus 16
    dy=iy-y0
    xx=flr(dx*ca-dy*sa+x0)--transofrmed val
    yy=flr(dx*sa+dy*ca+y0)
    if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
					local px_colour=sget(sx+xx,sy+yy)    
					if(px_colour!=0) then
		     fn(x+ix-16,y+iy-16,px_colour)
     end
    end
   end
  end
end
 
-->8
-- todo
-- support for tiled mapsections
-- create track that can be created 
-- ghost car that can be followed
-- accelerator and brake
-- buttons for small big turns that match small big corners?
-- how to deal with >360< problem
-- what should accelerator do?
-- drift angle directly function of accelerator
-- direction of travel just down to steering
-- move pivot point of car forward

-->8


__gfx__
0000000000000000000000000000000000300000000000000000000000000000dddddddddddddd0000dddddddddddddddddddd00d00000000dddddddddddddd0
000000000000000000000000000000000000000000000200000009000000a000dddddddddddd00000000dddddddddddddddd0000dd00000000dddddddddddd00
0000000000000000000000000000000000000000020000000000000000000000dddddddddd000000000000dddddddddddd000000ddd00000000dddddddddd000
0000000000000000000000000000000000000030000000000090000000000000dddddddd0000000000000000dddddddd00000000dddd00000000dddddddd0000
0000000000000000000000000000000000000000000000000000000000a00000dddddd00000000000000000000dddddd00000000ddddd00000000dddddd00000
0000000000000000000000000000000000000000000000000000000000000000dddd000000000000000000000000dddd00000000dddddd00000000dddd000000
00000000000000000000000000000000030000000000000200000900000000a0dd0000000000000000000000000000dd00000000ddddddd00000000dd0000000
00000000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000000000dddddddd0000000000000000
0000000000000000000000000000000000000000dddddddd0000dddddddd0000ddddddd0ddd0000000000ddd0dddddddddd0000000000dddddd0000000000000
0000000000000000000000000000000000000000dddddddd0000dddddddd0000ddddddd0dd000000000000dd0dddddddddd0000000000dddddd000000000000d
000000c001111000000001111000000000000000dddddddd0000dddddddd0000dddddd00d00000000000000d00dddddddd000000000000dddd000000000000dd
000000c0ccccccccccccccccccc0000000000000dddddddd0000dddddddd0000dddddd00000000000000000000dddddddd000000000000dddd00000000000ddd
000000c08ccccccccc111cccc7700000dddddddd000000000000dddddddd0000ddddd0000000000000000000000dddddd00000000000000dd00000000000dddd
000000c08c11ccccc1111cccc7700000dddddddd000000000000dddddddd0000ddddd0000000000000000000000dddddd00000000000000dd0000000000ddddd
000000cc8c11ccccc1111cccc7700000dddddddd000000000000dddddddd0000dddd000000000000000000000000dddd00000000000000000000000000dddddd
000000cccc11ccccc1111cccccc00000dddddddd000000000000dddddddd0000dddd000000000000000000000000dddd0000000000000000000000000ddddddd
000000cccc11ccccc1111cccccc0000000000000000000dddd00000000000000dddddddd77dd77dddddddddd0000000000000000000000000000000000000000
000000cccc11ccccc1111cccccc00000000000000000dddddddd000000000000dddddddd77dd77dddddddddd0000000000000000000000000000000000000000
000000cc8c11ccccc1111cccc77000000000000000dddddddddddd0000000000dddddddddd77dddddddddddd0000000000000000000000000000000000000000
000000c08c11ccccc1111cccc770000000000000dddddddddddddddd00000000dddddddddd77dddddddddddd0000000000000000000000000000000000000000
000000c08ccccccccc111cccc7700000000000dddddddddddddddddddd000000dddddddd77dd77dd00dddddd0000000000000000000000000000000000000000
000000c0ccccccccccccccccccc000000000dddddddddddddddddddddddd0000dddddddd77dd77dd0000dddd0000000000000000000000000000000000000000
000000c001111000000001111000000000dddddddddddddddddddddddddddd00dddddddddd77dddd000000dd0000000000000000000000000000000000000000
00000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddd77dddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000dddddddddd000d0000000d000000ddddddddddddddddd1111111100000000ddddd000000ddddd00000000
000000000000000000000000000000000000000d000dddddddddd000d0000000d000000ddd5ddddddddddddd1111111100000000ddddd000000ddddd00000000
00000000000000000000000000000000000000dd00dddddddddddd00dd000000d000000ddddddddddddddddd1111111100000000dddddd0000dddddd00000000
00000000000000000000000000000000000000dd00dddddddddddd00dd000000d000000ddddddddddddddddd1111111100000000dddddd0000dddddd00000000
0000000000000000000000000000000000000ddd0dddddddddddddd0ddd00000dd0000dddddddddddddddddd1111111100000000ddddddd00ddddddd00000000
0000000000000000000000000000000000000ddd0dddddddddddddd0ddd00000dd0000dddddddddddddddddd6666666600000000ddddddd00ddddddd00000000
000000000000000000000000000000000000dddddddddddddddddddddddd0000ddd00ddddddddd5ddddddddd5555555500000000dddddddddddddddd00000000
000000000000000000000000000000000000dddddddddddddddddddddddd0000dddddddddddddddddddddddd5757575700000000dddddddddddddddd00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a3000000a3a393a3a3a3a3a3f0000000e0a3a3a3a3a3a3a3a3a3a3a3d000000000f1a3a3a3a3a3a3a3a3a3a3a3f02000000000000000
000000000000e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3f0000000000000000000000000000000000000000000400000000000000000000000000000
0000600000a3a3a3a3a3a3000000a3a3a3a3a3a3a3810000000000e0a3a3a3a3a3a3a3a3a3a3a362724252a3a3a3a3a393a3a3a3a3a3f0200000000060000000
00400000000010e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3f000000000000000000000000000000000500070000000000000700000000000000000000000
0000000000a3a3a3a393a3000000a3a3a3a3a3a3a3c1000000000000e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3f020000000000000000000
0000000070101010e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3f00000000000000000000000000000000000000000000000000000000000000000004000000000
0000000000a3a3a3a3a3a30000a3a3a3a3a3a3a3810000000000000000e0a3a3a3a3a3a3a3a39393a3a3a3a3a3a3a3a3a3a3a3a3f02000000000000000000000
000000000000000010e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3f0000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a37300a3a3a3a3a3a3a3c1000000005000000000e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3f0200000000000000000000000
00000000000000000010e0a3a3a3a3a3a3a3a3a3a3a380c000000000005000000000000000600000000000000000000000000000005000000000000000000000
0000000000a393a393a3a37100a3a3a3a3a3a3810000000000000000000000e0a3a3a3a3a3a3a3a3a3a3a3a3a393a3a3a3a3f000006000000000000000000000
0000000000500000000010a0b0a3a3a3a3a3a3a38090400070000000000000000000000000000000004000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a37100a3a3a3a3a3a3c1000000000000000000000000e0a3a3a393a3a3a3a3a3a3a3a3a3a3a3a3f00000000000000040000000000000
00000000000000000000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000a3a3a3a3a3a37100a3a393a3a3a30000400000000000000070000000e0a3a3a3a3a3a3a3a3a3a3a3a3a3a3f0000000000000000000000000000000
00000000000000000000000010100000500000000000000000000000000000000000000000000000000000000000000000400000000000000070000000000000
0000000000a3a3a3a3a3a36300a3a3a3a3a3a3000000000000000000000000000000e0a3a3a3a3a3a3a3a3a3a3a3a3f000000000000000000000000000000000
00400000000000000070000000000000000000000000000000000000000000000000004070000000005000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a3a300a3a3a3a3a3a300000000000000005000000000000000e0a3a393a3a3a3a3a3a3a3f00000000040700000000050000000000000
00000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000500000000000000000
0000600000a3a393a3a3a3a300a3a3a3a393a30000000000000000000000000000400000e0a3a3a3a3a3a3a38090006000000000000000000000000000000000
00000000000000500000000000000000000060000000000000000000000000000000000000000000000000000000600000000000000000000000000000400000
0000000000a3a3a3a3a3a3a383a3a3a3a3a3a3000000000000000000000000000000000000a0b0a3a3a380900000000000000000000000000000000000006000
00000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a3a3a393a3a3a3a3a3a3a3a3a3a3000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000070
0000000000a3a3a3a393a393a3a3a3a393a3a3000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000070000000000000000000500070000000400000000000000000000000004000000000000000500000000000000000000000
0000000000a3a3a3a3a3a3a3a3a3a3a3a3a3a3000070000000000000000000000000000000000000000000000000004000000000000000000000000040000000
00000000500000000000000000000000000000000000000000000000000000000000000050000000000000000000000000700000000000000000000000000000
0000000000b1a3a393a3a3a3a3a3a3a3a3a381000000000000000040000060000000000000000040000000000000000000000000500000000000000000000000
00700000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000400000600000000000
0000004000d1a3a3a3a3a3a3a3a3a393a3a3e1000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000
00000000000000400000600000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000005000
000000000000e0a3a3a3a3a3a3a3a3a3a3f000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000005000000000000000000000000000000000607000000000000000000000600000000000600000000000000000000000000000
00000000000000a0b0a3a3a3a3a3a380900000000000000000000000000000000000000000000000000000000000006070000000000000000000006000000000
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000006000000000000000004000000000000000000000004000000000000000000000000000000000
00000000000000004000000000000000000000000000000000000000000000000000000000607000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000600000000000000040000000
00005000000000000000000000000000000040000000400000007000006000000000000000000000000000000000000000400000000000000000000000400000
00000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000060
00000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000
00006000000000000000400000000000500000000000000000000000000000004000000000000070004000000000000000000000000000000000000000000000
00000000000000000000000000500000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000
00000000000000000000000000600000000060000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000
00000000000000006000000000000000000000000000000000004000000000005000000000000000000000000000000000000000007000400000000000000000
00000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000500070000000000000700000000000
00000000000000000000000000000000000000000000000000000000006000000000600000000000000000000000000000000000000000000000000000000000
00000000004000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000
00400000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000050
00700000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000040000000000000000000000000000000006000000000000000000000000000000000000000000000000000
00000000000000000000000000000040000000000000000000000000000000000000005000000000000000600000000000000000000000000000005000000000
00000000000000000000000040007000000000500000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000500000000000000060000000000000
00000000000000000050000000000000000000000000000000004000700000000050000000000000000000000000000000000000000000000000000000000000
00000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000070
00000000000000000000000000000000000000000000000000500000000000000000000000000000000040007000000000000000000000000000000000000000
00000000000000000000000000000000000000005000000000000000000000000000000000000000004070000000005000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000
0000000000000000000000000000060000000000000000000007000400000000000000000000000006000000000000000000000700040000000000000000000000000000000000000600000000000000000000070004000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000400003b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000050000000000
00000000000000000000000003242528282828292829282828282828282828282828282828282828282828282828282828282828282828282828282828283a3a3a3a3a393a3a3a3a3a3a3a2627000000000000000000000000000000000500070000000000000000000005000000000000000000000000070000000000000000
000000000000000000000024253a2828282828292829282828283928282828282828282828282839282828282828282839282828282828282828282828283a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d0000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000040000
000000000000000400001f3a28282828392828292829282828282828282828282828282828282828282828282828282828282828282828282828282828283a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d00000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000
0005000700000000001f3a3a28282828282828292829283928282828282828283928282828282828282828282828282828282828282828282828282828283a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d000000000000000000000000000000000000000000060700000000000000000000060000000000060000000000000000
00000000000000001f3a3a39282828282828282928292828282828282828282828282828282828282828392828282828282828282828283928282828393a3a3a3a3a393a3a3a3a3a3a3a3a393a3a3a3a0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000343a3a3a3a3a2839282828282928292828282828283928282828282828282828282828282828282828282828282828282828282828283a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d00000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000
00000000000000353a3a3a3a3a3a3a3a1501010000000000000000000000000000000000000000070000000000000000000500070000000000000000000000000000000000070a0b3a3a3a3a3a3a3a393a3a0d000000000000000000000006000000000000000000000000040000000000000000000000000000000000000000
000000000000343a393a3a3a3a3a150101010000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3a3a3a3a3a3a3a3a3a3a0d0000000400000000000000000000000000000000000000000000000000000000000000000400000007000006
060000000000353a3a3a3a393a0001000000000000000000000700000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000e3a3a3a3a393a3a3a3a3a0d00000000000000000000000000000000050000000000000000000000070000050000000000000000000000
0000000000343a3a3a3a3a3a17000000000000000600000000000000000000040000060000000000000000040000000000000000000000060700000000000006000000000006000000000e3a3a3a3a3a3a3a3a3a3a0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000353a3a3a3a3a3a0000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000e3a3a3a3a3a3a3a3a3a3a0d0000000500000000000000000000000000000000000000000000000000000000000000000000000000
00000000003a3a3a393a3a17070000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3a3a3a3a3a3a3a3a3a3a0d00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000700393a3a3a3a3a0300000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000e3a3a3a3a3a3a3a3a3a3a0d000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003a3a3a3a3a3a000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000070000060e3a3a3a3a3a3a3a3a3a3a0d0000000000000000000004000000000000000000000000040000000000000005000000000000
00000000003a393a3a3a3a00000000000000000000000000000004000000000000000000000000000000000600000000000000000000070004000000000000000000000000000007000000000000000e3a3a3a3a3a3a3a3a3a3a3700000006000000000000000000000500000000000000000000000007000000000000000000
00000000003a3a3a3a3a3a0000000000000000000500070000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000e3a3a3a3a3a3a3a3a3a3d00000000000000000000000000000000000000000000000000000000000000000004000006
00000000003a3a3a3a3a3a000000000000000000000000000000000000000000000000000400000000000000000000000000000000000024253a3a3a3a3a3a3a3a3a2627000000000000000000000000000e3a3a3a3a3a3a3a3a3a37000000000000000000000000000000000000000000000000000000000000000000000000
00000006073a3a3a3a3a3a00000000000000000000000000000000000000000000000000000000000000000000000000000000000024253a3a3a3a3a3a3a3a3a3a3a3a3a3a262706000000000000000000000e3a3a3a3a3a3a3a3a3d000000000000000006070000000000000000000006000000000006000000000000000000
00000000003a3a3a3a3a3a000000000000000024253a3a3a3a3a3a262700000000000000000000000000000000000000000000001f3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a2627000000000000000000001b3a3a3a3a3a3a3a3a370000000600000000000000000000000000000000000000000000000000000000000000
00000000003a3a3a3a393a000000000000001f3a3a3a3a3a3a3a3a3a3a262700000000000000000600000000000000000000001f3a3a3a3a3a3a393a3a3a3a3a3a3a3a3a3a3a3a3a3a262700000000000000001d3a3a3a3a3a3a3a3a3d0000000000000000000000000006000000000000000000000000000000000000000000
00000000003a3a3a3a393a0000000000001f3a3a3a3a3a3a3a3a3a3a3a3a3a0d0000040000000000000000000000000006001f3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d00000000000000033a3a3a3a3a3a3a3a3a0000000000000000000000000004000000000000000000000000000000000000000000
00000000003a3a3a3a3a3a0000000000343a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d000000000000000000000000000000001f3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d000000000000343a3a3a3a3a3a3a3a3a0000000000000000000000000000000000000000000000000000040000000700000600
00000000003a3a3a3a3a3a0000000000353a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a0d00000700000000000000000000001f3a3a3a3a3a3a3a3a393a3a3a3a3a3a3a3a393a3a3a3a3a3a3a3a3a3a0d00010000003e3a3a3a3a3a3a3a3a3a0000000000000000000000000000000000000000000000000000000000000000000000
00040000003a3a3a3a3a3a00070000343a3a3a3a3a3a3a3a3a393a3a3a3a3a3a3a3a0d0000000000000000000000001f3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a393a3a3a3a3a3a0d0000031f3a3a3a3a3a3a3a3a3a3a0400000000000000000000000400000000000000000000000000000000000000000000
00000000003a3a393a3a3a00000000353a3a3a3a3a3a393a3a3a3a3a3a3a3a3a3a3a3a0d000000000000000000001f3a3a3a3a3a3a3a3a3a3a3a3a0809040000020a0b3a3a3a3a393a3a3a3a3a3a3a2614253a393a3a3a3a3a3a3a3a3a0000000000000500000000000000000000060000000000000004000000000005000000
00000000003a3a3a3a3a3a000000343a3a3a3a3a3a3a3a3a3a3a3a3a393a3a393a3a3a3a0d00000004000000001f3a3a3a3a3a3a3a393a3a3a080902000000000200000a0b3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a180000000000000000000000000000000000000000000000000000000006000000000600
00000000003a3a393a3a3a000000353a3a3a3a3a3a3a3a0f0a0b3a3a3a3a3a3a3a3a3a3a3a0d0000000000001f3a3a3a3a3a3a3a3a3a3a3a0f0000000000000000000000000e3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a1c0000000007000400000000000000000000000000000000000000000000000000000000
__sfx__
00010000000000000014050140503633015050333502a050190503c1501c050380503435033350333503335033350333500b35017350250500000000000000000000000000000000000000000000000000000000
011000030015400154001540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000030215402154021540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00030415404154041540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00030515405154051540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000030715407154071540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000915409154091540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000030b1540b1540b1540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000253502e450253502d450253502e4500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000253202e420253202d420253202e4200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 01424344


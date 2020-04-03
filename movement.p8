pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 x=100 y=100
 rectfill(0,0,128,128,9)
 circfill(x,y,10,10)
 speed=3
end

function _update()
 local dx=0
 local dy=0
 if (btn(⬅️)) then dx=-1 end
 if (btn(➡️)) then dx=1 end
 if (btn(⬆️)) then dy=1 end
 if (btn(⬇️)) then dy=-1 end   
 vector=move(dx,dy)
end

function move(dx,dy)
 if dx==0 and dy==0 then return {dx=0,dy=0} end
 angle=  ((atan2(dx,dy)*360))%360
 new_dx=(speed*cos(-angle/360))
 new_dy=(speed*sin(-angle/360))
 x=x+new_dx
 y=y+new_dy
 return {dx=new_dx,dy=new_dy}
end


function _draw()
 rectfill(0,0,128,128,9)
 circfill(x,y,10,10)
 print(angle,x,y,black)
 print((vector.dx) .. "," .. (vector.dy) ,x,y-10,black)
 
end

function move_full(dx,dy)
    angle=calc_dir(dx,dy)
    if angle==nil then return end
    local vector=calc_vector(angle,3)
    x=x+vector.x
    y=y+vector.y
   end
   
function calc_dir(diff_x,diff_y)
 if diff_x==0 and diff_y==0 then return nil end
 return ((atan2(diff_x,diff_y)*360))%360
end

function calc_vector(angle,speed)
 new_dx=(speed*cos(-angle/360))
 new_dy=(speed*sin(-angle/360))
 return {x=new_dx,y=new_dy}
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

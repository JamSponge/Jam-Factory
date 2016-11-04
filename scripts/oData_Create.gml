#define oData_Create
//CREATE!

Wages = 5.55
CheapStaff = 60
LessCheapStaff = 0
NetProfit = 500

Price = 1.49
UnitCost = 0.40

alarm[0] = room_speed
alarm[1] = room_speed

draw_set_font(font0)
draw_set_halign(fa_center)
draw_set_valign(fa_center)

CurrentBackground = 3

background_index[0] = background0
background_index[1] = background1
background_index[2] = background2
background_index[3] = background3

//ADD OVERLAY PROFIT THING
tile_add(ProfitOverlay,0,0,640,360,0,0,-1000)

//CREATE POINTER
instance_create(0,0,oPointer)

//CREATE PROFIT BAR
ProfitBar = instance_create(457,300,oProfitBar)
ProfitBar.MinX = 405
ProfitBar.MaxX = 601 //197 +506

//CREATE BUTTONS - DATA TYPE TRUE IS WAGES/FALSE IS COST
Button0 = instance_create(40,155,oButton)
Button0.DataType = true
Button0.Positive = true
Button0.IndexBase = 3

Button1 = instance_create(94,155,oButton)
Button1.DataType = true
Button1.Positive = false
Button1.IndexBase = 0

Button2 = instance_create(192,155,oButton)
Button2.DataType = false
Button2.Positive = true
Button2.IndexBase = 3

Button3 = instance_create(246,155,oButton)
Button3.DataType = false
Button3.Positive = false
Button3.IndexBase = 0

#define oData_Draw
draw_text(82,109,Wages)
draw_text(234,109,Price)

draw_text(room_width/2,room_height/2,NetProfit)


#define oData_Step
if keyboard_check_pressed(vk_escape)
{
game_end()
}


SteepJamModifier = 0
CheapJamModifier = 0
PissedOffStaffModifier = 0
HappyStaffModifier = 0

if Price > 2
{
SteepJamModifier = Price - 2
    if Price > 2.6
    {
    SteepJamModifier = SteepJamModifier*1.5
    }
}

if Price < 1
{
CheapJamModifier = (Price - 1.1)*2
}

JamDemand = 1 - (SteepJamModifier/2) - CheapJamModifier

if Wages < 6
{
PissedOffStaffModifier = Wages - 6
HappyStaffModifier = Wages - 6.2

    if Wages < 5.70
    {
    PissedOffStaffModifier = PissedOffStaffModifier*1.5
    }  
}

if Wages > 7
{
    if NetProfit > 400
    {
    HappyStaffModifier = Wages - 7
    }
}

LessCheapStaff = LessCheapStaff + (HappyStaffModifier/room_speed)*2.5
CheapStaff = CheapStaff + (PissedOffStaffModifier/room_speed)*2 //positive because it's a minus, innit

if PissedOffStaffModifier = 0 {CheapStaff = CheapStaff+5/room_speed}

if NetProfit > 456
{ 
if CheapStaff <40 {CheapStaff = 40}
}
    else
    {
    if CheapStaff <5 {CheapStaff = 5}
    }
if CheapStaff >70 {CheapStaff = 70}

if LessCheapStaff > 30 {LessCheapStaff = 30}
if LessCheapStaff < 0 {LessCheapStaff = 0}

Staff = CheapStaff+LessCheapStaff

if Staff > 100 {Staff = 100}


UnitsProduced = Staff*10

Incoming = (oData.UnitsProduced*oData.Price)*JamDemand
UnitCosts = (35/oData.UnitsProduced)*oData.UnitsProduced
StaffCosts = Wages*(CheapStaff/1.8) + Wages*(LessCheapStaff*1.2)

NetProfit = Incoming - UnitCosts - StaffCosts

if NetProfit < 0 {NetProfit = 0}
if Wages < 5.55 {Wages = 5.55}
if Price < 0 {Price = 0}


#define oProfitBar_Step

TargetX = oData.NetProfit/7 + 405
if TargetX < MinX {TargetX = MinX}
if TargetX > MaxX {TargetX = MaxX}

x = TargetX

#define oButton_Create
image_speed = 0
ButtonHeld = false

#define oButton_Step
if position_meeting(mouse_x,mouse_y,self)
    {
    image_index = IndexBase+1
    
    if mouse_check_button_pressed(mb_left)
        {
        
        if Positive
            {
            if DataType
                {
                var i = oData.Wages + 0.10
                    with (oData)
                    {
                    Wages = i
                    }
                }
            else
                {
                var i = oData.Price + 0.10
                    with (oData)
                    {
                    Price = i
                    }
                }
            }
                else
                {
            if DataType
                {
                var i = oData.Wages - 0.10
                    with (oData)
                    {
                    Wages = i
                    }
                }
            else
                {
                var i = oData.Price - 0.10
                    with (oData)
                    {
                    Price = i
                    }
                }
            }
        }
    
    if mouse_check_button(mb_left)
        {
        image_index = IndexBase+2
        ButtonHeld = true
        }
    
    if mouse_check_button_released(mb_left)
    {
    ButtonHeld = false
    }
        
    if ButtonHeld = true
                {
                image_index = IndexBase+2
                //END THE SCRIPT
                exit
                }
    }
    else
    {
    image_index = IndexBase
    }
        

        

#define oData_Staff_Alarm
var i, ii;
ii = Staff div 10;


switch (ii)
{
case 0: 
i = 3
break;

case 1: 
i = 2
break;
case 2:
i = 2
break; 
case 3: 
i = 2
break;

case 4: 
i = 1
break;
case 5:
i = 1
break; 
case 6:
i = 1
break;

case 7: 
i = 0
break;
case 8: 
i = 0
break;
case 9: 
i = 0
break;
case 10:
i = 0
break;

}

//CHANGE BACKGROUND
background_visible[CurrentBackground] = false
background_visible[i] = true

CurrentBackground = i


alarm[0] = room_speed*3



#define oData_Staff_Leave_Arrive_Alarm
alarm[1] = room_speed
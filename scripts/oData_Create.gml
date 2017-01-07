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
draw_set_halign(fa_left)
draw_set_valign(fa_center)

CurrentBackground = 3

background_index[0] = background0
background_index[1] = background1
background_index[2] = background2
background_index[3] = background3

//ADD OVERLAY PROFIT THING
tile_add(ProfitOverlay,0,0,1280,720,0,0,-1000)

//CREATE POINTER
instance_create(0,0,oPointer)

//CREATE PROFIT BAR
ProfitBar = instance_create(750,21,oProfitBar)
ProfitBar.MinX = 697
ProfitBar.MaxX = 1247

//CREATE NEWS
instance_create(0,0,oNews)

//CREATE BUTTONS - DATA TYPE TRUE IS WAGES/FALSE IS COST
Button0 = instance_create(105,152,oButton)
Button0.DataType = true
Button0.Positive = true
Button0.IndexBase = 3

Button1 = instance_create(208,152,oButton)
Button1.DataType = true
Button1.Positive = false
Button1.IndexBase = 0

Button2 = instance_create(379,152,oButton)
Button2.DataType = false
Button2.Positive = true
Button2.IndexBase = 3

Button3 = instance_create(480,152,oButton)
Button3.DataType = false
Button3.Positive = false
Button3.IndexBase = 0

#define oData_Draw
draw_text(187,81,Wages)
draw_text(452,79,Price)

draw_text(room_width/2,room_height/2,Staff)


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
    else
    {
    HappyStaffModifier = -1
    PissedOffStaffModifier = -2
    }
}

//NO PROFITS, STAFF SHOULD LEAVE
if NetProfit < 456
{

PissedOffStaffModifier = PissedOffStaffModifier*2
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

NetProfit = (Incoming - UnitCosts - StaffCosts) *oNews.NewsImpactMultiplier

if NetProfit < 0 {NetProfit = 0}
if Wages < 5.55 {Wages = 5.55}
if Price < 0 {Price = 0}


#define oProfitBar_Step

TargetX = oData.NetProfit/3.5 + 697
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
#define oNews_Create
NewsImpactMultiplier = 1
global.TickerPace = 60/room_speed

alarm[0] = room_speed*2

NewsItems = ds_list_create()

//0 = Negative, 1 = N/A, 2 = Positive
ds_list_add(NewsItems, 
"CRISP ADVERT MAN CRUCIFIED LIVE ON TV",1,
chr(34) + "TREACLE IS TREASON" +chr(34) +": NEW CAMPAIGN SEES BOOST IN JAM SALES",1.8,
"CONSERVATIVE PARTY OFFICIALLY REBRANDS AS" + chr(34) + "CONSERVES" + chr(34),1.1,
"OPENLY CHEERFUL SWORD-FIGHTING JUDGES BLOCK JAM INDUSTRY EXPANSION PLANS",0.7,
"HEATHROW'S THIRD RUNWAY TO BE" + chr(34) + "SUPPORTED BY JAM" + chr(34),1,
chr(34)+ "FOREIGNERS BAD, JAM GOOD" + chr(34) +  "REPORT ALT-EXPERTS",1.2,
"QUEEN PHOTOGRAPHED WITH A LOVELY SCONE",1.7,
"BRITISH STRAWBERRY CROPS STRUCK BY FOUL WEATHER: JAM INDUSTRY TRIPLES SUGAR, SWITCHES TO KALE",0.5,
"SCIENTISTS SUGGEST JAM ATTRACTS WASPS",0.3,
"TABLOID LAUNCHES PRO-WASP CAMPAIGN: JAM DEMANDS SOAR",1.6,
"EXPOSE SUGGESTS PROMINENT MP" +chr(34) + "PERFORMED SEX ACT W. BARREL OF RASPBERRIES" + chr(34),0.7,
"MEDIA REACTS TO FRUITGATE:" +chr(34) +"IT'S JAM-BANTER FOR BOYS" +chr(34),1,
"CELEBRITIES LAUNCH SOLIDARITY HASHTAG #IFFRUIT2, POST PHOTOS FORNICATING WITH FRUIT-BASED PRODUCTS",1.6,
"HEALTH EXPERTS WARN OF" + chr(34) + "GONAD-IABETES" + chr(34) +", ADVISE AGAINST JAM FORNICATION",1.4,
"CONSUMERS BUY FRUIT SPREADS TO THROW AT HEALTH EXPERTS",1.5,
chr(34) +"SUGAR IS A MYTH" + chr(34) +", MEP REVEALS",1.7,
"FOREIGN WORKERS FOUND DROWNED IN JAM. NATION OUTRAGED BY SENSELESS LOSS OF JAM",1.4,
"REMOANERS PROMISE GLOOMY PROSPECTS: JAM INDUSTRY COMMITS TO TURN GLOOM INTO JAM",1.3,
"EXPORT COSTS SOAR." + chr(34) + "UK FED UP WITH SO-CALLED EXPORTS" + chr(34) + "MEP ASSURES",0.6,
"FOREIGNS FINALLY" + chr(34) + "LEAVE" + chr(34) + "LIKE WE VOTED FOR. NEW BRITISH JAMJOBS FOR BRITISH JAMPEOPLE",0.7,
"MEP DECLARES" + chr(34) + "TRAVEL IS TREASON" + chr(34) +", DEMANDS PLANES/BOATS BE REPLACED WITH" + chr(34) + "BUTLINS" + chr(34),1,
"WEIRDO MURDERS ANTI-JAM POLITICIAN FOR PROBABLY NO REASON",1.2,
"UK PREPARES TO LEAVE EU. PM CONFIDENT THAT CHINA WILL LIKE JAM",1,
"VILE CAMPAIGNERS SPREAD FEAR INSTEAD OF LOVELY JAM:" + chr(34) +"UK HAS NO DEALS, NO PLAN" + chr(34),0.6
)

#define oNews_Alarm0
//GET NEWS FROM LIST
var NewsToDraw = ds_list_find_value(NewsItems, 0)
NewsImpactMultiplier = ds_list_find_value(NewsItems, 1)
//DELETE ENTRY FROM LIST
ds_list_delete(NewsItems, 0)
//NOW DELETE THE NEXT ENTRY, i.e THE DATA MULTIPLIER!
ds_list_delete(NewsItems, 0)
//IDENTIFY LENGTH OF NEWS ITEM TO TRIGGER NEXT NEWS ITEM
var i = string_width(NewsToDraw);
alarm[0] = i+350

NewsUpdate = instance_create(1300,682,oNewsUpdate)
NewsUpdate.SpriteNumber = round(random_range(0,6))
NewsUpdate.NewsToDraw = NewsToDraw

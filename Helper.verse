using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Verse.org/Simulation }

<#
 _____ ________   __ ________   __               
/  __ \| ___ \ \ / /|___  /\ \ / /               
| /  \/| |_/ /\ V /    / /  \ V /                
| |    |    / /   \   / /    \ /                 
| \__/\| |\ \/ /^\ \./ /___  | |                 
 \____/\_| \_\/   \/\_____/  \_/                                                                  
 _____ ______ _____  ___ _____ _____ _   _ _____ 
/  __ \| ___ \  ___|/ _ \_   _|_   _| | | |  ___|
| /  \/| |_/ / |__ / /_\ \| |   | | | | | | |__  
| |    |    /|  __||  _  || |   | | | | | |  __| 
| \__/\| |\ \| |___| | | || |  _| |_\ \_/ / |___ 
 \____/\_| \_\____/\_| |_/\_/  \___/ \___/\____/ 
This utility script is project based. Refer to Util.verse for global functions. 
#>

# Stat_Handler.verse @editable tooltips
StatHandlerToolTip<public><localizes>:message := "The Stat_Handler.verse creative device placed in the level."
MoneyStatTip<public><localizes>:message := "The Primary Stat device. | This stat can be either Agent or Match in scope."
EnergyStatTip<public><localizes>:message := "The Secondary Stat device. | This stat can be either Agent or Match in scope."
LevelStatTip<public><localizes>:message := "The Level Stat device. | This stat MUST be Match in scope."
GemStatTip<public><localizes>:message := "The Premium Stat device. | This stat MUST be Match in scope."
RebirthStatTip<public><localizes>:message := "The Rebirth Stat device. | This stat MUST be Match in scope."
WoodStatTip<public><localizes>:message := "The Wood Stat device. | This stat can be either Agent or Match in scope."
StoneStatTip<public><localizes>:message := "The Stone Stat device. | This stat can be either Agent or Match in scope."
MetalStatTip<public><localizes>:message := "The Metal Stat device. | This stat can be either Agent or Match in scope."
StatScopeTip<public><localizes>:message := "Wether the Primary, & Secondary stats are using Agent, or Match scope."
EndGameTip<public><localizes>:message := "The End Game Device used to goto the next round upon player rebirth."
RebirthMultTip<public><localizes>:message := "The Multiplier per rebirth to be given for income generation. | Final Income = Income * Mult = Income * (1.0 + (RebirthCount * RebirthMult))"

# Buyable_Item.verse @editable tooltips
BIAccoladeTip<public><localizes>:message := "The accolades devices to award when this item is purchased."
ItemPropsTip<public><localizes>:message := "Item props to be spawned when this is purchased."
PadPropTip<public><localizes>:message := "Buypad used by the player to purchase this."
BuyTrigTip<public><localizes>:message := "The trigger used to purchase this. | Activated by player."
ShowPadTip<public><localizes>:message := "The trigger to show the buypad of this device. | commonly used with the EVENT_Purchased trigger of another Buyable_Item."
BIFundsTip<public><localizes>:message := "HUD Element to show players the purchase status of this item."
BIInfoBoardTip<public><localizes>:message := "The billboard device displaying purchase information."
BIInfoBoard2Tip<public><localizes>:message := "If `Require_Fuel` is on, The billboard device displaying fuel information."
PadVisTip<public><localizes>:message := "Wether or not the pad is visible at game start."
DoCOTTip<public><localizes>:message := "Wether or not the this item has a resource drain effect."
NameTip<public><localizes>:message := "The name of the purchasable prop to show on the billboard."
PriceTip<public><localizes>:message := "The price to purchase this item."
IncomeTip<public><localizes>:message := "The income provided by this item every second when purchased."
COTTip<public><localizes>:message := "If Cost_Over_Time is on, The amount of stat drained per second."
Stat2BuyTip<public><localizes>:message := "The stat required to purchase this item."
Stat2GiveTip<public><localizes>:message := "The stat to give when this item is purchased."
BIXPTip<public><localizes>:message := "The amount of level stat to increase when purchased."
EventPurchasedTip<public><localizes>:message := "Outgoing event trigger to signal when this item purchased."
FuelTip<public><localizes>:message := "Wether or not income generation requires fuel."
StatFuelTip<public><localizes>:message := "If Require_Fuel is on, Determines which stat is used as fuel."
EmptyFuelTip<public><localizes>:message := "If Require_Fuel is on, The length of time it takes for the fuel to empty."
FuelBtnTip<public><localizes>:message := "The button device used to refuel this item."
FuelCostTip<public><localizes>:message := "If Require_Fuel is on, The cost to refuel."

# 

# Hitbox.verse @editable tooltips
HBAccoladeTip<public><localizes>:message := "Accolades device awarded when hit."
HBInfoBoardTip<public><localizes>:message := "Billboard device to display hitbox information."
HBPropTip<public><localizes>:message := "Hitbox prop that the player will hit to gain stat points."
HBMessageTip<public><localizes>:message := "HUD Message shown to the hitting player displaying income information."
HBManipTip<public><localizes>:message := "Prop Manipulator device attached to the Hitbox Prop."
EvtHBTriggedTip<public><localizes>:message := "Outgoing event for when the hitbox is hit by a player."
ShowBoxTip<public><localizes>:message := "Incoming event to show the hitbox. | Commonly used with the EVENT_Purchased trigger in the Buyable_Item.verse script."
UseLimitedTip<public><localizes>:message := "When set, turns this hitbox into a respawning, limited use type. (E.G Mining System)"
ExpireTip<public><localizes>:message := "If Use_Limited_Resource is on, The number of hits required to destroy this prop."
HBVisTip<public><localizes>:message := "Wether or not this hitbox is visible when the game starts."
RespawnTip<public><localizes>:message := "If Use_Limited_Resource is on, The time it takes for the hitbox to respawn when destroyed."
LvlNeedTip<public><localizes>:message := "If Use_Limited_Resource is off, The number of hits needed to increase the level of the hitbox."
HBStatTip<public><localizes>:message := "The amount of stat to give the player when hit."
HBStatTypeTip<public><localizes>:message := "The type of stat to give the player when hit."
HBXPTip<public><localizes>:message := "The amount of level stat given to the player when hit."
PPLTip<public><localizes>:message := "If Use_Limited_Resource is off, Multiplies with Initial_Level_Need every time the hitbox levels up."
StatMultTip<public><localizes>:message := "If Use_Limited_Resource is off, Multiplies with Stat_Value every time the hitbox levels up."
MatStatTip<public><localizes>:message := "Wether the Material stats are using Agent, or Match scope."
UseWidgetTip<public><localizes>:message := "Wether or not the device should use the default UI, or a custom widget."

# Resource_Exchange.verse @editable tooltips
REAccoladeTip<public><localizes>:message := "Accolades device granted when exchanged."
BtnTip<public><localizes>:message := "Button devices used to make an exchange attempt."
REFundsTip<public><localizes>:message := "HUD Message device to display purchase status to the players UI."
REInfoBoardTip<public><localizes>:message := "Billboard device used to display exchange information."
ConvertTip<public><localizes>:message := "The amount needed to convert this stat."
ExchangeTip<public><localizes>:message := "The amount given to the player when converted."
NeedTip<public><localizes>:message := "The stat required to convert."
GiveTip<public><localizes>:message := "The stat given after conversion."
REXPTip<public><localizes>:message := "The level stat given when exchanged."
REVisTip<public><localizes>:message := "Wether or not the exchange is visible on start."
REShowTip<public><localizes>:message := "Incoming trigger event to show the exchange information."

Helper<public> := module:
    UpdateBillboardRotation<public>(Players : []player, Info_Board : billboard_device)<suspends>:void =
        loop:
            Sleep(0.025)
            if (Players.Length = 0) { return }

            BillboardPos := Info_Board.GetTransform().Translation
            var ClosestDistance : float = 1000000.0
            var ClosestPlayerPos : vector3 = vector3{}

            for (Player : Players):
                if (Character := Player.GetFortCharacter[]):
                    PlayerPos := Character.GetTransform().Translation
                    DistanceToPlayer := Distance(BillboardPos, PlayerPos)
                    if (DistanceToPlayer < ClosestDistance):
                        set ClosestDistance = DistanceToPlayer
                        set ClosestPlayerPos = PlayerPos

            Direction := ClosestPlayerPos - BillboardPos
            YawRadians := ArcTan(Direction.Y, Direction.X)
            YawDegrees := RadiansToDegrees(YawRadians)
            FixedYawDegrees := YawDegrees + 90.0
            NewRotation := MakeRotationFromYawPitchRollDegrees(FixedYawDegrees, 0.0, 0.0)
            if (Info_Board.TeleportTo[BillboardPos, NewRotation]) {}


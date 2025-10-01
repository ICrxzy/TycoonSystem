using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { Helper }

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
 This script is responsible for the hitbox mechanics.
    Includes a leveling ability to give more stat per hit. 
#>

hitbox := class(creative_device):
    @editable StatHandler : Stat_Handler = Stat_Handler{} # The stat handler device
    @editable Info_Board : billboard_device = billboard_device{} # The billboard attached to the hitbox prop
    @editable Hitbox_Manipulator : prop_manipulator_device = prop_manipulator_device{} # A prop manipulator device attached to the hitbox prop
    @editable EVENT_Hitbox_Hit_Trigger : trigger_device = trigger_device{} # An optional event trigger for when the hitbox has been hit

    @editable var InitialLevelNeed : int = 100 # The initial amount of hits needed to increase in level
    @editable var Stat_Value : float = 0.0 # The initial amount of value given per hit
    @editable Stat_Type : StatEnum = StatEnum.Money # The stat type to give per hit
    @editable XP_To_Give : float = 0.0 # The amount of level stat to give per hit
    @editable PPL_Multiplier : float = 1.0 # Multiplies the InitialLevelNeed by this value every level
    @editable Stat_Multiplier : float = 1.0 # Multiplies the Stat_Value by this value evert level

    var level : int = 1
    var HitCount : int = 0

    OnBegin <override>()<suspends> : void =
        Hitbox_Manipulator.DamagedEvent.Subscribe(OnHit)
        if (StrPerHit := Int[Stat_Value]):
            Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {StrPerHit}"))
            
        Players := GetPlayspace().GetPlayers()
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }

    OnHit (Agent : agent) : void =
        if (Stat_Type = StatEnum.Money) { StatHandler.IncreaseMoney(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Energy) { StatHandler.IncreaseEnergy(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Gemstone) { StatHandler.IncreaseGemstone(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Rebirth) { spawn{ StatHandler.GrantRebirth(Agent)} }
 
        spawn{StatHandler.IncreaseExp(Agent, XP_To_Give)}
        EVENT_Hitbox_Hit_Trigger.Trigger(Agent)
        set HitCount += 1
        if (HitCount = InitialLevelNeed):
            if (NewLevelNeed := Int[InitialLevelNeed * PPL_Multiplier]) { set InitialLevelNeed = NewLevelNeed }
            set Stat_Value = Stat_Value * Stat_Multiplier
            set level += 1
            set HitCount = 0
        StrPerHit := FloorToDecimalPlaces(Stat_Value, 1)
        Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {StrPerHit}"))

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
    @editable Accolade : accolades_device = accolades_device{} # The accolade reward tied to this script
    @editable Info_Board : billboard_device = billboard_device{} # The billboard attached to the hitbox prop
    @editable Hitbox_Prop : creative_prop = creative_prop{}
    @editable HUD_Message : hud_message_device = hud_message_device{} # Used to show the income gain on hit
    @editable Hitbox_Manipulator : prop_manipulator_device = prop_manipulator_device{} # A prop manipulator device attached to the hitbox prop
    @editable EVENT_Hitbox_Hit_Trigger : trigger_device = trigger_device{} # An optional event trigger for when the hitbox has been hit

    @editable Use_Limited_Resource : logic = false # Use a respawning, limited resource type. Think of rocks, or gems. 
    @editable Hits_Before_Expire : int = 0 # The number of hits needed to destroy this object
    @editable Respawn_Time : float = 0.0 # The time it takes a limited resource to respawn
    @editable var InitialLevelNeed : int = 100 # The initial amount of hits needed to increase in level
    @editable var Stat_Value : float = 0.0 # The initial amount of value given per hit
    @editable Stat_Type : BasicStatEnum = BasicStatEnum.Money # The stat type to give per hit
    @editable XP_To_Give : float = 0.0 # The amount of level stat to give per hit
    @editable PPL_Multiplier : float = 1.0 # Multiplies the InitialLevelNeed by this value every level
    @editable Stat_Multiplier : float = 1.0 # Multiplies the Stat_Value by this value evert level

    # These variables contain the buy pad transform. Allowing for easy showing and hiding of the buy pad prop, and its children.
    var InitialTransform : transform = transform{}
    var InitialPosition : vector3 = vector3{}
    var InitialRotation : rotation = rotation{}
    var HiddenPosition : vector3 = vector3{}

    var level : int = 1
    var HitCount : int = 0

    OnBegin<override>() <suspends> : void =
        Hitbox_Manipulator.DamagedEvent.Subscribe(OnHit)

        set InitialTransform = Hitbox_Prop.GetTransform()
        set InitialPosition = InitialTransform.Translation
        set InitialRotation = InitialTransform.Rotation
        set HiddenPosition = InitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}

        if (PerHit := Int[Stat_Value]):
            if (Use_Limited_Resource = false):
                Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {PerHit}"))
            else Info_Board.SetText(StringToMessage("\n{HitCount} / {Hits_Before_Expire}\nPer Hit: {PerHit}"))
            
        Players := GetPlayspace().GetPlayers()
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }

    OnHit(Agent : agent) : void =
        HUD_Message.Hide(Agent)
        if (Stat_Type = BasicStatEnum.Money) { StatHandler.IncreaseMoney(Agent, Stat_Value) }
        if (Stat_Type = BasicStatEnum.Energy) { StatHandler.IncreaseEnergy(Agent, Stat_Value) }
        if (Stat_Type = BasicStatEnum.Gemstone) { StatHandler.IncreaseGemstone(Agent, Stat_Value) }
        
        Accolade.Award(Agent)
        spawn{StatHandler.IncreaseExp(Agent, XP_To_Give)}
        EVENT_Hitbox_Hit_Trigger.Trigger(Agent)
        set HitCount += 1

        if (Use_Limited_Resource = false):
            if (PerHit := Int[Stat_Value]):
                Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {PerHit}"))
            if (HitCount = InitialLevelNeed):
                if (NewLevelNeed := Int[InitialLevelNeed * PPL_Multiplier]) { set InitialLevelNeed = NewLevelNeed }
                set Stat_Value = Stat_Value * Stat_Multiplier
                set level += 1
                set HitCount = 0
                if (PerHit := Int[Stat_Value]):
                    set Stat_Value = IntToFloat(PerHit)
                    Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {PerHit}"))
        else:
            if (HitCount = Hits_Before_Expire):
                spawn{PropDestruction()}
                set HitCount = 0
            if (PerHit := Int[Stat_Value]):
                Info_Board.SetText(StringToMessage("\n{HitCount} / {Hits_Before_Expire}\nPer Hit: {PerHit}"))
        if (PerHit := Int[Stat_Value]):
            HUD_Message.Show(StringToMessage("+{PerHit}"))

    PropDestruction() <suspends> : void =
        if (Hitbox_Prop.TeleportTo[HiddenPosition, InitialRotation]):
        Sleep(Respawn_Time)
        if (Hitbox_Prop.TeleportTo[InitialPosition, InitialRotation]):
            


            

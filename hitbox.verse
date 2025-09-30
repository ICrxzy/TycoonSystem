using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { Helper }

hitbox := class(creative_device):
    @editable StatHandler : Stat_Handler = Stat_Handler{}
    @editable Info_Board : billboard_device = billboard_device{}
    @editable Hitbox_Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable EVENT_Hitbox_Hit_Trigger : trigger_device = trigger_device{}

    @editable var InitialLevelNeed : int = 100
    @editable var Stat_Value : float = 0.0
    @editable Stat_Type : StatEnum = StatEnum.Money
    @editable XP_To_Give : float = 0.0
    @editable PPL_Multiplier : float = 1.0
    @editable Stat_Multiplier : float = 1.0

    var level : int = 1
    var HitCount : int = 0
    var Stat_Scope : ?StatScope = false

    OnBegin <override>()<suspends> : void =
        set Stat_Scope = option{StatHandler.GetStatScope()}
        Hitbox_Manipulator.DamagedEvent.Subscribe(OnHit)
        if (StrPerHit := Int[Stat_Value]):
            Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {StrPerHit}"))
            
        Players := GetPlayspace().GetPlayers()
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }

    OnHit (Agent : agent) : void =
        if (Stat_Type = StatEnum.Money) { StatHandler.IncreaseMoney(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Energy) { StatHandler.IncreaseEnergy(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Gemstone) { StatHandler.IncreaseGemstone(Agent, Stat_Value) }
        if (Stat_Type = StatEnum.Rebirth) { StatHandler.GrantRebirth(Agent) }
 
        StatHandler.IncreaseExp(Agent, XP_To_Give)
        EVENT_Hitbox_Hit_Trigger.Trigger(Agent)
        set HitCount += 1
        if (HitCount = InitialLevelNeed):
            if (NewLevelNeed := Int[InitialLevelNeed * PPL_Multiplier]) { set InitialLevelNeed = NewLevelNeed }
            set Stat_Value = Stat_Value * Stat_Multiplier
            set level += 1
            set HitCount = 0
        StrPerHit := FloorToDecimalPlaces(Stat_Value, 1)
        Info_Board.SetText(StringToMessage("Level: {level} \n {HitCount} / {InitialLevelNeed} \n Per Hit: {StrPerHit}"))

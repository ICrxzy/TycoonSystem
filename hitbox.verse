using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Helper }
using { VTexture }

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
    @editable:
        ToolTip := StatHandlerToolTip # The Stat_Handler.verse creative device placed in the level.
    StatHandler : Stat_Handler = Stat_Handler{}
    @editable:
        ToolTip := HBStatTypeTip # The type of stat to give the player when hit.
    Stat_Type : BasicStatEnum = BasicStatEnum.Money 
    @editable:
        ToolTip := UseLimitedTip # When set, turns this hitbox into a respawning, limited use type. (E.G Mining System)
    Use_Limited_Resource : logic = false
    @editable:
        ToolTip := HBVisTip # Wether or not this hitbox is visible when the game starts.
    Visible_At_Start : logic = true
    @editable:
        ToolTip := ExpireTip # If Use_Limited_Resource is on, The number of hits required to destroy this prop.
    Hits_To_Destroy : int = 10
    @editable:
        ToolTip := LvlNeedTip # If Use_Limited_Resource is off, The number of hits needed to increase the level of the hitbox.
    var Initial_Level_Need : int = 25 
    @editable:
        ToolTip := RespawnTip # If Use_Limited_Resource is on, The time it takes for the hitbox to respawn when destroyed.
    Respawn_Time : float = 10.0
    @editable:
        ToolTip := HBStatTip # The amount of stat to give the player when hit.
    var Stat_Value : float = 5.0 
    @editable:
        ToolTip := HBXPTip # The amount of level stat given to the player when hit.
    Level_Increase : float = 2.0 
    @editable:
        ToolTip := PPLTip # If Use_Limited_Resource is off, Multiplies with Initial_Level_Need every time the hitbox levels up.
    Level_Point_Multiplier : float = 1.2 
    @editable:
        ToolTip := StatMultTip # If Use_Limited_Resource is off, Multiplies with Stat_Value every time the hitbox levels up.
    Stat_Multiplier : float = 1.5 
    
    @editable:
        ToolTip := HBPropTip # Hitbox prop that the player will hit to gain stat points.
    Hitbox_Prop : creative_prop = creative_prop{}
    @editable:
        ToolTip := HBInfoBoardTip # Billboard_Device device to display hitbox information.
    Billboard_Device : billboard_device = billboard_device{}
    @editable:
        ToolTip := HBMessageTip # HUD Message shown to the hitting player displaying income information.
    HUD_Message : hud_message_device = hud_message_device{}
    @editable:
        ToolTip := HBManipTip # Prop Manipulator device attached to the Hitbox Prop.
    Hitbox_Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable:
        ToolTip := ShowBoxTip # Incoming event to show the hitbox. | Commonly used with the EVENT_Purchased trigger in the Buyable_Item.verse script.
    Show_Hitbox_Trigger : trigger_device = trigger_device{}
    @editable:
        ToolTip := HBAccoladeTip # Accolades device awarded when hit.
    Accolade : accolades_device = accolades_device{}
    @editable:
        ToolTip := EvtHBTriggedTip # Outgoing event for when the hitbox is hit by a player.
    EVENT_Hitbox_Hit_Trigger : trigger_device = trigger_device{}

    # Prop Tranformation Variable initialization.
    var InitialTransform : transform = transform{}
    var InitialPosition : vector3 = vector3{}
    var InitialRotation : rotation = rotation{}
    var HiddenPosition : vector3 = vector3{}

    # Script variables.
    var level : int = 1
    var HitCount : int = 0

    #Hitbox UI Variables.
    var ValueText : text_block = text_block{}
    var MoneyStatImage : texture_block = texture_block{DefaultImage := Money, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}
    var EnergyStatImage : texture_block = texture_block{DefaultImage := Electricity, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}
    var GemstoneStatImage : texture_block = texture_block{DefaultImage := Gems, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}
    var WoodStatImage : texture_block = texture_block{DefaultImage := WOOD, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}
    var StoneStatImage : texture_block = texture_block{DefaultImage := Stone, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}
    var MetalStatImage : texture_block = texture_block{DefaultImage := Metal, DefaultDesiredSize := vector2{X := 100.0, Y := 100.0}}

    OnBegin<override>() <suspends> : void =
        Hitbox_Manipulator.DamagedEvent.Subscribe(OnHit)
        Show_Hitbox_Trigger.TriggeredEvent.Subscribe(ShowHitbox)

        set InitialTransform = Hitbox_Prop.GetTransform()
        set InitialPosition = InitialTransform.Translation
        set InitialRotation = InitialTransform.Rotation
        set HiddenPosition = InitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}

        if (Visible_At_Start = false):
            if (Hitbox_Prop.TeleportTo[HiddenPosition, InitialRotation]):
        else if (Visible_At_Start = true):
            if (Hitbox_Prop.TeleportTo[InitialPosition, InitialRotation]):

        if (PerHit := Int[Stat_Value]):
            if (Use_Limited_Resource = false):
                Billboard_Device.SetText(StringToMessage("Level: {level} \n {HitCount} / {Initial_Level_Need} \n Per Hit: {PerHit}"))
            else Billboard_Device.SetText(StringToMessage("\n{HitCount} / {Hits_To_Destroy}\nPer Hit: {PerHit}"))
            
        Players := GetPlayspace().GetPlayers()
        InitUI(Players)
        spawn { Helper.UpdateBillboardRotation(Players, Billboard_Device) }

    InitUI(Players : []player) : void =
        ValueText.SetVisibility(widget_visibility.Hidden)
        MoneyStatImage.SetVisibility(widget_visibility.Hidden)
        EnergyStatImage.SetVisibility(widget_visibility.Hidden)
        GemstoneStatImage.SetVisibility(widget_visibility.Hidden)
        WoodStatImage.SetVisibility(widget_visibility.Hidden)
        StoneStatImage.SetVisibility(widget_visibility.Hidden)
        MetalStatImage.SetVisibility(widget_visibility.Hidden)

        set ValueText = text_block: 
            DefaultText := StringToMessage("")
            DefaultTextColor := NamedColors.White
            DefaultShadowColor := NamedColors.Black
            DefaultShadowOffset := option { vector2 { X := 0.0, Y := 2.0 } }
            DefaultShadowOpacity := 0.0
            DefaultJustification := text_justification.Center
            DefaultTextSize := 50.0

        UIWidget : canvas = CreateUserUI()
        for (plr : Players):
            if (PlayerObj := player[plr], PlayerUI := GetPlayerUI[PlayerObj]):
                PlayerUI.AddWidget(UIWidget)

    CreateUserUI<private>() : canvas =
        UICanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                    Alignment := vector2{X := 0.5, Y := 0.5 }
                    SizeToContent := true
                    ZOrder := 30
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := ValueText
                canvas_slot:
                    Widget := MoneyStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := EnergyStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := GemstoneStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := WoodStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := StoneStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := MetalStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}
                canvas_slot:
                    Widget := MoneyStatImage
                    Anchors := anchors:
                        Minimum := vector2{X := 0.55, Y := 0.5}
                        Maximum := vector2{X := 0.55, Y := 0.5}    

    ShowHideUIText()<suspends> : void =
        ValueText.SetVisibility(widget_visibility.Visible)
        ValueText.SetShadowOpacity(1.0)
        Sleep(0.5)
        ValueText.SetVisibility(widget_visibility.Hidden)
        ValueText.SetShadowOpacity(0.0)

    ShowHideUITextures()<suspends> : void =
        if (Stat_Type = BasicStatEnum.Money):
            MoneyStatImage.SetVisibility(widget_visibility.Visible)
            Print("Money UI")
        if (Stat_Type = BasicStatEnum.Energy):
            EnergyStatImage.SetVisibility(widget_visibility.Visible)
            Print("Energy UI")
        if (Stat_Type = BasicStatEnum.Gemstone):
            GemstoneStatImage.SetVisibility(widget_visibility.Visible)
            Print("Gem UI")
        if (Stat_Type = BasicStatEnum.Wood):
            WoodStatImage.SetVisibility(widget_visibility.Visible)
            Print("Wood UI")
        if (Stat_Type = BasicStatEnum.Stone):
            StoneStatImage.SetVisibility(widget_visibility.Visible)
            Print("Stone")
        if (Stat_Type = BasicStatEnum.Metal):
            MetalStatImage.SetVisibility(widget_visibility.Visible)
            Print("Metal UI")
        Sleep(0.5)
        if (Stat_Type = BasicStatEnum.Money):
            MoneyStatImage.SetVisibility(widget_visibility.Hidden)
        if (Stat_Type = BasicStatEnum.Energy):
            EnergyStatImage.SetVisibility(widget_visibility.Hidden)
        if (Stat_Type = BasicStatEnum.Gemstone):
            GemstoneStatImage.SetVisibility(widget_visibility.Hidden)
        if (Stat_Type = BasicStatEnum.Wood):
            WoodStatImage.SetVisibility(widget_visibility.Hidden)
        if (Stat_Type = BasicStatEnum.Stone):
            StoneStatImage.SetVisibility(widget_visibility.Hidden)
        if (Stat_Type = BasicStatEnum.Metal):
            MetalStatImage.SetVisibility(widget_visibility.Hidden)

    ShowHitbox(Agent : ?agent) : void = if (Hitbox_Prop.TeleportTo[InitialPosition, InitialRotation]):
    

    OnHit(Agent : agent) : void =
        if (Stat_Type = BasicStatEnum.Wood) { StatHandler.IncreaseWood(Agent, Stat_Value), Print("Wood") }
        if (Stat_Type = BasicStatEnum.Stone) { StatHandler.IncreaseStone(Agent, Stat_Value), Print("Stone") }
        if (Stat_Type = BasicStatEnum.Metal) { StatHandler.IncreaseMetal(Agent, Stat_Value), Print("Metal") }
        if (Stat_Type = BasicStatEnum.Money) { StatHandler.IncreaseMoney(Agent, Stat_Value), Print("Money") }
        if (Stat_Type = BasicStatEnum.Energy) { StatHandler.IncreaseEnergy(Agent, Stat_Value), Print("Energy") }
        if (Stat_Type = BasicStatEnum.Gemstone) { StatHandler.IncreaseGemstone(Agent, Stat_Value), Print("Gems") }
        
        Accolade.Award(Agent)
        spawn{StatHandler.IncreaseExp(Agent, Level_Increase)}
        EVENT_Hitbox_Hit_Trigger.Trigger(Agent)
        set HitCount += 1

        if (Use_Limited_Resource = false):
            if (PerHit := Int[Stat_Value]):
                Billboard_Device.SetText(StringToMessage("Level: {level} \n {HitCount} / {Initial_Level_Need} \n Per Hit: {PerHit}"))
                ValueText.SetText(StringToMessage("+{PerHit}"))
            if (HitCount = Initial_Level_Need):
                if (NewLevelNeed := Int[Initial_Level_Need * Level_Point_Multiplier]) { set Initial_Level_Need = NewLevelNeed }
                set Stat_Value = Stat_Value * Stat_Multiplier
                set level += 1
                set HitCount = 0
                if (PerHit := Int[Stat_Value]):
                    set Stat_Value = IntToFloat(PerHit)
                    Billboard_Device.SetText(StringToMessage("Level: {level} \n {HitCount} / {Initial_Level_Need} \n Per Hit: {PerHit}"))
                    ValueText.SetText(StringToMessage("+{PerHit}"))
            spawn { ShowHideUIText() }, spawn { ShowHideUITextures() }
        else:
            if (PerHit := Int[Stat_Value]):
                if (HitCount = Hits_To_Destroy):
                    spawn{PropDestruction()}
                    set HitCount = 0
                Billboard_Device.SetText(StringToMessage("\n{HitCount} / {Hits_To_Destroy}\nPer Hit: {PerHit}"))
                ValueText.SetText(StringToMessage("+{PerHit}"))
                spawn { ShowHideUIText() }, spawn { ShowHideUITextures() }

    PropDestruction() <suspends> : void =
        if (Hitbox_Prop.TeleportTo[HiddenPosition, InitialRotation]):
        Sleep(Respawn_Time)
        if (Hitbox_Prop.TeleportTo[InitialPosition, InitialRotation]):
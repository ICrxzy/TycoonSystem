using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

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
 This script handles the exchanging of one stat type to another.
#>

Resource_Exchange := class(creative_device):
    @editable:
        ToolTip := StatHandlerToolTip # The Stat_Handler.verse creative device placed in the level.
    StatHandler : Stat_Handler = Stat_Handler{}
    @editable:
        ToolTip := NeedTip # The stat required to convert.
    Stat_Needed : BasicStatEnum = BasicStatEnum.Money
    @editable:
        ToolTip := GiveTip # The stat given after conversion.
    Stat_Given : BasicStatEnum = BasicStatEnum.Energy
    @editable:
        ToolTip := REVisTip # Wether or not the exchange is visible on start.
    Visible_At_Start : logic = true
    @editable:
        ToolTip := ConvertTip # The amount needed to convert this stat.
    Value_Needed : float = 100.0
    @editable:
        ToolTip := ExchangeTip # The amount given to the player when converted.
    Value_To_Give : float = 50.0
    @editable:
        ToolTip := REXPTip # The level stat given when exchanged.
    Level_Stat_Increase : float = 5.0
    @editable:
        ToolTip := REAccoladeTip # Accolades device granted when exchanged.
    Accolade : accolades_device = accolades_device{}
    @editable:
        ToolTip := BtnTip # Button devices used to make an exchange attempt.
    Exchange_Button : button_device = button_device{}
    @editable:
        ToolTip := REFundsTip # HUD Message device to display purchase status to the players UI.
    Funds_Message : hud_message_device = hud_message_device{}
    @editable:
        ToolTip := REInfoBoardTip # Billboard device used to display exchange information.
    Billboard_Device : billboard_device = billboard_device{}
    @editable:
        ToolTip := REShowTip # Incoming trigger event to show the exchange information.
    Show_Exchange_Trigger : trigger_device = trigger_device{}

    # These variables contain the buy pad transform. Allowing for easy showing and hiding of the buy pad prop, and its children.
    var InitialTransform : transform = transform{}
    var InitialPosition : vector3 = vector3{}
    var InitialRotation : rotation = rotation{}
    var HiddenPosition : vector3 = vector3{}
    var ExchangedStr : string = ""
    var ConvertedStr : string = ""

    OnBegin <override>()<suspends> : void = 
        SetTexts()
        Show_Exchange_Trigger.TriggeredEvent.Subscribe(ShowItem)
        Exchange_Button.InteractedWithEvent.Subscribe(AttemptExchange)
        Players := GetPlayspace().GetPlayers()

    ShowItem(Agent : ?agent) : void = if (Exchange_Button.TeleportTo[InitialPosition, InitialRotation]):
    SetTexts() : void =
        set InitialTransform = Exchange_Button.GetTransform()
        set InitialPosition = InitialTransform.Translation
        set InitialRotation = InitialTransform.Rotation
        set HiddenPosition = InitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}

        if (Visible_At_Start = false):
            if (Exchange_Button.TeleportTo[HiddenPosition, InitialRotation]):
        else:
            if (Exchange_Button.TeleportTo[InitialPosition, InitialRotation]):

        if (PriceInt := Int[Value_Needed]):
            if (IncomeInt := Int[Value_To_Give]): 
                Exchange_Button.SetInteractionText(StringToMessage("Exchange {ExchangedStr} for {ConvertedStr}"))
                Billboard_Device.SetText(StringToMessage("{PriceInt}\nFor\n{IncomeInt}"))

    AttemptExchange(Agent : agent) : void = 
        if (Stat_Needed = BasicStatEnum.Money):
            if (PlayerStat := StatHandler.GetMoneyStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_Needed = BasicStatEnum.Energy):
            if (PlayerStat := StatHandler.GetEnergyStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_Needed = BasicStatEnum.Gemstone):
            if (PlayerStat := StatHandler.GetGemstoneStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_Needed = BasicStatEnum.Wood):
            if (PlayerStat := StatHandler.GetWoodStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_Needed = BasicStatEnum.Stone):
            if (PlayerStat := StatHandler.GetStoneStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_Needed = BasicStatEnum.Metal):
            if (PlayerStat := StatHandler.GetMetalStatValue[Agent]):
                if (PriceInt := Int[Value_Needed]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)

    PurchaseSuccessful(Agent : agent): void =
        Accolade.Award(Agent)

        if (Stat_Needed = BasicStatEnum.Money):
            StatHandler.DecreaseMoney(Agent, Value_Needed)
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} E-Bucks"
        else if (Stat_Needed = BasicStatEnum.Energy):  
            StatHandler.DecreaseEnergy(Agent, Value_Needed) 
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} Energy"
        else if (Stat_Needed = BasicStatEnum.Gemstone): 
            StatHandler.DecreaseGemstone(Agent, Value_Needed) 
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} Gemstones"
        if (Stat_Needed = BasicStatEnum.Wood):
            StatHandler.DecreaseWood(Agent, Value_Needed)
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} Wood"
        else if (Stat_Needed = BasicStatEnum.Stone):  
            StatHandler.DecreaseStone(Agent, Value_Needed) 
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} Stone"
        else if (Stat_Needed = BasicStatEnum.Metal): 
            StatHandler.DecreaseMetal(Agent, Value_Needed) 
            if(IntValue := Int[Value_Needed]):
                set ExchangedStr = "{IntValue} Metal"
    
        if (Stat_Given = BasicStatEnum.Money):
            StatHandler.IncreaseMoney(Agent, Value_To_Give)
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} E-Bucks."
        else if (Stat_Given = BasicStatEnum.Energy):  
            StatHandler.IncreaseEnergy(Agent, Value_To_Give) 
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} Energy."
        else if (Stat_Given = BasicStatEnum.Gemstone): 
            StatHandler.IncreaseGemstone(Agent, Value_To_Give) 
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} Gemstones."
        if (Stat_Given = BasicStatEnum.Wood):
            StatHandler.IncreaseWood(Agent, Value_To_Give)
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} Wood."
        else if (Stat_Given = BasicStatEnum.Stone):  
            StatHandler.IncreaseStone(Agent, Value_To_Give) 
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} Stone."
        else if (Stat_Given = BasicStatEnum.Metal): 
            StatHandler.IncreaseMetal(Agent, Value_To_Give) 
            if(IntValue := Int[Value_To_Give]):
                set ConvertedStr = "{IntValue} Metal."

    PurchaseFailed(Agent : agent): void = Funds_Message.Show(StringToMessage("Insufficient Funds."))
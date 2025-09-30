using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }

Resource_Exchange := class(creative_device):
    @editable StatHandler : Stat_Handler = Stat_Handler{}
    @editable Exchange_Button : button_device = button_device{}
    @editable Funds_Message : hud_message_device = hud_message_device{}
    @editable Info_Board : billboard_device = billboard_device{}

    @editable Amount_Needed_to_Convert : float = 0.0
    @editable Amount_Granted_After_Convert : float = 0.0
    @editable Stat_To_Convert : StatEnum = StatEnum.Money
    @editable Stat_To_Exchange : StatEnum = StatEnum.Energy
    @editable XP_To_Give : float = 0.0

    var Stat_Scope : ?StatScope = false

    OnBegin <override>()<suspends> : void = 
        SetTexts
        Exchange_Button.InteractedWithEvent.Subscribe(AttemptExchange)
        Players := GetPlayspace().GetPlayers()

    SetTexts() : void =
        if (Stat_To_Convert = StatEnum.Money):
            if (PriceInt := Int[Amount_Needed_to_Convert]):
                if (IncomeInt := Int[Amount_Granted_After_Convert]):
                    Exchange_Button.SetInteractionText(StringToMessage("Exchange {PriceInt} E-Bux for {IncomeInt} Energy."))
                    Info_Board.SetText(StringToMessage("{PriceInt}\n\n{IncomeInt}"))
        else if (Stat_To_Convert = StatEnum.Energy):
            if (PriceInt := Int[Amount_Needed_to_Convert]):
                if (IncomeInt := Int[Amount_Granted_After_Convert]): 
                    Exchange_Button.SetInteractionText(StringToMessage("Exchange {PriceInt} Energy for {IncomeInt} E-Bux."))
                    Info_Board.SetText(StringToMessage("{PriceInt}\nFor\n{IncomeInt}"))
        else if (Stat_To_Convert = StatEnum.Gemstone):
            if (PriceInt := Int[Amount_Needed_to_Convert]):
                if (IncomeInt := Int[Amount_Granted_After_Convert]): 
                    Exchange_Button.SetInteractionText(StringToMessage("Exchange {PriceInt} Gemstones for {IncomeInt} E-Bux."))
                    Info_Board.SetText(StringToMessage("{PriceInt}\nFor\n{IncomeInt}"))
        else if (Stat_To_Convert = StatEnum.Rebirth):
            if (PriceInt := Int[Amount_Needed_to_Convert]):
                if (IncomeInt := Int[Amount_Granted_After_Convert]): 
                    Exchange_Button.SetInteractionText(StringToMessage("Exchange {PriceInt} Rebirths for {IncomeInt} E-Bux."))
                    Info_Board.SetText(StringToMessage("{PriceInt}\nFor\n{IncomeInt}"))

    AttemptExchange(Agent : agent) : void = 
        if (Stat_To_Convert = StatEnum.Money):
            if (PlayerStat := StatHandler.GetMoneyStatValue[Agent]):
                if (PriceInt := Int[Amount_Needed_to_Convert]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_To_Convert = StatEnum.Energy):
            if (PlayerStat := StatHandler.GetEnergyStatValue[Agent]):
                if (PriceInt := Int[Amount_Needed_to_Convert]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_To_Convert = StatEnum.Gemstone):
            if (PlayerStat := StatHandler.GetGemstoneStatValue[Agent]):
                if (PriceInt := Int[Amount_Needed_to_Convert]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)
        else if  (Stat_To_Convert = StatEnum.Rebirth):
            if (PlayerStat := StatHandler.GetRebirthStatValue[Agent]):
                if (PriceInt := Int[Amount_Needed_to_Convert]):
                    if (PlayerStat >= PriceInt) { PurchaseSuccessful(Agent) }
                    else PurchaseFailed(Agent)

    PurchaseSuccessful(Agent : agent): void =
        var ExchangedStr : string = ""
        var ConvertedStr : string = ""

        if (Stat_To_Convert = StatEnum.Money):
            StatHandler.DecreaseMoney(Agent, Amount_Needed_to_Convert)
            if(IntValue := Int[Amount_Needed_to_Convert]):
                set ExchangedStr = "{IntValue} E-Bucks"
        else if (Stat_To_Convert = StatEnum.Energy):  
            StatHandler.DecreaseEnergy(Agent, Amount_Needed_to_Convert) 
            if(IntValue := Int[Amount_Needed_to_Convert]):
                set ExchangedStr = "{IntValue} Energy"
        else if (Stat_To_Convert = StatEnum.Gemstone): 
            StatHandler.DecreaseGemstone(Agent, Amount_Needed_to_Convert) 
            if(IntValue := Int[Amount_Needed_to_Convert]):
                set ExchangedStr = "{IntValue} Gemstones"
    
        if (Stat_To_Exchange = StatEnum.Money):
            StatHandler.IncreaseMoney(Agent, Amount_Granted_After_Convert)
            if(IntValue := Int[Amount_Granted_After_Convert]):
                set ConvertedStr = "{IntValue} E-Bucks."
        else if (Stat_To_Exchange = StatEnum.Energy):  
            StatHandler.IncreaseEnergy(Agent, Amount_Granted_After_Convert) 
            if(IntValue := Int[Amount_Granted_After_Convert]):
                set ConvertedStr = "{IntValue} Energy."
        else if (Stat_To_Exchange = StatEnum.Gemstone): 
            StatHandler.IncreaseGemstone(Agent, Amount_Granted_After_Convert) 
            if(IntValue := Int[Amount_Granted_After_Convert]):
                set ConvertedStr = "{IntValue} Gemstones."

    PurchaseFailed(Agent : agent): void = Funds_Message.Show(StringToMessage("Insufficient Funds."))
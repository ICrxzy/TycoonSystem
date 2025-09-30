using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org }
using { /Verse.org/Random }
using { /Verse.org/Simulation }

Buyable_Item := class(creative_device):
    @editable StatHandler : Stat_Handler = Stat_Handler{}
    @editable ItemProp : creative_prop = creative_prop{}
    @editable PadProp : creative_prop = creative_prop{}

    @editable Buy_Trigger : trigger_device = trigger_device{}
    @editable Show_Pad_Trigger : trigger_device = trigger_device{}
    @editable Funds_Message : hud_message_device = hud_message_device{}
    @editable Info_Board : billboard_device = billboard_device{}

    @editable var Pad_Visible : logic = false
    @editable Buyable_Name : string = "Item"
    @editable Price : float = 0.0
    @editable Income : float = 0.0
    @editable Stat_To_Buy : StatEnum = StatEnum.Money
    @editable Stat_To_Give : StatEnum = StatEnum.Energy
    @editable XP_To_Give : float = 0.0
    @editable EVENT_Purchased : trigger_device = trigger_device{}

    var Purchased : logic = false
    var Stat_Scope : ?StatScope = false
    var CT : transform = transform{}
    var UpPos : vector3 = vector3{}
    var DownPos : vector3 = vector3{}

    OnBegin <override>()<suspends> : void = 
        set Stat_Scope = option{StatHandler.GetStatScope()}
        ItemProp.Hide()
        set CT = Info_Board.GetTransform()
        set UpPos = vector3{X := CT.Translation.X, Y := CT.Translation.Y, Z := CT.Translation.Z}
        set DownPos = vector3{X := CT.Translation.X, Y := CT.Translation.Y, Z := CT.Translation.Z - 500.0}
        
        if (Pad_Visible = true):
            ShowBillboard, Buy_Trigger.Enable(), PadProp.Show()
        else HideBillboard, Buy_Trigger.Disable(), PadProp.Hide()

        Players := GetPlayspace().GetPlayers()
        if (PriceInt := Int[Price]):
            if (IncomeInt := Int[Income]) { Info_Board.SetText(StringToMessage("{Buyable_Name}\n${PriceInt}\n\n+{IncomeInt}/s")) }         
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }
        Buy_Trigger.TriggeredEvent.Subscribe(BuyAttempt)
        Show_Pad_Trigger.TriggeredEvent.Subscribe(ShowPad)
        
    ShowPad(Agent : ?agent) : void = 
        set Pad_Visible = true
        Buy_Trigger.Enable(), PadProp.Show(), ShowBillboard

    PurchaseSuccessful(Agent : agent) : void =
        set Purchased = true
        EVENT_Purchased.Trigger()

        if (Stat_To_Buy = StatEnum.Money){ StatHandler.DecreaseMoney(Agent, Price) }
        if (Stat_To_Buy = StatEnum.Energy) { StatHandler.DecreaseEnergy(Agent, Price) }
        if (Stat_To_Buy = StatEnum.Gemstone) { StatHandler.DecreaseGemstone(Agent, Price) }

        StatHandler.IncreaseExp(Agent, XP_To_Give)
        spawn { GrantIncomeLoop(Agent) }
        HandlePurchase(500.0)
        
    ShowBillboard() : void = if (Info_Board.TeleportTo[UpPos, CT.Rotation]):
    HideBillboard() : void = if (Info_Board.TeleportTo[DownPos, CT.Rotation]):
        
    HandlePurchase(Amount : float) : void =
        Funds_Message.Show(StringToMessage("Puchase Successful"))
        ItemProp.Show(), PadProp.Hide(), HideBillboard

    PurchaseFailed(Agent : agent) : void = Funds_Message.Show(StringToMessage("Insufficient Funds"))
        
    BuyAttempt(Agent : ?agent) : void =
        if  (Stat_To_Buy = StatEnum.Money):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetMoneyStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Energy):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetEnergyStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Gemstone):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetGemstoneStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Rebirth):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetRebirthStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)

    GrantIncomeLoop(Agent : agent) <suspends> : void =
        if (Stat_To_Give = StatEnum.Money) { loop { Sleep(1.0), StatHandler.IncreaseMoney(Agent, Income) } }
        else if (Stat_To_Give = StatEnum.Energy) { loop { Sleep(1.0), StatHandler.IncreaseEnergy(Agent, Income) } }
        else if (Stat_To_Give = StatEnum.Gemstone) { loop { Sleep(1.0), StatHandler.IncreaseGemstone(Agent, Income) } }
        else if (Stat_To_Give = StatEnum.Rebirth) { loop { Sleep(1.0), StatHandler.GrantRebirth(Agent) } }

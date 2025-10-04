using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
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
 Buyable_Item.verse is responsible for the handling, purchasing, and unlocking of tycoon objects.
 #>

Buyable_Item := class(creative_device):
    @editable:
        ToolTip := StatHandlerToolTip # The Stat_Handler.verse creative device placed in the level.
    StatHandler : Stat_Handler = Stat_Handler{}
    @editable:
        ToolTip := ItemPropsTip # Item props to be spawned when this is purchased.
    Item_Props : []creative_prop = array{}

    @editable:
        ToolTip := NameTip # The name of the purchasable prop to show on the billboard.
    Buyable_Name : string = "Item" 
    @editable:
        ToolTip := Stat2BuyTip # The stat required to purchase this item.
    Stat_To_Buy : StatEnum = StatEnum.Money
    @editable:
        ToolTip := Stat2GiveTip # The stat to give when this item is purchased.
    Stat_To_Give : StatEnum = StatEnum.Energy
    @editable:
        ToolTip := StatFuelTip # If Require_Fuel is on, Determines which stat is used as fuel.
    Fuel_Stat : BasicStatEnum = BasicStatEnum.Wood
    @editable:
        ToolTip := PadVisTip # Wether or not the pad is visible at game start.
    var Pad_Visible : logic = false 
    @editable:
        ToolTip := FuelTip # Wether or not income generation requires fuel.
    Require_Fuel : logic = false 
    @editable:
        ToolTip := DoCOTTip # Wether or not the this item has a resource drain effect.
    Do_Cost_Over_Time : logic = false 
    @editable:
        ToolTip := PriceTip # The price to purchase this item.
    Price : float = 50.0 
    @editable:
        ToolTip := IncomeTip # The income provided by this item every second when purchased.
    Income : float = 2.0
    @editable:
        ToolTip := COTTip # If Cost_Over_Time is on, The amount of stat drained per second.
    Cost_Over_Time : float = 0.0 
    @editable:
        ToolTip := FuelCostTip # If Require_Fuel is on, The cost to refuel.
    Refuel_Cost : float = 0.0 
    @editable:
        ToolTip := EmptyFuelTip # If Require_Fuel is on, The length of time it takes for the fuel to empty.
    var Time_Before_Empty : float = 0.0 
    @editable:
        ToolTip := BIXPTip # The amount of level stat to increase when purchased.
    XP_To_Give : float = 25.0

    @editable:
        ToolTip := PadPropTip # Buypad used by the player to purchase this.
    Pad_Prop : creative_prop = creative_prop{}
    @editable:
        ToolTip := BIAccoladeTip # The accolades devices to award when this item is purchased.
    Accolade : accolades_device = accolades_device{}
    @editable:
        ToolTip := EventPurchasedTip # Outgoing event trigger to signal when this item purchased.
    EVENT_Purchased : trigger_device = trigger_device{}
    @editable:
        ToolTip := BuyTrigTip # The trigger used to purchase this. | Activated by player.
    Buy_Trigger : trigger_device = trigger_device{}
    @editable:
        ToolTip := ShowPadTip # The trigger to show the buypad of this device. | commonly used with the EVENT_Purchased trigger of another Buyable_Item.
    Show_Pad_Trigger : trigger_device = trigger_device{}
    @editable:
        ToolTip := FuelBtnTip # The button device used to refuel this item.
    Refuel_Button : button_device = button_device{}
    @editable:
        ToolTip := BIFundsTip # HUD Element to show players the purchase status of this item.
    Funds_Message : hud_message_device = hud_message_device{}
    @editable:
        ToolTip := BIInfoBoardTip # The billboard used to to display to the player information about this item.
    Info_Board : billboard_device = billboard_device{}
    @editable:
        ToolTip := BIInfoBoardTip # The billboard used to to display to the player information about this item.
    Fuel_Info_Board : billboard_device = billboard_device{}

    # These variables contain the buy pad transform. Allowing for easy showing and hiding of the buy pad prop, and its children.
    var PadInitialTransform : transform = transform{}
    var FuelBoardInitialTransform : transform = transform{}

    var PadInitialPosition : vector3 = vector3{}
    var FuelBoardInitialPosition : vector3 = vector3{}

    var PadHiddenPosition : vector3 = vector3{}
    var FuelBoardHiddenPosition : vector3 = vector3{}

    var PadInitialRotation : rotation = rotation{}
    var FuelBoardInitialRotation : rotation = rotation{}

    var Multiplier : float = 0.0

    OnBegin <override>()<suspends> : void = 
        set PadInitialTransform = Pad_Prop.GetTransform()
        set FuelBoardInitialTransform = Fuel_Info_Board.GetTransform()

        set PadInitialPosition = PadInitialTransform.Translation
        set FuelBoardInitialPosition = FuelBoardInitialTransform.Translation

        set PadInitialRotation = PadInitialTransform.Rotation
        set FuelBoardInitialRotation = FuelBoardInitialTransform.Rotation

        set PadHiddenPosition = PadInitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}
        set FuelBoardHiddenPosition = FuelBoardInitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}

        for (ItemProp : Item_Props):
            ItemProp.Hide()

        if (Pad_Visible = true) {ShowPad()}
        else HidePad()
        HideFuelInfo()

        Fuel_Info_Board.SetText(StringToMessage(""))
        Players := GetPlayspace().GetPlayers()
        if (PriceInt := Int[Price]):
            if (IncomeInt := Int[Income]): 
                if(IntCostOT := Int[Cost_Over_Time]):
                    if (Do_Cost_Over_Time = false):
                        if (Stat_To_Give = StatEnum.Rebirth):
                            Info_Board.SetText(StringToMessage("{Buyable_Name}\n{PriceInt}\n\n+{IncomeInt}")) 
                        else Info_Board.SetText(StringToMessage("{Buyable_Name}\n{PriceInt}\n\n+{IncomeInt}/s")), Print("{Buyable_Name} | Buyable Type: Normal")
                    else Info_Board.SetText(StringToMessage("{Buyable_Name}\n{PriceInt}\n-{IntCostOT}/s\n\n+{IncomeInt}/s"))
                
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }
        Buy_Trigger.TriggeredEvent.Subscribe(BuyAttempt)
        Show_Pad_Trigger.TriggeredEvent.Subscribe(ShowPadTriggered)

    ShowPadTriggered(Agent : ?agent): void = ShowPad()

    ShowPad() : void =  
        if (Pad_Prop.TeleportTo[PadInitialPosition, PadInitialRotation]):
        Buy_Trigger.Enable()
    HidePad() : void = 
        if (Pad_Prop.TeleportTo[PadHiddenPosition, PadInitialRotation]):
        Buy_Trigger.Disable()
    ShowFuelInfo() : void =  
        if (Fuel_Info_Board.TeleportTo[FuelBoardInitialPosition, FuelBoardInitialRotation]):
        Refuel_Button.Enable()
    HideFuelInfo() : void =  
        if (Fuel_Info_Board.TeleportTo[FuelBoardHiddenPosition, FuelBoardInitialRotation]):
        Refuel_Button.Disable()

    PurchaseSuccessful(Agent : agent) : void =
        EVENT_Purchased.Trigger()
        Accolade.Award(Agent)

        if (Stat_To_Buy = StatEnum.Money){ StatHandler.DecreaseMoney(Agent, Price) }
        if (Stat_To_Buy = StatEnum.Energy) { StatHandler.DecreaseEnergy(Agent, Price) }
        if (Stat_To_Buy = StatEnum.Gemstone) { StatHandler.DecreaseGemstone(Agent, Price) }
        
        spawn{StatHandler.IncreaseExp(Agent, XP_To_Give)}
        spawn { CheckIncomeLoop(Agent) }
        if (Require_Fuel = true) { ShowFuelInfo() }
        HandlePurchase()
        HidePad()
        
    HandlePurchase() : void =
        Funds_Message.Show(StringToMessage("Puchase Successful"))
        for (ItemProp : Item_Props):
            ItemProp.Show()

    PurchaseFailed(Agent : agent) : void = 
        Funds_Message.Show(StringToMessage("Insufficient Funds"))
        
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
        else if  (Stat_To_Buy = StatEnum.Wood):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetWoodStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Stone):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetStoneStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Metal):
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetMetalStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)

    CheckIncomeLoop(Agent : agent)<suspends> : void =
        var CurrentFuel : float = Time_Before_Empty
        loop:
            if (Require_Fuel = true):
                if (Int[CurrentFuel] > 0):
                    Refuel_Button.Disable()
                    GrantIncome(Agent)
                    Sleep(1.0)
                    set CurrentFuel -= 1.0
                    if (IntFuel := Int[CurrentFuel]):
                        Fuel_Info_Board.SetText(StringToMessage("TIME LEFT\n{IntFuel}"))
                else:
                    if (IntFuel := Int[Refuel_Cost]):
                        Fuel_Info_Board.SetText(StringToMessage("NEEDS FUEL\n{IntFuel}"))
                    Refuel_Button.Enable()
                    Refuel_Button.InteractedWithEvent.Await()
                    if (Fuel_Stat = BasicStatEnum.Gemstone):
                        if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseGemstone(Agent, Refuel_Cost)
                    else if (Fuel_Stat = BasicStatEnum.Energy):
                        if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseEnergy(Agent, Refuel_Cost)
                    else if (Fuel_Stat = BasicStatEnum.Money):
                        if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseMoney(Agent, Refuel_Cost)
                    else if (Fuel_Stat = BasicStatEnum.Wood):
                        if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseWood(Agent, Refuel_Cost)
                    else if (Fuel_Stat = BasicStatEnum.Stone):
                        if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseStone(Agent, Refuel_Cost)
                    else if (Fuel_Stat = BasicStatEnum.Metal):
                        if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                            if (StatValue >= Int[Refuel_Cost]):
                                set CurrentFuel = Time_Before_Empty
                                StatHandler.DecreaseMetal(Agent, Refuel_Cost)
            else Sleep(1.0), GrantIncome(Agent)
    
    GrantIncome(Agent : agent) : void =
        if (Rebirths := StatHandler.GetRebirthStatValue[Agent]):
            set Multiplier = 1.0 + (Rebirths * StatHandler.GetRebirthMult())
        if (Stat_To_Give = StatEnum.Money):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Gemstone):
                    StatHandler.DecreaseGemstone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Energy):
                    StatHandler.DecreaseEnergy(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Wood):
                    StatHandler.DecreaseWood(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Stone):
                    StatHandler.DecreaseStone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Metal):
                    StatHandler.DecreaseMetal(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income * Multiplier)
            else StatHandler.IncreaseMoney(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Energy):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Gemstone):
                    StatHandler.DecreaseGemstone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Money):
                    StatHandler.DecreaseMoney(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Wood):
                    StatHandler.DecreaseWood(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Stone):
                    StatHandler.DecreaseStone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Metal):
                    StatHandler.DecreaseMetal(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income * Multiplier)
            else StatHandler.IncreaseEnergy(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Gemstone):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Energy):
                    StatHandler.DecreaseEnergy(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Money):
                    StatHandler.DecreaseMoney(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Wood):
                    StatHandler.DecreaseWood(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Stone):
                    StatHandler.DecreaseStone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Metal):
                    StatHandler.DecreaseMetal(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income * Multiplier)
            else StatHandler.IncreaseGemstone(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Wood):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Energy):
                    StatHandler.DecreaseEnergy(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseWood(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Money):
                    StatHandler.DecreaseMoney(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseWood(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Gemstone):
                    StatHandler.DecreaseGemstone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseWood(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Stone):
                    StatHandler.DecreaseStone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseWood(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Metal):
                    StatHandler.DecreaseMetal(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseWood(Agent, Income * Multiplier)
            else StatHandler.IncreaseWood(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Stone):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Energy):
                    StatHandler.DecreaseEnergy(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseStone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Money):
                    StatHandler.DecreaseMoney(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseStone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Gemstone):
                    StatHandler.DecreaseGemstone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseStone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Wood):
                    StatHandler.DecreaseWood(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseStone(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Metal):
                    StatHandler.DecreaseMetal(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMetalStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseStone(Agent, Income * Multiplier)
            else StatHandler.IncreaseStone(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Metal):
            if (Do_Cost_Over_Time = true):
                if (Stat_To_Buy = StatEnum.Energy):
                    StatHandler.DecreaseEnergy(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMetal(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Money):
                    StatHandler.DecreaseMoney(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMetal(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Gemstone):
                    StatHandler.DecreaseGemstone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMetal(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Wood):
                    StatHandler.DecreaseWood(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetWoodStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMetal(Agent, Income * Multiplier)
                if (Stat_To_Buy = StatEnum.Stone):
                    StatHandler.DecreaseStone(Agent, Cost_Over_Time)
                    if (StatValue := StatHandler.GetStoneStatValue[Agent]):
                        if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMetal(Agent, Income * Multiplier)
            else StatHandler.IncreaseMetal(Agent, Income * Multiplier)

        else if (Stat_To_Give = StatEnum.Rebirth):
            spawn{ StatHandler.GrantRebirth(Agent) }
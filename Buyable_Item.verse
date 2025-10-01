using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
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
    More documentation coming soon
 #>

Buyable_Item := class(creative_device):
    # Device Connections
    @editable StatHandler : Stat_Handler = Stat_Handler{} # The stat handler device
    @editable ItemProp : creative_prop = creative_prop{} # The cosmetic item the player will buy
    @editable PadProp : creative_prop = creative_prop{} # The buy prop object the player uses to buy this
    @editable Buy_Trigger : trigger_device = trigger_device{} # The trigger attached to the buy pad
    @editable Show_Pad_Trigger : trigger_device = trigger_device{} # The trigger to show the pad of this device
    @editable Funds_Message : hud_message_device = hud_message_device{} # HUD Element for showing purchase status
    @editable Info_Board : billboard_device = billboard_device{} # Billboard device attached to the buy pad prop

    # User Variables
    @editable var Pad_Visible : logic = false # Determines if the buy pad is visible at the start
    @editable Stat_To_Buy_Uses_Siphon : logic = false # Determines if this pad will instead cost stat over time
    @editable Buyable_Name : string = "Item" # The name of the cosmetic prop
    @editable Price : float = 0.0 # The price of this buyable
    @editable Income : float = 0.0 # The amount of income given when this is bought
    @editable Stat_To_Buy : StatEnum = StatEnum.Money # The stat used to purchase this item
    @editable Stat_To_Give : StatEnum = StatEnum.Energy  # The stat given after purchasing this item
    @editable XP_To_Give : float = 0.0 # The amount of level stat given when purchased
    @editable EVENT_Purchased : trigger_device = trigger_device{} # An event sent out to signal that this item has been purchased

    # These variables contain the buy pad transform. Allowing for easy showing and hiding of the buy pad prop, and its children.
    var InitialTransform : transform = transform{}
    var InitialPosition : vector3 = vector3{}
    var InitialRotation : rotation = rotation{}
    var HiddenPosition : vector3 = vector3{}

    OnBegin <override>()<suspends> : void = 
        Print("Begin Sequence.")
        set InitialTransform = PadProp.GetTransform()
        set InitialPosition = InitialTransform.Translation
        set InitialRotation = InitialTransform.Rotation
        set HiddenPosition = InitialPosition + vector3{X := 0.0, Y := 0.0, Z := -500.0}
        ItemProp.Hide()

        if (Pad_Visible = true) {ShowPad()}
        else HidePad()

        Players := GetPlayspace().GetPlayers()
        if (PriceInt := Int[Price]):
            if (IncomeInt := Int[Income]): 
                if (Stat_To_Buy_Uses_Siphon = false):
                    if (Stat_To_Give = StatEnum.Rebirth):
                        Print("{Buyable_Name} | Buyable Type: Rebirth")
                        Info_Board.SetText(StringToMessage("{Buyable_Name}\n{PriceInt}\n\n+{IncomeInt}")) 
                    else Info_Board.SetText(StringToMessage("{Buyable_Name}\n{PriceInt}\n\n+{IncomeInt}/s")), Print("{Buyable_Name} | Buyable Type: Normal")
                else Info_Board.SetText(StringToMessage("{Buyable_Name}\n-{PriceInt}/s\n\n+{IncomeInt}/s"))
                
        spawn { Helper.UpdateBillboardRotation(Players, Info_Board) }
        Buy_Trigger.TriggeredEvent.Subscribe(BuyAttempt)
        Show_Pad_Trigger.TriggeredEvent.Subscribe(ShowPadTriggered)

    ShowPadTriggered(Agent : ?agent): void = ShowPad()

    ShowPad() : void =  
        if (PadProp.TeleportTo[InitialPosition, InitialRotation]){Print("Teleported Pad.")}
        else Print("Failed to teleport Pad.")
        Print("Enabling Buy Pad Trigger.")
        Buy_Trigger.Enable()
    HidePad() : void = 
        if (PadProp.TeleportTo[HiddenPosition, InitialRotation]){Print("Teleported Pad.")}
        else Print("Failed to teleport Pad.")
        Print("Disabling Buy Pad Trigger.")
        Buy_Trigger.Disable()

    PurchaseSuccessful(Agent : agent) : void =
        EVENT_Purchased.Trigger()
        Print("{Buyable_Name} | Successful Purchase!")

        if(Stat_To_Buy_Uses_Siphon = false):
            if (Stat_To_Buy = StatEnum.Money){ StatHandler.DecreaseMoney(Agent, Price), Print("{Buyable_Name} | Decreasing Money") }
            if (Stat_To_Buy = StatEnum.Energy) { StatHandler.DecreaseEnergy(Agent, Price), Print("{Buyable_Name} | Decreasing Energy") }
            if (Stat_To_Buy = StatEnum.Gemstone) { StatHandler.DecreaseGemstone(Agent, Price), Print("{Buyable_Name} | Decreasing Gemstones") }

        spawn{StatHandler.IncreaseExp(Agent, XP_To_Give)}
        Print("{Buyable_Name} | Giving Exp: {XP_To_Give}")
        spawn { GrantIncomeLoop(Agent) }
        Print("{Buyable_Name} | Starting Income Loop")
        HandlePurchase()
        HidePad()
        
    HandlePurchase() : void =
        Print("{Buyable_Name} | Purchase Successfully made.")
        Funds_Message.Show(StringToMessage("Puchase Successful"))
        ItemProp.Show()

    PurchaseFailed(Agent : agent) : void = 
        Funds_Message.Show(StringToMessage("Insufficient Funds")), Print("{Buyable_Name} | Insufficient Funds")
        
    BuyAttempt(Agent : ?agent) : void =
        Print("{Buyable_Name} | Purchase Attempt")
        if  (Stat_To_Buy = StatEnum.Money):
            Print("{Buyable_Name} | Stat needed = Money")
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetMoneyStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Energy):
            Print("{Buyable_Name} | Stat needed = Energy")
            if (ValidAgent := Agent?):
                if (PlayerStat := StatHandler.GetEnergyStatValue[ValidAgent]):
                    if (PriceInt := Int[Price]):
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent) }
                        else PurchaseFailed(ValidAgent)
        else if  (Stat_To_Buy = StatEnum.Gemstone):
            Print("{Buyable_Name} | Stat needed = Gemstones")
            if (ValidAgent := Agent?):
                Print("{Buyable_Name} / Gemstone | Agent Found.")
                if (PlayerStat := StatHandler.GetGemstoneStatValue[ValidAgent]):
                    Print("{Buyable_Name} / Gemstone | Player Stat Found {PlayerStat}.")
                    if (PriceInt := Int[Price]):
                        Print("{Buyable_Name} / Gemstone | Price found {PriceInt}.")
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent), Print("{Buyable_Name} / Gemstone | Successful Purchase.") }
                        else PurchaseFailed(ValidAgent), Print("{Buyable_Name} / Gemstone | Not Enough Rebirths.")
        else if  (Stat_To_Buy = StatEnum.Rebirth):
            Print("{Buyable_Name} | Stat needed = Rebirths")
            if (ValidAgent := Agent?):
                Print("{Buyable_Name} / Rebirth | Agent Found.")
                if (PlayerStat := StatHandler.GetRebirthStatValue[ValidAgent]):
                    Print("{Buyable_Name} / Rebirth | Player Stat Found {PlayerStat}.")
                    if (PriceInt := Int[Price]):
                        Print("{Buyable_Name} / Rebirth | Price found {PriceInt}.")
                        if (PlayerStat >= PriceInt) { PurchaseSuccessful(ValidAgent), Print("{Buyable_Name} / Rebirth | Successful Purchase.") }
                        else PurchaseFailed(ValidAgent), Print("{Buyable_Name} / Rebirth | Not Enough Rebirths.")

    GrantIncomeLoop(Agent : agent) <suspends> : void =
        if (Stat_To_Give = StatEnum.Money):
            if (Stat_To_Buy_Uses_Siphon = true):
                loop:
                    Sleep(1.0)
                    if (Stat_To_Buy = StatEnum.Gemstone):
                        StatHandler.DecreaseGemstone(Agent, Price)
                        if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income)
                    if (Stat_To_Buy = StatEnum.Energy):
                        StatHandler.DecreaseEnergy(Agent, Price)
                        if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseMoney(Agent, Income)
            else loop{ Sleep(1.0), StatHandler.IncreaseMoney(Agent, Income)}   

        else if (Stat_To_Give = StatEnum.Energy):
            if (Stat_To_Buy_Uses_Siphon = true):
                loop:
                    Sleep(1.0)
                    if (Stat_To_Buy = StatEnum.Gemstone):
                        StatHandler.DecreaseGemstone(Agent, Price)
                        if (StatValue := StatHandler.GetGemstoneStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income)
                    if (Stat_To_Buy = StatEnum.Money):
                        StatHandler.DecreaseMoney(Agent, Price)
                        if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseEnergy(Agent, Income)
            else loop{ Sleep(1.0), StatHandler.IncreaseEnergy(Agent, Income)} 

        else if (Stat_To_Give = StatEnum.Gemstone):
            if (Stat_To_Buy_Uses_Siphon = true):
                loop:
                    Sleep(1.0)
                    if (Stat_To_Buy = StatEnum.Energy):
                        StatHandler.DecreaseEnergy(Agent, Price)
                        if (StatValue := StatHandler.GetEnergyStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income)
                    if (Stat_To_Buy = StatEnum.Money):
                        StatHandler.DecreaseMoney(Agent, Price)
                        if (StatValue := StatHandler.GetMoneyStatValue[Agent]):
                            if (StatValue >= Int[Price]):
                            StatHandler.IncreaseGemstone(Agent, Income)
            else loop{ Sleep(1.0), StatHandler.IncreaseGemstone(Agent, Income)} 

        else if (Stat_To_Give = StatEnum.Rebirth):
            StatHandler.GrantRebirth(Agent)

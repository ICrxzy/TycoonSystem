using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
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
 The main script responsible for Increasing, Decreasing, and managing stat values. 
    Supports a rebirth system via an end game method. 
#>

StatEnum<public> := enum {Money, Energy, Gemstone, Rebirth}
StatScope<public> := enum {Agent, Match}

Stat_Handler<public> := class(creative_device):
    @editable Money_Stat_Device : stat_creator_device = stat_creator_device{} # The main currency stat type (Can be Match or Agent scope)
    @editable Energy_Stat_Device : stat_creator_device = stat_creator_device{} # The secondary Currency stat type (Can be Match or Agent scope)
    @editable Level_Stat_Device : stat_creator_device = stat_creator_device{} # The Level stat type (Must be Agent scope)
    @editable Gemstone_Stat_Device : stat_creator_device = stat_creator_device{} # The premium currency stat type (Must be Agent scope)
    @editable Rebirth_Stat_Device : stat_creator_device = stat_creator_device{} # The rebirth currency stat type (Must be Agent Scope)
    @editable Stat_Scope : StatScope = StatScope.Match # Set wether or not the Primary, and Secondary stats are set to Match, or Agent scope
    @editable End_Game_Device : end_game_device = end_game_device{} # The device used to end the game upon player rebirth

    # Getters for Stat Devices (For any niche adjustments)
    GetMoneyStatDevice<public>()<transacts> : stat_creator_device = return Money_Stat_Device
    GetEnergyStatDevice<public>()<transacts> : stat_creator_device = return Energy_Stat_Device
    GetLevelStatDevice<public>()<transacts> : stat_creator_device = return Level_Stat_Device
    GetGemstoneStatDevice<public>()<transacts> : stat_creator_device = return Gemstone_Stat_Device
    GetRebirthStatDevice<public>()<transacts> : stat_creator_device = return Rebirth_Stat_Device

    # Getters for stat values
    GetMoneyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Money_Stat_Device.GetValueForMatch[]
        else return Money_Stat_Device.GetValue[Agent]
    GetEnergyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Energy_Stat_Device.GetValueForMatch[]
        else return Energy_Stat_Device.GetValue[Agent]
    GetGemstoneStatValue<public>(Agent : agent)<decides><transacts> : int = return Gemstone_Stat_Device.GetValue[Agent]
    GetRebirthStatValue<public>(Agent : agent)<decides><transacts> : int = return Rebirth_Stat_Device.GetValue[Agent]

    # Increase or Decrease the Primary Stat Value
    IncreaseMoney<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Money_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Money_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseMoney<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Money_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Money_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Secondary Stat Value
    IncreaseEnergy<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Energy_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Energy_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseEnergy<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Energy_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Energy_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Premium Stat Value
    IncreaseGemstone<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Gemstone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Gemstone_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Gemstone_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Gemstone_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseGemstone<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Gemstone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Gemstone_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Gemstone_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Gemstone_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}
            
    # Grant a rebirth point
    GrantRebirth<public>(Agent : agent)<suspends> : void =
        Print("SH | Granting Rebirth")
        if (StatValue := Rebirth_Stat_Device.GetValue[Agent]):
            Print("SH | Current Value: {StatValue}")
            if (Rebirth_Stat_Device.SetValue[Agent, StatValue + 1]){}
        Print("SH | Granted Rebirth. Ending game in 3")
        Sleep(1.0)
        Print("SH | 2")
        Sleep(1.0)
        Print("SH | 1")
        Sleep(1.0)
        Print("SH | Ending Game")
        End_Game_Device.Activate(Agent)
            
    # Increase the Level stat value
    IncreaseExp<public>(Agent : agent, Amount : float)<suspends> : void =
        Rand := GetRandomFloat(0.001, 0.025)
        Sleep(Rand)
        if (StatValue := Level_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
            if (Level_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
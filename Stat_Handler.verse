using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }
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
 The main script responsible for Increasing, Decreasing, and managing stat values. 
    Supports a rebirth system via an end game method. 
#>

StatEnum<public> := enum {Money, Energy, Gemstone, Wood, Stone, Metal, Rebirth}
BasicStatEnum<public> := enum {Money, Energy, Gemstone, Wood, Stone, Metal}
StatScope<public> := enum {Agent, Match}

Stat_Handler<public> := class(creative_device):
    @editable:
        ToolTip := MoneyStatTip # The Primary Stat device. | This stat can be either Agent or Match in scope.
    Money_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := EnergyStatTip # The Secondary Stat device. | This stat can be either Agent or Match in scope.
    Energy_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := LevelStatTip # The Level Stat device. | This stat MUST be Match in scope.
    Level_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := GemStatTip # The Premium Stat device. | This stat MUST be Match in scope.
    Gemstone_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := RebirthStatTip # The Rebirth Stat device. | This stat MUST be Match in scope.
    Rebirth_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := WoodStatTip # The Wood Stat device. | This stat can be either Agent or Match in scope.
    Wood_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := StoneStatTip # The Stone Stat device. | This stat can be either Agent or Match in scope.
    Stone_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := MetalStatTip # The Metal Stat device. | This stat can be either Agent or Match in scope.
    Metal_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable:
        ToolTip := StatScopeTip # Wether the Primary, & Secondary stats are using Agent, or Match scope.
    Currency_Stat_Scope : StatScope = StatScope.Match
    @editable:
        ToolTip := MatStatTip # Wether the Material stats are using Agent, or Match scope.
    Material_Stat_Scope : StatScope = StatScope.Match
    @editable:
        ToolTip := EndGameTip  # The End Game Device used to goto the next round upon player rebirth.
    End_Game_Device : end_game_device = end_game_device{}
    @editable:
        ToolTip := RebirthMultTip # The Multiplier per rebirth to be given for income generation. | Final Income = Income * Mult = Income * (1.0 + (RebirthCount * RebirthMult))
    Rebirth_Multiplier : float = 0.05

    # Getters for Stat Devices (For any niche adjustments)
    GetMoneyStatDevice<public>()<transacts> : stat_creator_device = return Money_Stat_Device
    GetEnergyStatDevice<public>()<transacts> : stat_creator_device = return Energy_Stat_Device
    GetLevelStatDevice<public>()<transacts> : stat_creator_device = return Level_Stat_Device
    GetGemstoneStatDevice<public>()<transacts> : stat_creator_device = return Gemstone_Stat_Device
    GetRebirthStatDevice<public>()<transacts> : stat_creator_device = return Rebirth_Stat_Device
    GetWoodStatDevice<public>()<transacts> : stat_creator_device = return Wood_Stat_Device
    GetStoneStatDevice<public>()<transacts> : stat_creator_device = return Stone_Stat_Device
    GetMetalStatDevice<public>()<transacts> : stat_creator_device = return Metal_Stat_Device
    GetRebirthMult<public>()<transacts> : float = return Rebirth_Multiplier

    # Getters for stat values
    GetMoneyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Currency_Stat_Scope = StatScope.Match):
            return Money_Stat_Device.GetValueForMatch[]
        else return Money_Stat_Device.GetValue[Agent]
    GetEnergyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Currency_Stat_Scope = StatScope.Match):
            return Energy_Stat_Device.GetValueForMatch[]
        else return Energy_Stat_Device.GetValue[Agent]
    GetWoodStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Material_Stat_Scope = StatScope.Match):
            return Wood_Stat_Device.GetValueForMatch[]
        else return Wood_Stat_Device.GetValue[Agent]
    GetStoneStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Material_Stat_Scope = StatScope.Match):
            return Stone_Stat_Device.GetValueForMatch[]
        else return Stone_Stat_Device.GetValue[Agent]
    GetMetalStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Material_Stat_Scope = StatScope.Match):
            return Metal_Stat_Device.GetValueForMatch[]
        else return Metal_Stat_Device.GetValue[Agent]
    GetGemstoneStatValue<public>(Agent : agent)<decides><transacts> : int = return Gemstone_Stat_Device.GetValue[Agent]
    GetRebirthStatValue<public>(Agent : agent)<decides><transacts> : int = return Rebirth_Stat_Device.GetValue[Agent]

    # Increase or Decrease the Primary Stat Value
    IncreaseMoney<public>(Agent : agent, Amount : float) : void =
        if (Currency_Stat_Scope = StatScope.Agent):
            if (StatValue := Money_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Money_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseMoney<public>(Agent : agent, Amount : float) : void =
        if (Currency_Stat_Scope = StatScope.Agent):
            if (StatValue := Money_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Money_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Money_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Secondary Stat Value
    IncreaseEnergy<public>(Agent : agent, Amount : float) : void =
        if (Currency_Stat_Scope = StatScope.Agent):
            if (StatValue := Energy_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Energy_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseEnergy<public>(Agent : agent, Amount : float) : void =
        if (Currency_Stat_Scope = StatScope.Agent):
            if (StatValue := Energy_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Energy_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Energy_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Wood Stat Value
    IncreaseWood<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Wood_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Wood_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Wood_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Wood_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseWood<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Wood_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Wood_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Wood_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Wood_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Stone Stat Value
    IncreaseStone<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Stone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Stone_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Stone_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Stone_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseStone<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Stone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Stone_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Stone_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Stone_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Metal Stat Value
    IncreaseMetal<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Metal_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Metal_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Metal_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Metal_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseMetal<public>(Agent : agent, Amount : float) : void =
        if (Material_Stat_Scope = StatScope.Agent):
            if (StatValue := Metal_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Metal_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Metal_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Metal_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}

    # Increase or Decrease the Premium Stat Value
    IncreaseGemstone<public>(Agent : agent, Amount : float) : void =
        if (StatValue := Gemstone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
            if (Gemstone_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
    DecreaseGemstone<public>(Agent : agent, Amount : float) : void =
        if (StatValue := Gemstone_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
            if (Gemstone_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
            
    # Grant a rebirth point
    GrantRebirth<public>(Agent : agent)<suspends> : void =
        if (StatValue := Rebirth_Stat_Device.GetValue[Agent]):
            if (Rebirth_Stat_Device.SetValue[Agent, StatValue + 1]){}
        Sleep(1.0)
        End_Game_Device.Activate(Agent)
            
    # Increase the Level stat value
    IncreaseExp<public>(Agent : agent, Amount : float)<suspends> : void =
        Rand := GetRandomFloat(0.001, 0.025)
        Sleep(Rand)
        if (StatValue := Level_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
            if (Level_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
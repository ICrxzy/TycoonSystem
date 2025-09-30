using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

StatEnum<public> := enum {Money, Energy, Gemstone, Rebirth}
StatScope<public> := enum {Agent, Match}

Stat_Handler<public> := class(creative_device):
    @editable Money_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable Energy_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable Level_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable Gemstone_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable Rebirth_Stat_Device : stat_creator_device = stat_creator_device{}
    @editable Stat_Scope : StatScope = StatScope.Match
    @editable End_Game_Device : end_game_device = end_game_device{}

    GetMoneyStatDevice<public>()<transacts> : stat_creator_device = return Money_Stat_Device
    GetEnergyStatDevice<public>()<transacts> : stat_creator_device = return Energy_Stat_Device
    GetLevelStatDevice<public>()<transacts> : stat_creator_device = return Level_Stat_Device
    GetGemstoneStatDevice<public>()<transacts> : stat_creator_device = return Gemstone_Stat_Device
    GetRebirthStatDevice<public>()<transacts> : stat_creator_device = return Rebirth_Stat_Device
    GetStatScope<public>()<transacts> : StatScope = return Stat_Scope

    GetMoneyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Money_Stat_Device.GetValueForMatch[]
        else return Money_Stat_Device.GetValue[Agent]

    GetEnergyStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Energy_Stat_Device.GetValueForMatch[]
        else return Energy_Stat_Device.GetValue[Agent]

    GetGemstoneStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Gemstone_Stat_Device.GetValueForMatch[]
        else return Gemstone_Stat_Device.GetValue[Agent]

    GetRebirthStatValue<public>(Agent : agent)<decides><transacts> : int = 
        if (Stat_Scope = StatScope.Match):
            return Rebirth_Stat_Device.GetValueForMatch[]
        else return Rebirth_Stat_Device.GetValue[Agent]

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
            
    GrantRebirth<public>(Agent : agent) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Rebirth_Stat_Device.GetValue[Agent]):
                if (Rebirth_Stat_Device.SetValue[Agent, StatValue + 1]){}
        else:
            if (StatValue := Rebirth_Stat_Device.GetValueForMatch[]):
                if (Rebirth_Stat_Device.SetValueForMatch[StatValue + 1]){}
        End_Game_Device.Activate(Agent)
            
    IncreaseExp<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Level_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Level_Stat_Device.SetValue[Agent, StatValue + MagnitudeInt]){}
        else:
            if (StatValue := Level_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Level_Stat_Device.SetValueForMatch[StatValue + MagnitudeInt]){}
    DecreaseExp<public>(Agent : agent, Amount : float) : void =
        if (Stat_Scope = StatScope.Agent):
            if (StatValue := Level_Stat_Device.GetValue[Agent], MagnitudeInt := Int[Amount]):
                if (Level_Stat_Device.SetValue[Agent, StatValue - MagnitudeInt]){}
        else:
            if (StatValue := Level_Stat_Device.GetValueForMatch[], MagnitudeInt := Int[Amount]):
                if (Level_Stat_Device.SetValueForMatch[StatValue - MagnitudeInt]){}
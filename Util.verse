
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
 Global utility script
#>

# Floors a float value down to a specified decimal place. (Min of 1 = 1.25, 2 = 1.259) Trailing zeros are avoided.
FloorToDecimalPlaces(Value:float, Decimals:int):string =
    if (Decimals <= 0) { return ToString(Value) }
    if (RoundedValue := Round[Value * Pow(10.0, Decimals * 1.0)] * 1.0 / Pow(10.0, Decimals * 1.0)) {
        if (IntValue := Int[Value]) { 
            if (IntValue * 1.0 = RoundedValue) { return ToString(IntValue) } 
        }
        if (IntPart := Int[Abs(RoundedValue)]) {
            if (DecimalPart := Int[Abs(RoundedValue) * Pow(10.0, Decimals * 1.0)]) {
                var DecimalPartString : string = ToString(DecimalPart)
                var DecimalPartLength : int = DecimalPartString.Length
                if (DecimalPartLength < Decimals) {
                    for (Index := 0..Decimals - DecimalPartLength - 1) { set DecimalPartString = "0" + DecimalPartString }
                }
                if (Value < 0.0) { return "-{IntPart}.{DecimalPartString}" }
                return "{IntPart}.{DecimalPartString}"
            }
        }
    }
    return ToString(Value)

# Your average conversion functions
StringToMessage <localizes> (String : string) : message = "{String}"
IntToFloat<public>(value: int)<computes> : float = value*1.0
FloatToInt<public>(value: float)<decides> : int = Ceil[value]
FloatToIntDown<public>(value: float)<decides> : int = Floor[value]

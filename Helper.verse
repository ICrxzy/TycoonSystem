using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
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
REMEMBER: Use <public> for functions you want to call from other scripts.
Pass any required parameters to the function.
This utility script is project based. Refer to Util.verse for global functions. 
#>

Helper<public> := module:
    UpdateBillboardRotation<public>(Players : []player, Info_Board : billboard_device)<suspends>:void =
        loop:
            Sleep(0.025)
            if (Players.Length = 0) { return }

            BillboardPos := Info_Board.GetTransform().Translation
            var ClosestDistance : float = 1000000.0
            var ClosestPlayerPos : vector3 = vector3{}

            for (Player : Players):
                if (Character := Player.GetFortCharacter[]):
                    PlayerPos := Character.GetTransform().Translation
                    DistanceToPlayer := Distance(BillboardPos, PlayerPos)
                    if (DistanceToPlayer < ClosestDistance):
                        set ClosestDistance = DistanceToPlayer
                        set ClosestPlayerPos = PlayerPos

            Direction := ClosestPlayerPos - BillboardPos
            YawRadians := ArcTan(Direction.Y, Direction.X)
            YawDegrees := RadiansToDegrees(YawRadians)
            FixedYawDegrees := YawDegrees + 90.0
            NewRotation := MakeRotationFromYawPitchRollDegrees(FixedYawDegrees, 0.0, 0.0)
            if (Info_Board.TeleportTo[BillboardPos, NewRotation]) {}
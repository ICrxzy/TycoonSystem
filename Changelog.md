<h1 align="center">Verse Tycoon Changelog</h1>

## *Version 0.31.0* | Untested
- Added three (3) new stat types. Wood, Stone, & Metal. 
- Changed `Stat_Scope` to `Currency_Stat_Scope`, & `Material_Stat_Scope`
	- Currency Stats are Money, & Energy.
	- Material Stats are Wood, Stone, & Metal.
- Added `Require_Fuel` toggle to `Buyable_Item.verse`
	- If set, when purchased; players will have to refuel the item in order to continue generating income.
	- `Fuel_Stat` determines the required stat to fuel this item.
	- `Refuel_Cost` determines how much of the required stat is needed to fuel this item.
	- `Time_Before_Empty` determines how long (In seconds) until the fuel becomes empty.
- Added tooltips to ALL options in the device interface.
	- This will help explain the options to those who don't care to learn how it works. 
- Rebirths can no longer be granted through the Hitbox, or Resource Exchange. 
	- Only buyable item pads can grant rebirths.
- Added `Visible_At_Start` toggles to the Hitbox, and Resource Exchange.
	- Also added an incoming event trigger to show the Hitbox, or Resource Exchange.
- Multiple items can now be added to a buy pad, allowing for much bigger purchases.
- Added VerseUI to `Hitbox.verse`
	- If you wish to do custom HUDs, the HUD Message device is still supported. 
- Maybe some more things I forgot to write down.
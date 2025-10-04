<h1 align="center">UEFN/Verse Tycoon Management System</h1>
<h3 align="center">A Work-in-progress project by Crxzy Creative.</h3>

<p align="center">
  <a href="https://github.com/ICrxzy/UEFN-Verse-WIP-Tycoon-System/blob/main/LICENSE"><img src="https://img.shields.io/badge/Code License-MIT-blue.svg" alt="Code License"></a>
  <a href="https://github.com/ICrxzy/UEFN-Verse-WIP-Tycoon-System/blob/main/LICENSE-CC-BY"><img src="https://img.shields.io/badge/Content License-CC BY 4.0-lightgrey.svg" alt="Content License"></a><br>
  <a href="https://medal.tv/games/fortnite/clips/lexpKxNtIj2B-NK_8?invite=cr-MSxqOWIsNDQ2NDE4MTU&v=102">Check out the DEMO video</a><br>
  Thanks for showing interest in my work!
</p>


<p align="center">
This script is considered my personal learning project.<br>
I'm open-sourcing this because it's not a very complex piece of code, and im still learning. <br>
I see no reason it should be kept under wraps.
</p>

<h2 align="center">Overview</h2>
<p align="center">
  This script will handle most functions of your typical tycoon experience.<br>
  Buypads, Hitboxes, and Resource Exchanging. All possible with this setup.<br>
  In depth detail can be found below, explaining the important user variables that the scripts use.<br>
  Many improvements are planned, and suggestions for additions are always welcome.<br>
</p>

<h1 align="center">Socials, & Support.</h1>
<p align="center">
  <a href="https://discord.gg/RWRhKyby5D"><img src="https://i.postimg.cc/JzVdXd3Z/Discord-Banner.png" alt="Discord.gg"></a>
  <a href="https://www.youtube.com/@CrxzyYT"><img src="https://i.postimg.cc/SxxVcF2q/YTBanner.png" alt="YouTube.com"></a>
  <a href="https://www.twitch.tv/itsrealcrxzy"><img src="https://i.postimg.cc/9FYCrTZh/TWITCH.png" alt="Twitch.tv"></a>
  <a href="https://x.com/ItsNotCrxzy"><img src="https://i.postimg.cc/2SSTnRbY/XCom-Banner.png" alt="X.com"></a>
  <a href="https://www.paypal.com/donate/?hosted_button_id=VWPG8MTMA3CSE"><img src="https://i.postimg.cc/fRR5Yn3G/Paypal.png" alt="Paypal.me"></a><br>
  Any donations made are optional, highly appreciated, and will support my creative journey.<br>
  Recieving donations allows me to continue to open source my work for the public.
</p>

<h1>Included Script Information</h1>
<h2>Buyable_Item.verse</h2>
<p>This script handles the purchasing and enabling of purchasable items in the tycoon. Features a buypad that must be stepped on to activate.<br><br>
<img width="473" height="637" alt="image" src="https://github.com/user-attachments/assets/569a721e-e298-4151-8083-c7987571e606" /><br>
<img width="212" height="145" alt="Buyable_Item.verse Outliner Setup" src="https://github.com/user-attachments/assets/97142fda-c111-4fe3-92a6-f921a42a2917" /> 
</p>

| Variable | Description |
| ------ | ------ |
| StatHandler | The `Stat_Handler.verse` creative device placed in the level. |
| Item_Props | Item props to be spawned when this is purchased. |
| Buyable_Name | The name of the purchasable prop to show on the billboard. |
| Stat_To_Buy | The stat required to purchase this item. |
| Stat_To_Give | The stat to give when this item is purchased. |
| Fuel_Stat | If `Require_Fuel` is on, Determines which stat is used as fuel.  |
| Pad_Visible | Wether or not the pad is visible at game start. |
| Require_Fuel | Wether or not income generation requires fuel. |
| Do_Cost_Over_Time | Wether or not the this item has a resource drain effect.  |
| Price | The price to purchase this item.  |
| Income | The income provided by this item every second when purchased. |
| Cost_Over_Time | If `Cost_Over_Time` is on, The amount of stat drained per second. |
| Refuel_Cost | If `Require_Fuel` is on, The cost to refuel. |
| Time_Before_Empty | If `Require_Fuel` is on, The length of time it takes for the fuel to empty. |
| XP_To_Give | The amount of level stat to increase when purchased.  |
| Pad_Prop | Buypad used by the player to purchase this. |
| Accolade | The accolades devices to award when this item is purchased. |
| EVENT_Purchased | Outgoing event trigger to signal when this item purchased. |
| Buy_Trigger | The trigger used to purchase this. | Activated by player. |
| Show_Pad_Trigger | The trigger to show the buypad of this device. | commonly used with the `EVENT_Purchased` trigger of another `Buyable_Item.` |
| Refuel_Button | The button device used to refuel this item. |
| Funds_Message | HUD Element to show players the purchase status of this item. |
| Info_Board | The billboard device displaying purchase information. |
| Fuel_Info_Board | If `Require_Fuel` is on, The billboard device displaying fuel information. |

<h2>Hitbox.verse</h2>
<p>This script is attached to a prop used as a hitbox. Upon being hit, it will grant the player a specified income per hit, that gets upgraded the more hits it recieves.<br><br>
<img width="461" height="490" alt="image" src="https://github.com/user-attachments/assets/728b0006-1580-4716-acd8-9eaef247f516" /><br>
<img width="298" height="128" alt="Hitbox.verse Outliner Setup" src="https://github.com/user-attachments/assets/4ee04bda-c6b4-4ee7-a29c-87e68cc9b5bf" />
</p>

| Variable | Description |
| ------ | ------ |
| StatHandler | The stat_handler.verse script. |
| Stat_Type | The type of stat to give the player when hit. |
| Use_Limited_Resource | BWhen set, turns this hitbox into a respawning, limited use type. (E.G Mining System) |
| Visible_At_Start | Wether or not this hitbox is visible when the game starts. |
| Hits_To_Destroy | If `Use_Limited_Resource` is on, The number of hits required to destroy this prop. |
| Initial_Level_Need | If `Use_Limited_Resource` is off, The number of hits needed to increase the level of the hitbox. |
| Respawn_Time | If `Use_Limited_Resource` is on, The time it takes for the hitbox to respawn when destroyed. |
| Stat_Value | The amount of stat to give the player when hit. |
| Level_Increase | The amount of level stat given to the player when hit. |
| Level_Point_Multiplier | If `Use_Limited_Resource` is off, Multiplies with Initial_Level_Need every time the hitbox levels up. |
| Stat_Multiplier | If `Use_Limited_Resource` is off, Multiplies with Stat_Value every time the hitbox levels up. |
| Hitbox_Prop | Hitbox prop that the player will hit to gain stat points. |
| Billboard_Device | Billboard_Device device to display hitbox information. |
| Custom_Message_Widget | HUD Message shown to the hitting player displaying income information. |
| Use_Custom_Widget | Wether or not the device should use the default UI, or a custom widget. |
| Hitbox_Manipulator | Prop Manipulator device attached to the Hitbox Prop. |
| Show_Hitbox_Trigger | Incoming event to show the hitbox. | Commonly used with the `EVENT_Purchased` trigger in the `Buyable_Item.verse` script. |
| Accolade | Accolades device awarded when hit. |
| EVENT_Hitbox_Hit_Trigger | Outgoing event for when the hitbox is hit by a player. |

<h2>Resource_Exchange.verse</h2>
<p>This script handles the conversion of one stat to another. Features configurable values for both.<br><br>
<img width="487" height="320" alt="image" src="https://github.com/user-attachments/assets/d7767289-f620-4dc5-bbcc-2ed014bb977c" /><br>
<img width="207" height="110" alt="Resource_Exchange.verse Outliner Setup" src="https://github.com/user-attachments/assets/c9cdf850-def9-48c4-8a59-3c2f044ce07b" />
</p>

| Variable | Description |
| ------ | ------ |
| StatHandler | The stat_handler.verse script. |
| Stat_Needed | The stat required to convert. |
| Stat_Given | The stat given after conversion. |
| Visible_At_Start | Wether or not the exchange is visible on start. |
| Value_Needed | The amount needed to convert this stat. |
| Value_To_Give | The amount given to the player when converted. |
| Level_Stat_Increase | The level stat given when exchanged. |
| Accolade | Accolades device granted when exchanged. |
| Exchange_Button | Button devices used to make an exchange attempt. |
| Funds_Message | HUD Message device to display purchase status to the players UI. |
| Billboard_Device | Billboard device used to display exchange information. |
| Show_Exchange_Trigger | Incoming trigger event to show the exchange information. |

<h2>Stat_Handler.verse</h2>
<p>This script handles the main functionality related to stat devices. Decreasing, Increasing, and Getting the stat values, or devices.<br><br>
<img width="484" height="316" alt="image" src="https://github.com/user-attachments/assets/74b04272-43f7-4d29-9a4c-a03e0744be56" />
</p>

| Variable | Description |
| ------ | ------ |
| Money_Stat_Device | The Primary stat device used. (Agent or Match Scope allowed) |
| Energy_Stat_Device | The Secondary Stat device used. (Agent or Match Scope allowed) |
| Level_Stat_Device | The level stat device used. (Must be Agent Scope) |
| Gemstone_Stat_Device | The Premium stat device used. (Must be Agent Scope) |
| Rebirth_Stat_Device | The Rebirth stat device used. (Must be Agent Scope) |
| Wood_Stat_Device | The Wood stat device used. (Agent or Match Scope allowed) |
| Stone_Stat_Device | The Stone Stat device used. (Agent or Match Scope allowed) |
| Metal_Stat_Device | The Metal Stat device used. (Agent or Match Scope allowed) |
| Currency_Stat_Scope | Wether the Primary, & Secondary stats are using Agent, or Match scope. |
| Material_Stat_Scope | Wether the Material stats are using Agent, or Match scope. |
| End_Game_Device | Device to end the game upon rebirth. |
| Income_Multiplier_Per_Rebirth | The Multiplier per rebirth to be given for income generation. | Final Income = Income * Mult = Income * (1.0 + (RebirthCount * RebirthMult)) |

<h2>Helper.verse</h2>
<p>This script is a project specific script that handles large or side functions that all scripts may or may not need to use.</p>

<h2>Util.verse</h2>
<p>A universal multi-project script featuring common utility functions like StringToMessage, or Variable conversions.</p>

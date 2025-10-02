# UEFN/Verse Tycoon Management System
### A Work-in-progress project by Crxzy Creative. 

*Thanks for showing interest in my work!*\
\
This is my first major verse scripting project so dont expect perfection.\
As of the initial snapshot (9/30/25) i have about a week of experience with verse.\
This project is my learning project.\
Expect the scripts to expand and become wider in scope as i add more configurations, and improvements.

If you wish to support me here are some common links: [YouTube](https://www.youtube.com/@CrxzyYT), [Twitch](https://www.twitch.tv/itsrealcrxzy), [Discord](https://discord.gg/RWRhKyby5D)\
If you are feeling particularly generous, my [PayPal](https://www.paypal.com/donate/?hosted_button_id=VWPG8MTMA3CSE).

Any donations made are optional, highly appreciated, and will support my creative journey.\
Recieving donations allows me to continue to open source my work for the public.

# Included Script Information
## `Buyable_Item.verse`
This script handles the purchasing and enabling of purchasable items in the tycoon. Features a buypad that must be stepped on to activate.\
<img width="512" height="464" alt="Buyable_Item.verse Variables" src="https://github.com/user-attachments/assets/c77722cb-5297-400b-b331-4d550d285078" />\
<img width="212" height="145" alt="Buyable_Item.verse Outliner Setup" src="https://github.com/user-attachments/assets/97142fda-c111-4fe3-92a6-f921a42a2917" /> 
| Variable | Description |
| ------ | ------ |
| StatHandler | The stat_handler.verse script. |
| Accolade | An accolades device to grant when purchased. |
| ItemProp | The prop the player will purchase. |
| PadProp | The buypad prop the player uses to purchase. |
| Buy_Trigger | Trigger attached to the buypad to purchase. Set to `Activated by Player`. |
| Show_Pad_Trigger | An incoming event to show the buypad, commonly used with another buyables `EVENT_Purchased` trigger.  |
| Funds_Message | A HUD Message device responsible for showing purchase status to the player. |
| Info_Board | Billboard device used to display buyable item information to the player. |
| Pad_Visible | Determines wether or not the buypad is visible at start.  |
| Do_Cost_Over_Time | Extra functionality allowing the buyable item to drain one resource type, for another.  |
| Buyable_Name | The name of the purchased prop. Will be shown on the Info_Board. |
| Price | The one time cost to purchase this item. |
| Income | The income generated per second. |
| Cost_Over_Time | If doing COT, The value subtracted from the players stat per second. |
| Stat_To_Buy | Enum variable used to determine the required stat to purchase this item.  |
| Stat_To_Give | Enum variable used to determine the stat given as income. |
| XP_To_Give | The level stat value granted when purchased. |
| EVENT_Purchased | Outgoing event trigger, commonly used to show another buypad. |

### `Hitbox.verse`
This script is attached to a prop used as a hitbox. Upon being hit, it will grant the player a specified income per hit, that gets upgraded the more hits it recieves.\
<img width="509" height="414" alt="Hitbox.verse Variables" src="https://github.com/user-attachments/assets/5b503a41-2aba-4ddf-a251-a0d27a005777" />\
<img width="298" height="128" alt="Hitbox.verse Outliner Setup" src="https://github.com/user-attachments/assets/4ee04bda-c6b4-4ee7-a29c-87e68cc9b5bf" />
| Variable | Description |
| ------ | ------ |
| StatHandler | The stat_handler.verse script. |
| Accolade | An accolades device to grant when purchased. |
| Info_Board | Billboard Device used to display Hitbox information to the player. |
| Hitbox_Prop | The prop used as the hitbox. |
| HUD_Message | The HUD Message device used to display the `PerHit` value on the HUD. |
| Hitbox_Manipulator | Manipulator device attached to the hitbox prop. |
| EVENT_Hitbox_Hit_Trigger | Outgoing trigger event for when the hitbox is damaged. |
| Use_Limited_Resource | Toggle for if the hitbox should be destroyed after reaching the `Hits_Before_Expire` value. |
| Hits_Before_Expire | If `Use_Limited_Resource` is true; The number of hits needed to destroy the hitbox. |
| Respawn_Time | The time it takes for the hitbox prop to respawn after being destroyed. |
| InitialLevelNeed | If `Use_Limited_Resource` is false; The number of hits needed to increase the level of the hitbox. |
| Stat_Value | The value `PerHit` of this hitbox. |
| Stat_Type | Enum variable for the stat given on hit. |
| XP_To_Give | The level stat value granted when purchased. |
| PPL_Multiplier | If `Use_Limited_Resource` is false; The Points Per Level multiplier, multiplied by the `InitialLevelNeed` on level up. |
| Stat_Multiplier | If `Use_Limited_Resource` is false; The multiplier used to increase the `PerHit` value on level up. |

### `Resource_Exchange.verse`
This script handles the conversion of one stat to another. Features configurable values for both.\
<img width="510" height="248" alt="Resource_Exchange.verse Variables" src="https://github.com/user-attachments/assets/bce90f0a-36ad-4176-8dc1-a205b2e15b85" />\
<img width="207" height="110" alt="Resource_Exchange.verse Outliner Setup" src="https://github.com/user-attachments/assets/c9cdf850-def9-48c4-8a59-3c2f044ce07b" />
| Variable | Description |
| ------ | ------ |
| StatHandler | The stat_handler.verse script. |
| Accolade | An accolades device to grant when purchased. |
| Exchange_Button | Button used to activate this device. |
| Funds_Message | HUD Element for displaying purchase status on players HUD. |
| Info_Board | Billboard device used to display exchange information. |
| Amount_Needed_to_Convert | The value of stat needed to convert. |
| Amount_Granted_After_Convert | The amount of stat granted after conversion. |
| Stat_To_Convert | Enum variable to determine which stat is needed to convert. |
| Stat_To_Exchange | Enum variable to determine which stat is granted after conversion. |
| XP_To_Give | The level stat value granted when purchased. |

### `Stat_Handler.verse`
This script handles the main functionality related to stat devices. Decreasing, Increasing, and Getting the stat values, or devices.\
<img width="504" height="220" alt="image" src="https://github.com/user-attachments/assets/34394da3-c543-4792-b847-5899bb261b53" />
| Variable | Description |
| ------ | ------ |
| Money_Stat_Device | The Primary stat device used. (Agent or Match Scope allowed) |
| Energy_Stat_Device | The Secondary Stat device used. (Agent or Match Scope allowed) |
| Level_Stat_Device | The level stat device used. (Must be Agent Scope) |
| Gemstone_Stat_Device | The Premium stat device used. (Must be Agent Scope) |
| Rebirth_Stat_Device | The Rebirth stat device used. (Must be Agent Scope) |
| Stat_Scope | Enum Variable to determine if the Primary and Secondary stats are Agent, or Match scope. |
| End_Game_Device | Device to end the game upon rebirth. |
| Income_Multiplier_Per_Rebirth | The income multipler per rebirth. (BuyableIncome * Mult) (Where Mult = 1.0 + (RebirthCount * Income_Multiplier_Per_Rebirth)) |

### `Helper.verse`
This script is a project specific script that handles large or side functions that all scripts may or may not need to use. 

### `Util.verse`
A universal multi-project script featuring common utility functions like StringToMessage, or Variable conversions. 

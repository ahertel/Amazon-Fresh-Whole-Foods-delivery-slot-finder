**Featured on [CNBC](https://www.cnbc.com/2020/04/08/how-to-get-a-amazon-fresh-whole-foods-delivery-timeslot.html)**

#### Quick Links
- [Download & Instructions](#instructions)
- [Disclaimer about 'disappearing' slots](#disclaimer-about-disappearing-slots)
- [Questions/feedback/issues](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/issues)
- [Track bugs/enhancements](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/projects)
- [Supporting me/Donations](#supporting-medonations)

# Amazon Fresh/Whole Foods Delivery Slot Finder
A Mac-only tool that finds available delivery slots for Amazon.com's Whole Foods delivery and Amazon Fresh services.

## DISCLAIMER about "disappearing" slots
No guarantee that slots will be found and/or that slots will work. Often you will select a slot but the page will refresh and the slot will disappear. These phantom slots are very common and are unfortunately in Amazon's control, not mine.  Eventually a slot should work. Some users report success of after 20+ tries. Wishing you resilience and hope! Feel free to post concerns in the [Issues](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/issues) section.

## Instructions
1. Read the [Compatibility](#compatibility) section below to make sure the tool will work for you
2. Download the 'delivery-window-finder.scpt' [here](https://github.com/ahertel/wholefoods-delivery-slot-finder/raw/master/delivery-window-finder.scpt)
3. Enable "Allow JavaScript from Apple Events". [How-to video](https://www.youtube.com/watch?v=S6zb_6yTAbo)
    1. Open Safari
    2. Safari menu -> **Preferences** -> **Advanced**
    3. Check **Show Develop menu in Menu Bar**
    4. You will now see a **Develop** menu in your menu bar
    5. Click **Allow Javascrupt from Apple Events** _(near the bottom of the menu)_
4. Log into your Amazon account in Safari
5. Fill your Whole Foods/Amazon Fresh cart with your complete order and proceed through the checkout process manually. Stop once you've arrived at the page saying no slots are available
6. Open delivery-window-finder.scpt in _Script Editor_ and click the 'Play' button to run it and follow the prompts
![run button](https://i.imgur.com/kpQee5h.png)
7. Turn up the volume to hear the notification when a slot is found
8. Once you receive your order, please consider tipping if you can. They are exposing themselves to risk to protect us. Thanks!

Notes:
The script will stop running if your computer falls asleep. You can adjust your 'Energy Saver' settings in System Preferences or download [Caffeine app](https://intelliscapesolutions.com/apps/caffeine) to keep your Mac awake.

## Compatibility
Currently **not compatible** with Whole Foods orders from primenow.amazon.com. Currently only compatible with Amazon Fresh and Whole Foods orders from amazon.com. Prime Now compatibility may be added eventually. Check [here](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/issues/23) for any progress.

**Before using this tool**, ensure that your checkout page looks **exactly** like the examples in the _Compatible_ section below.
This tool currently only works for some regions because Amazon's checkout pages seem to vary based on your location and I designed the tool based on the page I see in my region. 
If your checkout page doesn't look like the examples in the _Compatible_ or _Incompatible_ sections below, this tool may still work for you but no guarantees.

### Compatible
These are sample screenshots for delivery to a New Jersey address
#### Whole Foods
![Whole Foods](https://i.imgur.com/r7EQQF6.jpg)

#### Amazon Fresh
![Amazon Fresh](https://i.imgur.com/ncVyqQR.jpg)

### Incompatible
#### Amazon Fresh
##### 1.
![Santa Clara, CA](https://i.imgur.com/SyNtrZs.png)
##### 2.
![an unkown city in CA](https://i.imgur.com/PYrO9Il.jpg)


## How it works
- It opens the checkout page in a new window, minimizes it, and then refreshes every ~60 seconds in the background.
- Once it finds an open slot it alerts you by putting a notification on your screen and playing a sound, and opening the checkout page. You can choose to receive text messages when a slot is found
- You can choose to have the tool ignore out of stock notifications and continue searching uninterrupted
- Once you're notified, quickly select a slot and finish checking out because available slots are snagged almost instantly.

## Inspiration for this tool
The Coronavirus 2019 pandemic caused a surge in demand for grocery delivery services, making it nearly impossible to find an open delivery slot. My intention in providing this tool is first and foremost help those in need (e.g. at-risk people, health care workers) have an easier time staying safe. The idea came to me when I realized my parents, who both have auto-immune diseases, had been trying unsuccesfully for several days to get grocery delivery slots.

## Supporting me/Donations
Thank you so much for wanting to support me! I don't want anything in return for this tool - I'm just happy to be hearing all the stories about how this has helped people, especially those in need. That said, a [few](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/issues/19) people have wanted to donate. Please consider donating to [GiveDirectly](https://www.givedirectly.org/covid-19/) which directly pays affected families, or one of the [many other charities](https://www.forbes.com/sites/kellyphillipserb/2020/03/21/helping-out-during-the-coronavirus-crisis-where-what--how-to-donate/#6267520350df) addressing COVID-19.
If you'd like to support me directly: I am graduating from Georgetown Undergrad Business School in May and looking for a job opportunities so any introductions or leads would be greatly appreciated. Broadly speaking, I’m interested in the intersection of business/tech, including product management, operations, and business/data analytics. My [resume](https://drive.google.com/open?id=1Cb5uAHjFeg4GOb4Gr7jLkm3Ga9tK1OIT)

## Common Issues
- **"Safari got an error: can't get window id"** _Solution:_ Don't quit Safari, or close the window opened and minimized by the script. See [here](https://github.com/ahertel/Amazon-Fresh-Whole-Foods-delivery-slot-finder/issues/18) for more help.

A copy of the code is also available in .txt format. However, this copy might not be the most up to date version. The .scpt file is the most current and the one you should download if you want to run this tool.

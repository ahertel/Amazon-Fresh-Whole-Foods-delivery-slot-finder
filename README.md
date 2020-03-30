# Amazon Fresh/Whole Foods Delivery Slot Finder
An ApplesScript that finds available delivery slots for Amazon's Whole Foods delivery and Amazon Fresh services.

## How it works
It opens the checkout page in a new window, minimizes it, and then refreshes every ~60 seconds in the background. Once it finds an open slot it alerts you by putting a notification on your screen and playing a sound, and opening the checkout page. __So turn up the volume!__. Once you're notified, quickly select a slot and finish checking out because available slots are snagged almost instantly.

## Why use this?
The Coronavirus 2019 pandemic caused a surge in demand for grocery delivery services, making it nearly impossible to find an open delivery slot. Manually refreshing the page seemed too hard so I created this script to automate the search.

## Instructions
1. Read the [Compatibility](#compatibility) section below to make sure the tool will work for you
2. Download the 'delivery-window-finder.scpt' [here](https://github.com/ahertel/wholefoods-delivery-slot-finder/raw/master/delivery-window-finder.scpt)
3. Log into your Amazon account in Safari
4. Fill your Whole Foods/Amazon Fresh cart and try to checkout manually. Stop once you've arrived at the page saying no slots are available
5. Open delivery-window-finder.scpt in _Script Editor_ and click the 'Play' button to run it
![run button](https://i.imgur.com/kpQee5h.png)
6. Turn up the volume to hear the notification when a slot is found

## Compatibility
**Before using this tool**, ensure that your checkout page looks **exactly** like the examples in the _Compatible_ section below.
This tool currently only works for some regions of the US because Amazon's checkout pages seem to vary based on your location and I designed the tool based on the page I see in my region. 
If your checkout page doesn't look like the examples in the _Compatible_ or _Incompatible_ sections below, this tool may still work for you but no guarantees.

### Compatible
These are sample screenshots for delivery to a NJ address
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

Notes
-
It will open a new window with the amazon checkout page, and minimize that window so that it can run in the background.
You'll be notified when a slot frees up. Don't quit Safari or let your computer fall asleep, or the tool will stop running.
If you want it to run while you are away from your computer, I recommend downloading the [Caffeine app](http://lightheadsw.com/caffeine/) to keep your Mac awake, then turning the volume all the way up so you can hear when it finds a slot.

Slots seem to open up at midnight in each time zone, but also sometimes randomly during the day. I've gotten slots at 1:04pm and and 1:06am here in the EST time zone.

A copy of the code is also available in .txt format. However, this copy might not be the most up to date version. The .scpt file is the most current and the one you should download if you want to run this tool
on your Mac.

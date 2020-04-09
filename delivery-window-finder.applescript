-- VARIABLE DEFINITIONS

set found_slot to false
set oos_keyword to "We're sorry we are unable to fulfill your entire order"
set oos_msg to "click 'continue' on out of stock page before closing this dialog box"
set unknown_page_msg to "Unknown amazon page was loaded. try to manually navigate back to the 'Schedule your order page', and then run the program again"
set slot_site_url to "https://www.amazon.com/gp/buy/shipoptionselect/handlers/display.html?hasWorkingJavascript=1"
set slot_page_keyword to "Schedule your order"
set no_slot_keyword to "No delivery windows available"
set is_first_run to true
set auto_ignore_oos to true

set ignoreOosPromptMsg to "Amazon gives notices when items in your cart go out of stock.
Would you like the script to:
A. automatically ignore the warnings so it keep looking for slots (recommended)
B. stop searching for slots until you manually review what went out of stock?"

set wfm_cart_url to "https://www.amazon.com/cart/localmarket"
set fresh_cart_url to "https://www.amazon.com/cart/fresh"
set selected_cart_url to ""

-- for clicking functionality
set javascriptEnabled to false
set javascriptPermissionMsg to "The advanced features of this tool involve clicking on and navigating the Amazon website. The following permission MUST be enabled for this tool to run.

INSTRUCTIONS:
-
1. While in Safari, push Command-comma together to open Safari Preferences.
2. Go to the 'Advanced' page on the far right and enable 'Show develop menu in menu bar' at the very bottom.
3. Click 'Develop' in the menu bar at the top of the screen and click 'Allow Javascript from Apple Events' to enable it.
4. When finished, click 'Done' to proceed or 'Exit Script' to stop using this tool"

set configCompleteMsg to "The script will start searching for slots once you click 'Continue'. 

HOW DO I KNOW IT'S WORKING?
-
The tool will open and minimize a window once you click 'Continue'. It will quietly search in that window. You won't be get any notifications until A) a slot appears or B) an item goes out of stock and you selected to be notified. If you want to verify the script is running, you can open the minimized window and watch it open and close the slot page every ~60 seconds. You can then minimize the window again or leave it open. Just don't close it"

set welcomeMsg to "Welcome to Delivery Slot Search Tool!

INSTRUCTIONS:
-
1. Sign into Amazon.com in Safari
2. Fill your grocery cart
3. Manually start and continue the checkout process until you arrive at the delivery slot page. The session is now initialized. Close this slot page. It's no longer needed.
4. Turn up the volume to hear the announcement when a slot is found
5. Adjust your 'Energy Saver' settings in 'System Preferences' so the the display never turns off. Also plug in your laptop, if possible
6. Go to Safari. 
5. Read the DISCLAIMER
6. Click 'Continue'. After you answer the prompts, the tool will start searching for slots

DISCLAIMER:
-
No guarantee that slots will be found and/or that slots will work. Often you will select a slot but the page will refresh and the slot will disappear. These phantom slots are very common and are in Amazon's control, not mine.  Eventually a slot should work. Some users report success of after 20+ tries. Wishing you resilience and hope!
 
FEEDBACK:
-
Post any concerns/feedback on GitHub issue page"

-- Text Messaging variables
set promptForNumber to true
set sendTexts to false
set phoneNumber to ""
set dialogResult to false
set sendTextsPromptMsg to "Would you like to receive text messages when delivery slots appear?
Note: If you haven't previously used your Mac's 'Messages' app to send or receive texts, select 'No'"
set messageAppIconFilepath to "/System/Applications/Messages.app/Contents/Resources/MessagesAppIcon.icns"
set messageIconDialogPath to "System:Applications:Messages.app:Contents:Resources:MessagesAppIcon.icns"
set promptNumberMsg to "Please enter desired recipient phone number. Format: 10 digits, no symbols or spaces (e.x. 8002752273)"
set invalidNumberMsg to "Invalid phone number. Must be 10 digits without spaces or symbols. Click 'Ok' to enter it again or 'Cancel' to proceed without text notifications."
set deliverySlotFoundTextMsg to "Delivery slot appeared. Try to checkout. Slot availability does not guarantee order can be placed"


-- FUNCTIONS

-- Source for clicking clickClassName() and clickClassID(): https://www.cubemg.com/how-to-extract-information-from-a-website-using-applescript/
to clickClassName(theClassName, elementnum, tab_num, window_id)
	tell application "Safari"
		do JavaScript "document.getElementsByClassName('" & theClassName & "')[" & elementnum & "].click();" in tab tab_num of window id window_id
	end tell
end clickClassName

to clickID(theID, tab_num, window_id)
	tell application "Safari"
		do JavaScript "document.getElementById('" & theID & "').click();" in tab tab_num of window id window_id
	end tell
end clickID

-- if unknown page is encountered, this automatically navigates to back to the cart and then all the way to delivery slot page
to restartCheckout(selected_cart_url, window_id)
	log "attempting to return to slot page"
	-- TO-DO: check "if not on cart tab already" then load cart tab
	-- closes the tab so the tab can be reloaded and processed anew
	-- TO-DO: perhaps i can shorten this code by not closing and reopening a tab
	
	tell application "Safari"
		close (last tab of window id window_id)
		tell window id window_id
			make new tab with properties {URL:selected_cart_url}
			set current tab to last tab
		end tell
	end tell
	delay 20 -- wait for page to load. it doesn't take that long
	
	-- clicks the "Checkout Whole Foods Market Cart" button
	clickClassName("a-button-input", 0, -1, window_id)
	delay 5 -- wait for "before you checkout" to load
	clickClassName("a-button-text a-text-center", 0, -1, window_id)
	delay 5 -- wait for substitution preferences
	clickClassName("a-button-text a-text-center", 0, -1, window_id)
	delay 15 -- wait for slot page to load
	-- TO-DO: remove this load time if you are just gonna reload the page anyways or return to the top of the loop with a notice that the page has already been loaded
	-- before loop restarts. close last tab
	-- TO-DO: do a test to make sure we landed on the right page. if not, announce unknown error and exit loop
	tell application "Safari"
		close (last tab of window id window_id)
	end tell
end restartCheckout


-- USER PROMPTS:
-- 1. Welcome message w/ instructions & disclaimer
display dialog welcomeMsg with title "Welcome" with icon stop buttons {"Cancel", "Continue"} default button "Continue"

-- 2. Prompt whether to ignore oos or wait for user to review
display dialog ignoreOosPromptMsg buttons {"Cancel", "A. Keep looking for slots", "B. Wait for me to review"} default button "A. Keep looking for slots" with title "Ignore Out Of Stock?" with icon note

if result = {button returned:"A. Keep looking for slots"} then
	set auto_ignore_oos to true
else if result = {button returned:"B. Wait for me to review"} then
	set auto_ignore_oos to false
end if

display dialog javascriptPermissionMsg with title "More access needed" buttons {"End Script", "Done"} with icon stop default button "Done"
if result = {button returned:"Done"} then
	set javascriptEnabled to true
end if

if javascriptEnabled then
	-- 3. Prompt user to enable text message notifications
	-- TO-DO: consider converting this to a function
	repeat while promptForNumber is true
		-- checks if messages icon exists
		try
			-- Check if Messages.app icon can be found
			do shell script "/bin/ls " & messageAppIconFilepath
			-- if icon found, the prompt will include the Messages icon.
			set dialogResult to display dialog sendTextsPromptMsg buttons {"Cancel", "Yes", "No"} default button "Yes" with title "Text Notifications" with icon file (messageIconDialogPath)
		on error errMsg number errNum
			-- errNum 1 means messages icon not found. use generic icon
			if errNum = 1 then
				-- prompt without Messages.app icon
				set dialogResult to display dialog sendTextsPromptMsg buttons {"Cancel", "Yes", "No"} default button "Yes" with title "Text Notifications" with icon note
			else
				-- intentionally cancel the script if the caught error is any other code
				error number -128
			end if
			
		end try
		--set temp to file ("System:Applications:Messages.app:Contents:Resources:MessagesAppIcon.icns")
		if button returned of dialogResult = "Yes" then
			try
				set theResponse to display dialog promptNumberMsg default answer "" with icon note buttons {"Cancel", "Continue"} default button "Continue" with title "Recipient Phone Number"
				if button returned of theResponse = "Continue" then
					set temp to text returned of theResponse
					-- checks if proper format entered
					if the length of temp = 10 then
						set phoneNumber to temp
						set sendTexts to true
						set promptForNumber to false
						log "valid phone number entered"
					else
						display dialog invalidNumberMsg with title "Invalid Number" with icon caution
						log "invalid phone number entered"
						-- user will be reprompted for number
					end if
				end if
				
			on error errMsg number errorNumber
				-- if user clicked 'cancel' on the above dialogs it will be interpreted as them not wanting to send texts
				if errorNumber = -128 then
					log "user clicked cancel during phone number prompts"
					set sendText to false
					set promptForNumber to false
				else
					display dialog "An unknown error:" & errMsg & ". exiting the script. notify herteladrian@gmail.com" with title "Fatal Error" with icon stop
					-- intentionally cancel the script
					error number -128
				end if
			end try
		else if button returned of dialogResult = "No" then
			set promptForNumber to false
			log "user selected no text messaging"
		end if
	end repeat
	
	-- 4. Prompt for delivery service type
	set servicePrompt to display dialog "What delivery service do you want to use this script for?" buttons {"Cancel", "Whole Foods via Amazon.com", "Amazon Fresh"} with icon note with title "Which Service?"
	if button returned of servicePrompt = "Whole Foods via Amazon.com" then
		set selected_cart_url to wfm_cart_url
	else if button returned of servicePrompt = "Amazon Fresh" then
		set selected_cart_url to fresh_cart_url
	end if
	
	display dialog configCompleteMsg buttons {"Cancel", "Continue"} with title "Configuration Complete" with icon note default button "Continue"
	
	
	-- START SEARCH
	-- create new empty window, with one empty tab
	tell application "Safari"
		make new document
		delay 0.5 -- wait for new window to open
		-- instead of creating a new tab in your current window, this creates a window and 'hides it by minimizing it. apple script doesn't allow you to move tabs around, all new tabs are created. an alternate solution would be to get the unique id of the tab and access it that way instead of putting the tab in a new window
		set amzn_win_id to id of front window
	end tell
	
	repeat while found_slot is false
		-- load the delivery slot page
		tell application "Safari"
			-- opens in a new tab every time instead of just using open url request, which would prompt "Are you sure you want to send a form again?" and prevent this from running neatly in the background
			tell window id amzn_win_id
				make new tab with properties {URL:slot_site_url}
				set current tab to last tab
			end tell
			if is_first_run is true then
				-- minimizes window on the first iteration so it can run quietly in background
				set miniaturized of window id amzn_win_id to true
				set is_first_run to false
			end if
			
			-- wait for the page to load
			delay 30
			
			-- get the text on the page
			set siteText to (text of last tab of window id amzn_win_id) as string
		end tell
		
		-- PROCESS PAGE CONTENTS:
		
		-- no delivery slots available
		if siteText contains no_slot_keyword then
			
			-- closes the tab since no slot was found
			tell application "Safari"
				close (last tab of window id amzn_win_id)
			end tell
			
			log "no slots found"
			
			-- delay so you don't spam Amazon's site
			delay 10
		else if siteText contains oos_keyword then
			-- landed on out of stock page
			
			if auto_ignore_oos then
				-- click continue button to dismiss out of stock warning
				clickClassName("a-button-text", 0, -1, amzn_win_id)
				
				log "Items out of stock were ignored"
				say "ignored out of stock item"
				-- delay to wait for the next page to load(it might be another oos page or the delivery slot page
				delay 20
				
				-- closes the tab so the tab can be reloaded and processed anew
				tell application "Safari"
					close (last tab of window id amzn_win_id)
				end tell
				-- sometimes the site stuck on page with the same out of stock items, despite clicking continue and refreshing repeatedly. restarting the checkout process bypasses this hang up. To prevent getting stuck in the first place, the checkout process is restarted after every time the 'out of stock' page is encountered.
				restartCheckout(selected_cart_url, amzn_win_id)
			else
				say "Item out of stock. See pop up"
				display dialog oos_msg with title "Out of Stock" with icon caution
			end if
			
		else if siteText contains slot_page_keyword and (siteText contains "AM" or siteText contains "PM") then
			-- landed on delivery slot page and delivery slot selection drop down appears aka. slot found!
			display notification "Found delivery slot!" with title "Amazon" sound name "Sosumi"
			say "Delivery slot appeared. Try to checkout. Success not guaranteed"
			
			-- send text notification
			if sendTexts then
				-- Credit for texting code: Sean Pinkey, https://github.com/spinkney
				tell application "Messages"
					set targetService to 1st service whose service type = iMessage
					set targetBuddy to buddy phoneNumber of targetService
					send deliverySlotFoundTextMsg to targetBuddy
				end tell
				log "text message sent about slot found"
			end if
			
			-- bring Safari window to front and expand to fill screen so delivery slots are clearly visible
			tell application "Safari"
				-- unminimize
				set miniaturized of window id amzn_win_id to false
				-- wait for window to open
				delay 1
				-- zoom window
				set zoomed of window id amzn_win_id to false
			end tell
			
			-- signals that the loop should end
			set found_slot to true
		else
			-- encountered unknown page
			-- will navigate back to the cart and from there back to the slot selection page
			log "unknown page encountered"
			restartCheckout(selected_cart_url, amzn_win_id)
		end if
	end repeat
else
	log "user did not confirm javascript access was enabled. exiting due to insufficient permissions"
end if
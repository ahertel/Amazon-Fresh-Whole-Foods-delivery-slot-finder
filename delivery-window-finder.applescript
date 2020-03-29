-- variable definitions
set found_slot to false
set oos_keyword to "We're sorry we are unable to fulfill your entire order"
set oos_msg to "click 'continue' on out of stock page before closing this dialog box"
set unknown_page_msg to "Unknown amazon page was loaded. try to manually navigate back to the 'Schedule your order page', and then run the program again"
set slot_site_url to "https://www.amazon.com/gp/buy/shipoptionselect/handlers/display.html?hasWorkingJavascript=1"
set slot_page_keyword to "Schedule your order"
set no_slot_keyword to "No delivery windows available"
set is_first_run to true

-- create new empty window, with one empty tab
tell application "Safari"
	make new document
	set amzn_win_id to id of front window
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
		delay 20
		
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
		say "Item out of stock. See pop up"
		
		-- click continue button to dismiss out of stock warning
		-- NOTE: currently doesn't work
		-- clickID(continue_button_id)
		
		display dialog oos_msg
	else if siteText contains slot_page_keyword and (siteText contains "AM" or siteText contains "PM") then
		-- landed on delivery slot page and delivery slot selection drop down appears aka. slot found!
		display notification "Found delivery slot!" with title "Amazon" sound name "Sosumi"
		say "Success: Delivery slot found"
		set found_slot to true
		
		tell application "Safari"
			-- bring window to front
			set miniaturized of window id amzn_win_id to false
			-- wait for window to open
			delay 2
			-- take screenshot to document slots were found
			tell application "System Events"
				key code 20 using {command down, shift down}
			end tell
		end tell
	else
		-- encountered unknown page
		display dialog unknown_page_msg
		-- correctly exit the loop and end the program
		set found_slot to true
	end if
end repeat
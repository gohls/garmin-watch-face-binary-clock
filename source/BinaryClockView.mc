using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;

class BinaryClockView extends WatchUi.WatchFace 
{
	// Going to use this to display digital time, 
	// for those who can't read binary time 😑	
	var isAwake;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    // Update the view
    function onUpdate(dc) {
        var clockTime = System.getClockTime();
        var targetDc = null;
        targetDc = dc;
        
        // Fill the entire background with Black.
        targetDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        targetDc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
        
        var cubesDict = getCubes(dc);
        var timeArray = [clockTime.hour, clockTime.min, clockTime.sec];
        
        // Lets set the time and color those cubes   
		for (var i = 0; i < timeArray.size(); i++) {
			if (i == 0) {
				colorCubes(targetDc, cubesDict.get("Hr"), timeArray[i]);
			} else if (i == 1) {
				colorCubes(targetDc, cubesDict.get("Min"), timeArray[i]);
			} else {
				colorCubes(targetDc, cubesDict.get("Sec"), timeArray[i]);
			}
		}	
		
		// Epoch time 😎
		var time = Time.now();
		targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);	
        targetDc.drawText(175, 135, Graphics.FONT_XTINY, time.value(), Graphics.TEXT_JUSTIFY_RIGHT); 
		
		// Date e.g. "Wed 1"       
		var today = time.Gregorian.info(time, time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$",[today.day_of_week,today.day,]);
		
		// 24-hour time e.g. "16:51"		
		var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
		
		// @TODO verify this
		// Only show when light button is pressed	
		if (isAwake) {
			targetDc.drawText(175, 165, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_RIGHT);
			targetDc.drawText(dc.getWidth()/4, dc.getHeight()/10, Graphics.FONT_XTINY, timeString, Graphics.TEXT_JUSTIFY_LEFT);
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	// This method is called when the device exits sleep mode.
    // The user has just looked at their watch. Timers and animations may be started here.
	// Set the isAwake flag to let onUpdate know it should render the second cubes and epoch time.
    function onExitSleep() {
		isAwake = true;
    }

	// This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second cubes and epoch time.
    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
		isAwake = false;
        WatchUi.requestUpdate();
    }
    
    // This function is used to color in the binary time cubes.    
    function colorCubes(targetDc, cubesDict, time) {
    	var tensDigit;
    	var onesDigit;
    	
    	// 2D array (cube, dims)
		var tensCubesArray = cubesDict.get("1");
		var onesCubesArray = cubesDict.get("0");
	
		// This needs to be cleaned up!!! 🧹
		if (time >= 10) {
			tensDigit = time / 10;
			onesDigit = time % 10;
			
			for (var i = 0; i < tensCubesArray.size(); i++) {
				if (tensDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
				}
				targetDc.fillRoundedRectangle(tensCubesArray[i][0], tensCubesArray[i][1], 15, 15, 2);
				tensDigit = tensDigit/2; 
			}
			for (var i = 0; i < onesCubesArray.size(); i++) {
				if (onesDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
				}
				targetDc.fillRoundedRectangle(onesCubesArray[i][0], onesCubesArray[i][1], 15, 15, 2);
				onesDigit = onesDigit/2;
			}
		} else {
			onesDigit = time;
			for (var i = 0; i < tensCubesArray.size(); i++) {
				targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
				targetDc.fillRoundedRectangle(tensCubesArray[i][0], tensCubesArray[i][1], 15, 15, 2);
			}
			for (var i = 0; i < onesCubesArray.size(); i++) {
				if (onesDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
				}
				targetDc.fillRoundedRectangle(onesCubesArray[i][0], onesCubesArray[i][1], 15, 15, 2);
				onesDigit = onesDigit/2;
			}
		}		
    }
    
    function getCubes(dc) {
    	// This needs to be cleaned up!!! 🧹
    	return {
        	"Hr" => { 
        		"1" => [[dc.getWidth()/4, dc.getHeight()/2],
        				[dc.getWidth()/4, dc.getHeight()/2-20]],
        		"0" => [[dc.getWidth()/3, dc.getHeight()/2], 
		  		  		[dc.getWidth()/3, dc.getHeight()/2-20],
		  	      		[dc.getWidth()/3, dc.getHeight()/2-40],
		  	      		[dc.getWidth()/3, dc.getHeight()/2-60]],
        			},
		  	"Min" => { 
		  		"1" => [[dc.getWidth()/2 -20, dc.getHeight()/2],
					  	[dc.getWidth()/2 -20, dc.getHeight()/2-20],
					  	[dc.getWidth()/2 -20, dc.getHeight()/2-40]],
				"0" => [[dc.getWidth()/2, dc.getHeight()/2],
					  	[dc.getWidth()/2, dc.getHeight()/2-20],
					  	[dc.getWidth()/2, dc.getHeight()/2-40],
					  	[dc.getWidth()/2, dc.getHeight()/2-60]],
					 }, 
			"Sec" => {
			 	"1" => [[dc.getWidth()/2 + 20, dc.getHeight()/2],
					  	[dc.getWidth()/2 + 20, dc.getHeight()/2-20],
					  	[dc.getWidth()/2 + 20, dc.getHeight()/2-40]],
				"0" => [[dc.getWidth()/2 + 40, dc.getHeight()/2],
					  	[dc.getWidth()/2 + 40, dc.getHeight()/2-20],
					  	[dc.getWidth()/2 + 40, dc.getHeight()/2-40],
					  	[dc.getWidth()/2 + 40, dc.getHeight()/2-60]],
					 }, 
				};
    }
}

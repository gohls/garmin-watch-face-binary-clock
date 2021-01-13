using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class BinaryClockView extends WatchUi.WatchFace 
{
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
        
        var cubesDict = {
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
        
        var timeArray = [clockTime.hour, clockTime.min, clockTime.sec];
        
		for (var i = 0; i < timeArray.size(); i++) {
			if (i == 0) {
				colorCubes(targetDc, cubesDict.get("Hr"), timeArray[i]);
			} else if (i == 1) {
				colorCubes(targetDc, cubesDict.get("Min"), timeArray[i]);
			} else {
				colorCubes(targetDc, cubesDict.get("Sec"), timeArray[i]);
			}
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    
    // This function is used to color in the binary time cubes.    
    function colorCubes(targetDc, cubesDict, time) {
    	var tensDigit;
    	var onesDigit;
    	// 2D array 
		var tensCubesArray = cubesDict.get("1");
		var onesCubesArray = cubesDict.get("0");
		// Break up time digits by tens and ones
	
		if (time >= 10) {
			tensDigit = time / 10;
			onesDigit = time % 10;
			
			for (var i = 0; i < tensCubesArray.size(); i++) {
				if (tensDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_RED);
				}
				targetDc.fillRoundedRectangle(tensCubesArray[i][0], tensCubesArray[i][1], 15, 15, 2);
				tensDigit = tensDigit/2; 
			}
			for (var i = 0; i < onesCubesArray.size(); i++) {
				if (onesDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_RED);
				}
				targetDc.fillRoundedRectangle(onesCubesArray[i][0], onesCubesArray[i][1], 15, 15, 2);
				onesDigit = onesDigit/2;
			}
		} else {
			onesDigit = time;
			for (var i = 0; i < tensCubesArray.size(); i++) {
				targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_RED);
				targetDc.fillRoundedRectangle(tensCubesArray[i][0], tensCubesArray[i][1], 15, 15, 2);
			}
			for (var i = 0; i < onesCubesArray.size(); i++) {
				if (onesDigit % 2) {
					targetDc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
				} else {
					targetDc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_RED);
				}
				targetDc.fillRoundedRectangle(onesCubesArray[i][0], onesCubesArray[i][1], 15, 15, 2);
				onesDigit = onesDigit/2;
			}
		}		
    }
    

}




//    // Update the view
//    function onUpdate(dc) {
//        // Get the current time and format it correctly
//        var timeFormat = "$1$:$2$";
//        var clockTime = System.getClockTime();
//        var hours = clockTime.hour;
//        if (!System.getDeviceSettings().is24Hour) {
//            if (hours > 12) {
//                hours = hours - 12;
//            }
//        } else {
//            if (Application.getApp().getProperty("UseMilitaryFormat")) {
//                timeFormat = "$1$$2$";
//                hours = hours.format("%02d");
//            }
//        }
//        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
//
//        // Update the view
//        var view = View.findDrawableById("TimeLabel");
//        view.setColor(Application.getApp().getProperty("ForegroundColor"));
//        view.setText(timeString);
//
//        // Call the parent onUpdate function to redraw the layout
//        View.onUpdate(dc);
//    }

//
//  DemoCalendarMonth.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael Chacon

#import "TapkuLibrary.h"
#import "AddEventViewController.h"
@class GoogleCalAppDelegate;
@class AddEventViewController;
@interface MonthCalendar : TKCalendarMonthTableViewController<AddEventDelegate> {
	GoogleCalAppDelegate *appDelegate;	
	AddEventViewController *addEventController;
	
}

-(IBAction)addEvent:(id)sender;


@end

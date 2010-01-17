//
//  DemoCalendarMonth.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael Chacon

#import "TapkuLibrary.h"
//#import "AddTitlePlaceEventViewController.h"
#import "AddEventViewController.h"
@class GoogleCalAppDelegate;
@class AddTitlePlaceEventViewController;
@interface MonthCalendar : TKCalendarMonthTableViewController {
	GoogleCalAppDelegate *appDelegate;	
	AddEventViewController *addEventController;
	UINavigationController *addNavController;
	
	
}

@property (nonatomic,retain)  UINavigationController *addNavController;
-(IBAction)addEvent:(id)sender;


@end

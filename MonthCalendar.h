//
//  DemoCalendarMonth.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael Chacon

#import "TapkuLibrary.h"

@class GoogleCalAppDelegate;
@interface MonthCalendar : TKCalendarMonthTableViewController {
	IBOutlet GoogleCalAppDelegate *appDelegate;	
}

@end

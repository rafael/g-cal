//
//  
//  
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael Chacon

#import "TapkuLibrary.h"
//#import "AddTitlePlaceEventViewController.h"
#import "AddEventViewController.h"
@class GoogleCalAppDelegate;
@interface MonthCalendar : TKCalendarMonthTableViewController<AddEventDelegate> {
	GoogleCalAppDelegate *appDelegate;	
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
	
}

-(IBAction)addEvent:(id)sender;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end

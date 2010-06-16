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
#import "GDataCalendar.h"
@class Calendar;
@class GoogleCalAppDelegate;
@interface MonthCalendar : TKCalendarMonthTableViewController<AddEventDelegate,NSFetchedResultsControllerDelegate> {
	
	
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		NSDate *selectedDate;
		Calendar *selectedCalendar;
		int numberOfRowsForGivenDate;
		NSArray *eventsForGivenDate;
		GoogleCalAppDelegate *appDelegate;
		BOOL allCalendarsValue;
		
	
	
	
}

-(void)allCalendars:(BOOL)value;
-(void)addEvent:(id)sender;
- (BOOL)isSameDay:(NSDate *)dateOne withDate:(NSDate *)dateTwo;
-(void) setDayElements;
- (void) today:(id)sender;
-(void) addToolBar;
- (void)handleError:(NSError *)error;
- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error;

@property (nonatomic, retain) Calendar *selectedCalendar;
@property (nonatomic, retain) NSArray *eventsForGivenDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end

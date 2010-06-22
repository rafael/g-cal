//
//  
//  
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael Chacon

#import "TapkuLibrary.h"
#import "MBProgressHUD.h"
#import "NSObject+DDExtensions.h"
#import "AddEventViewController.h"
#import "GDataCalendar.h"
#import "EventCell.h"


#define KEY_CALENDAR @"calendar"
#define KEY_TICKET @"ticket"


@class Calendar;
@class GoogleCalAppDelegate;


@interface MonthCalendar : TKCalendarMonthTableViewController<AddEventDelegate,NSFetchedResultsControllerDelegate,MBProgressHUDDelegate> {
	
	
	@private
		MBProgressHUD *HUD;
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		NSDate *selectedDate;
		Calendar *selectedCalendar;
		int numberOfRowsForGivenDate;
		NSArray *eventsForGivenDate;
		GoogleCalAppDelegate *appDelegate;
		GDataServiceGoogleCalendar *gCalService;
		BOOL allCalendarsValue;
		BOOL ticketDone;
	

			
		NSMutableArray *calendarsTicket;
		NSMutableArray *addEventsQueue;
		NSCondition  *waitForCalendarTickectLock;
	
		NSLock *waitForManagedObjectContext;
	
	//	BOOL entryTicketDone;
	//	NSCondition  *waitForEventTickectLock;
	
		
	
		
	
	
	
}



-(void)allCalendars:(BOOL)value;

-(void)reloadCalendar;

-(void)addEvent:(id)sender;

- (BOOL)isSameDay:(NSDate *)dateOne withDate:(NSDate *)dateTwo;

-(void) setDayElements;

- (void) today:(id)sender;

-(void) addToolBar;

-(void)handleError:(NSError *)error;

-(void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error;

- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithDeletedEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error;

- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)event toCalendar:(Calendar *)calendar;

-(void) loadCalendarsAndEvents:(id)object;

-(void)fetchEventEntries:(NSArray *) arrayOfElements;

-(void) initializeData;

@property (nonatomic, retain) NSMutableArray *calendarsTicket;
@property (nonatomic, retain) NSMutableArray *addEventsQueue;

@property (nonatomic, retain) Calendar *selectedCalendar;
@property (nonatomic, retain) NSArray *eventsForGivenDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end

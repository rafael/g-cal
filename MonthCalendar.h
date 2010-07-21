/*
 
 Copyright (c) 2010 Rafael Chacon
 g-Cal is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 g-Cal is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with g-Cal.  If not, see <http://www.gnu.org/licenses/>.
 */


#import "TapkuLibrary.h"
#import "MBProgressHUD.h"
#import "NSObject+DDExtensions.h"
#import "AddEventViewController.h"
#import "GDataCalendar.h"
#import "EventCell.h"


#define KEY_CALENDAR @"calendar"
#define KEY_EVENT @"event"
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
		BOOL insertDone;
	

			
		//NSMutableArray *calendarsTicket;
	
		NSMutableArray *calendarsTicket;
	
		NSCondition  *waitForCalendarTickectLock;
		NSCondition  *waitForInsertLock;
		NSCondition  *waitForEventTicketsLock;
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

//- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithDeletedEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error;

- (void)insertCalendarEvent:(Event *)event toCalendar:(Calendar *)calendar;

-(void) loadCalendarsAndEvents:(id)object;

-(void)fetchEventEntries:(NSArray *) arrayOfElements;

-(void) syncWithGoogle;
-(Event *)getInitializedEvent;


@property (nonatomic, retain) NSMutableArray *calendarsTicket;
//@property (nonatomic, retain) NSMutableArray *addEventsQueue;

@property (nonatomic, assign) GoogleCalAppDelegate *appDelegate;
@property (nonatomic, retain) Calendar *selectedCalendar;
@property (nonatomic, retain) NSArray *eventsForGivenDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end

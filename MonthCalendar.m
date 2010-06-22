//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//
// Modified by rafael chacon
#import "MonthCalendar.h"
#import "GoogleCalAppDelegate.h"
#import "Event.h"
#import "Calendar.h"
#import "EventViewController.h"
#import "Circle.h"
#import "UIColor+Extensions.h"


@implementation MonthCalendar
@synthesize managedObjectContext, fetchedResultsController;
@synthesize selectedDate;
@synthesize eventsForGivenDate;
@synthesize selectedCalendar;
@synthesize calendarsTicket;


-(void)addEvent:(id)sender{

//		
	AddEventViewController *addEventController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
	addEventController.delegate = self;
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	
	
	addEventController.event = newEvent;
	addEventController.managedObjectContext = self.managedObjectContext;
	addEventController.event.calendar = self.selectedCalendar;
	NSTimeInterval one_hour = 3600; 
	if (self.selectedDate != nil)
		addEventController.event.startDate = self.selectedDate;
	else
		addEventController.event.startDate = [NSDate date];
		
	NSDate *endDate = [[NSDate alloc] initWithTimeInterval:one_hour sinceDate:addEventController.event.startDate]; 
	addEventController.event.endDate =endDate;
	[endDate release];

	
	
	
	UINavigationController *addNavController =  [[UINavigationController alloc] initWithRootViewController:addEventController];
	
//	addNavController.navigationBarHidden = YES;
	[self presentModalViewController:addNavController animated:YES];
	
	[addNavController release];
	[addEventController release];


}



- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event{
	if (event != nil){
		NSError *error = nil;
		if (![event.managedObjectContext save:&error]) {

			NSLog(@"Unresolved error saving the event%@, %@", error, [error userInfo]);
		
		}
		if (!allCalendarsValue)
			self.selectedCalendar = event.calendar;
		
		[self reloadCalendar];
		
	
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}







#pragma mark -
#pragma mark Calenadar Methods
//
//- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
////	
//	NSArray *eventObjects = [self.fetchedResultsController fetchedObjects];
//	for (Event *event in eventObjects) {
//		BOOL isTheSameDay = [self isSameDay:date withDate:event.startDate];
//		if (isTheSameDay)
//			return YES;
//		
//	}
//	return NO;
//}






- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	self.selectedDate = date;
	
	[self setDayElements];
	[self.tableView reloadData];
	NSLog(@"RELOADED CUANDO CAMBIE FECHA");
}




- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	
	NSMutableArray *marksArray = [NSMutableArray arrayWithCapacity:31];
	NSDate *date = startDate;
	NSArray *eventObjects = [self.fetchedResultsController fetchedObjects];
	TKDateInformation info;
	
	NSMutableDictionary *objectsForMark = [NSMutableDictionary dictionaryWithCapacity:20];
	for (Event *event in eventObjects) 
			[objectsForMark setValue:[NSNumber numberWithInt:1] forKey:[event.startDate dateDescription]];

	while(YES){
	
		if ( [objectsForMark valueForKey:[date dateDescription]] != nil) 
			[marksArray addObject:[NSNumber numberWithBool:YES]];
		else
			[marksArray addObject:[NSNumber numberWithBool:NO]];
		
		info = [date dateInformation];
		info.day++;
		date = [NSDate dateFromDateInformation:info];
		if([date compare:lastDate]==NSOrderedDescending) break;
	}
	
	return marksArray;
	
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)date{
	[super calendarMonthView:mv monthDidChange:date];
	self.selectedDate = date;	
	[self setDayElements];
	[self.tableView reloadData];
	[self.monthView selectDate:date];

}



#pragma mark -
#pragma mark Table View dataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return numberOfRowsForGivenDate;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *keventCellIdentifier = @"eventCell";
	NSUInteger row = [indexPath row];	
	EventCell *cell = (EventCell *)[tv dequeueReusableCellWithIdentifier:keventCellIdentifier];
	if( !cell ){
		cell = [[[EventCell alloc] initWithFrame:CGRectZero reuseIdentifier:keventCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	 


	//[cell setNeedsDisplay];
//	[circle_view setNeedsDisplay];
	
	
	// Configure the cell.
	Event *anEvent = (Event *)[self.eventsForGivenDate objectAtIndex:row];

	UIColor *colorForCell = [UIColor colorWithHexString:anEvent.calendar.color];
	
	Circle *circle_view = [[Circle alloc] initWithFrame:CGRectMake(10, 15, 15, 15) andColor:colorForCell];
	[cell addSubview:circle_view];
	[circle_view release];
	
	if (anEvent.startDate){
		NSDate *date = anEvent.startDate;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setDateFormat:@"HH:mm"];
		cell.time.text = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	}
	cell.name.text = anEvent.title;

	if( anEvent.location )
		cell.addr.text = anEvent.location;
	

    return cell;
	
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Event *event = (Event *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.title;
}



-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	self.title = @"June";
	EventViewController *eventController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
	Event *event = (Event *)[fetchedResultsController objectAtIndexPath:indexPath];
	eventController.event = event;
	
	[self.navigationController pushViewController:eventController animated:YES];
	[eventController release];

}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods


- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
	
	
    [HUD removeFromSuperview];
    [HUD release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	
    if (fetchedResultsController == nil) {
		
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
		
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"EventRoot"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
		

		
		
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
		
    }
	
	return fetchedResultsController;
}    


#pragma mark -
#pragma mark Utility functions

-(void)allCalendars:(BOOL)value{
	allCalendarsValue = value;
	
}

-(void)reloadCalendar{
	[self setDayElements];
	[self.monthView reload];
	[self.tableView reloadData];
	if (self.selectedDate)
		[self.monthView selectDate:self.selectedDate];
		
}

-(void) initializeData{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Retreiving Data From Google";
    // Show the HUD while the provided method executes in a new thread
	gCalService = appDelegate.gCalService;
	[HUD showWhileExecuting:@selector(loadCalendarsAndEvents:) onTarget:self withObject:nil animated:YES];
}



-(void) loadCalendarsAndEvents:(GDataFeedCalendar *)feed{

	[[gCalService dd_invokeOnMainThread]  fetchCalendarFeedForUsername:appDelegate.username
	 delegate:self
	 didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error:)];

	//NSLog(@"Antes del lock");
	
	[waitForCalendarTickectLock lock]; 
	while(!ticketDone) { 
		[waitForCalendarTickectLock wait]; 
	} 
	[waitForCalendarTickectLock unlock]; 

	[self reloadCalendar];

	
}




- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{

	self.calendarsTicket = [NSMutableArray arrayWithCapacity:5];
	if( !error ){
		int count = [[feed entries] count];
		[NSThread sleepForTimeInterval:2];
		for( int i=0; i<count; i++ ){
		 
			GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
			[waitForManagedObjectContext lock];
			Calendar *aCalendar = [Calendar getCalendarWithId:[calendar identifier] andContext:self.managedObjectContext];
		
			if (  !aCalendar ){
				aCalendar = [Calendar createCalendarFromGCal:calendar withContext:self.managedObjectContext];
			
			}
			
			else{
				
				NSComparisonResult	last_update_comparison = [aCalendar.updated compare:[[calendar updatedDate] date]];
				if (last_update_comparison == NSOrderedAscending) {
			
					[aCalendar updateCalendarFromGCal:calendar withContext:self.managedObjectContext];
				}	
				
			}
			[waitForManagedObjectContext unlock];
					
			NSURL *feedURL = [[calendar alternateLink] URL];
			if(   feedURL ){
				[self fetchEventEntries:[NSArray arrayWithObjects:feedURL,aCalendar,nil]];

			
			}
		}
			
		
	}else
		[self handleError:error];
	
	
	[waitForCalendarTickectLock lock]; 
 
	ticketDone = YES; 
	[waitForCalendarTickectLock signal]; 
	[waitForCalendarTickectLock unlock]; 
	
	

	
	
}


- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error{
	if( !error ){
		NSMutableDictionary *dictionary;
		for( int section=0; section<[self.calendarsTicket count]; section++ ){
			NSMutableDictionary *nextDictionary = [self.calendarsTicket objectAtIndex:section];
			GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
			if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
				dictionary = nextDictionary;
				break;
			}
		}
	
		if( !dictionary )
			return;		// This should never happen.  It means we couldn't find the ticket it relates to.
	
		int count = [[feed entries] count];	
	
		[waitForManagedObjectContext lock];
		for( int i=0; i<count; i++ ){

			GDataEntryCalendarEvent *event = [[feed entries]  objectAtIndex:i];
			BOOL eventDeleted = [[[event eventStatus] stringValue] isEqualToString:kGDataEventStatusCanceled ];
			Event *anEvent = [Event getEventWithId:[event iCalUID] andContext:self.managedObjectContext];
	
			Calendar *calendarForEvent = [dictionary objectForKey:KEY_CALENDAR];
			if (  !anEvent &&  !eventDeleted){
				
			//	NSLog(@"este es el status %@",[[event eventStatus] stringValue] );
				anEvent = [Event createEventFromGCal:event forCalendar:calendarForEvent withContext:self.managedObjectContext];
			//	NSLog(@"cree: title: %@, id: %@", anEvent.title, anEvent.eventid);
			}
			
			else if (anEvent && eventDeleted) {
			//	NSLog(@"este es el status %@",[[event eventStatus] stringValue] );
//				NSLog(@"borre: title: %@, id: %@", anEvent.title, anEvent.eventid);
				
				[self.managedObjectContext deleteObject:anEvent];
				
				NSError *error = nil;
				if (![self.managedObjectContext save:&error]) 
					NSLog(@"Unresolved error deleting an envent%@, %@", error, [error userInfo]);
			
				
			}
			
	
			
			else if ( anEvent && [anEvent.updated compare:[[event updatedDate] date]] == NSOrderedAscending ){
				//NSLog(@"Need to update event");
				[anEvent updateEventFromGCal:event forCalendar:calendarForEvent withContext:self.managedObjectContext];
				
			}
		
		}
		
		[waitForManagedObjectContext unlock];
		
		[self reloadCalendar];
		NSURL *nextURL = [[feed nextLink] URL];
		if( nextURL ){    // There are more events in the calendar...  Fetch again.
			NSLog(@"entre en refetch");
			GDataServiceTicket *newTicket = [gCalService fetchFeedWithURL:nextURL
																		   delegate:self
																  didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];   // Right back here...
			[dictionary setObject:newTicket forKey:KEY_TICKET];
		}
	}else
		[self handleError:error];
//	
//	[waitForEventTickectLock lock]; 
//	// Produce new data 
//	entryTicketDone = YES; 
//	[waitForEventTickectLock signal]; 
//	[waitForEventTickectLock unlock]; 
}


- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithDeletedEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error{
	if( !error ){

	
	
		int count = [[feed entries] count];	
		NSLog(@"Deleted count %d", count);
		[waitForManagedObjectContext lock];
		for( int i=0; i<count; i++ ){
		
			GDataEntryCalendarEvent *event = [[feed entries]  objectAtIndex:i];
			Event *anEvent = [Event getEventWithId:[event iCalUID] andContext:self.managedObjectContext];

			if (  anEvent ){
				[self.managedObjectContext deleteObject:anEvent];
				NSLog(@"borre a alguien ");
				NSError *error = nil;
				if (![self.managedObjectContext save:&error]) 
					NSLog(@"Unresolved error deleting an envent%@, %@", error, [error userInfo]);
			}
		}
		
			[self setDayElements];
			[tableView reloadData];
			[self.monthView reload];
		[waitForManagedObjectContext unlock];
			
			NSURL *nextURL = [[feed nextLink] URL];
			if( nextURL ){    // There are more events in the calendar...  Fetch again.
				NSLog(@"entre en refetch");
				[gCalService fetchFeedWithURL:nextURL
									 delegate:self
									 didFinishSelector:@selector( eventsTicket:finishedWithDeletedEntries:error: )];   // Right back here...

			}
		
	}else
		[self handleError:error];
	
}




- (void)handleError:(NSError *)error{
	NSString *title, *msg;
	if( [error code]==kGDataBadAuthentication ){
		title = @"Authentication Failed";
		msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
	}else{
		// some other error authenticating or retrieving the GData object or a 304 status
		// indicating the data has not been modified since it was previously fetched
		title = @"Unknown Error";
		msg = [error localizedDescription];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)fetchEventEntries:(NSArray *) arrayOfElements{
	 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *feedURL =(NSURL *) [arrayOfElements objectAtIndex:0];
	Calendar *aCalendar = (Calendar *)[arrayOfElements objectAtIndex:1];
	
	NSMutableDictionary *calendarTicketPair = [NSMutableDictionary dictionaryWithCapacity:2];
	GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
	
	NSDate *minDate	= [[NSDate date] addTimeInterval:-1*60*60*24*60];
	NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
	
	[query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
	[query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
	[query setOrderBy:@"starttime"];  //http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
	[query setIsAscendingOrder:YES];
	[query setShouldExpandRecurrentEvents:YES];	
	[query setShouldShowDeleted:YES];

	
//	GDataServiceTicket *ticket = [[gCalService dd_invokeOnMainThreadAndWaitUntilDone:YES]  fetchFeedWithQuery:query
//																									 delegate:self
//																							didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
				GDataServiceTicket *ticket = [gCalService fetchFeedWithQuery:query
																			  delegate:self
																	 didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
	
	[calendarTicketPair setObject:ticket forKey:KEY_TICKET];
	[calendarTicketPair setObject:aCalendar forKey:KEY_CALENDAR];
	[self.calendarsTicket addObject:calendarTicketPair];
	
//
//	[query setShouldShowOnlyDeleted:YES];
//	[gCalService fetchFeedWithQuery:query
//							delegate:self
//				   didFinishSelector:@selector( eventsTicket:finishedWithDeletedEntries:error: )];
//	[waitForEventTickectLock lock]; 
//	while(!entryTicketDone) { 
//		[waitForEventTickectLock wait]; 
//		entryTicketDone = NO;
//	} 
//	[waitForEventTickectLock unlock]; 

	
	[pool release];
	
	
}

- (BOOL)isSameDay:(NSDate *)dateOne withDate:(NSDate *)dateTwo{
    NSUInteger desiredComponents = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *myCalendarDate = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateOne];
    NSDateComponents *myComparisonDate = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateTwo];
    return [myCalendarDate isEqual:myComparisonDate];
}




//Action methods for toolbar buttons:
- (void) today:(id)sender{
	self.selectedDate= [NSDate date];
	//ok the next line is very important...
	// If I don't select the day before reloading the calendar
	// there is a little bug when changing the date from other motnh

	[self.monthView selectDate:[NSDate date]];
	[self reloadCalendar];

}
- (void) list:(id)sender{
NSLog(@"tyee2");
}
- (void) month:(id)sender{
NSLog(@"tyee3");	
}


-(void) addToolBar {
	
	UIToolbar *toolbar;
	
	
	
	//create toolbar using new
	toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	toolbar.frame = CGRectMake(0, 370, 320, 50);
	
	//Add buttons
	UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc]  initWithTitle:@"Today" style:UIBarButtonItemStyleBordered
																				 target:self
																				 action:@selector(today:)];

	
	UIBarButtonItem *systemItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																				 target:self
																				 action:@selector(list:)];
	
	UIBarButtonItem *systemItem3 = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
									target:self action:@selector(list:)];
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"List", @"Day",
																					  @"Month", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(month:)
			forControlEvents:UIControlEventValueChanged];
	
	
	UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc]
									  initWithCustomView:segmentedControl];
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	NSArray *items = [NSArray arrayWithObjects: systemItem1, flexItem,segmentButton ,flexItem,systemItem3, flexItem, nil];
	
	//release buttons
	[systemItem1 release];
	[systemItem2 release];
	[systemItem3 release];
	[flexItem release];
	[segmentButton release];
	[segmentedControl release];
	
	//add array of buttons to toolbar
	[toolbar setItems:items animated:NO];
	
	[self.view addSubview:toolbar];
	
	[toolbar release];	
	
}

-(void) setDayElements{
	
	NSArray *allMonthEvents = [self.fetchedResultsController fetchedObjects];
	
	
	NSDate *day;	
	NSMutableArray *eventsForDay = [[NSMutableArray alloc] init];
	if (self.selectedDate)
		day = selectedDate;
	else
		day = [NSDate date];
	for (Event *event in allMonthEvents) {
		
		BOOL isTheSameDay = [self isSameDay:event.startDate withDate:day];
		if (isTheSameDay)
			[eventsForDay  addObject:event];
	}
	self.eventsForGivenDate = [NSArray arrayWithArray:eventsForDay];
	[eventsForDay release];
	numberOfRowsForGivenDate = [self.eventsForGivenDate count];	
	
}

#pragma mark -
#pragma mark UIViewController functions

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];

	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
	self.title = @"All Calendars";


}

- (void)viewDidAppear:(BOOL)animated{
	
	if (self.selectedCalendar)
		self.title = self.selectedCalendar.name;
	else
		self.title = @"All Calendars";
	self.navigationController.navigationBar.backItem.title = @"Calendars";

	
}
- (void)viewDidUnload {
	
	self.fetchedResultsController = nil;
	self.managedObjectContext =nil ;
	self.selectedDate = nil;
	self.eventsForGivenDate = nil;
	self.selectedCalendar = nil;
	self.calendarsTicket = nil;
	waitForCalendarTickectLock = nil;
	waitForManagedObjectContext = nil;
	//waitForEventTickectLock = nil;

}

- (void) viewDidLoad{
	[super viewDidLoad];
	waitForCalendarTickectLock = [NSCondition new];
	waitForManagedObjectContext = [NSLock new];
	//waitForEventTickectLock = [NSCondition new];
	ticketDone = NO;
	//entryTicketDone = NO;
	
	
	
	
	appDelegate = [[UIApplication sharedApplication] delegate];
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
		//abort();
	}	
	
//	
//	[self setDayElements];
	
	//select todays date at the begining
	[self.monthView selectDate:[NSDate date]];
	[self initializeData];

	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
	
		
	[self addToolBar];
	
	
}


-(void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[selectedDate release];
	[eventsForGivenDate release];
	[selectedCalendar release];
	[calendarsTicket release];
	[waitForCalendarTickectLock release];
	[waitForManagedObjectContext release];
	//[waitForEventTickectLock release];
	[super dealloc];
	
}


@end

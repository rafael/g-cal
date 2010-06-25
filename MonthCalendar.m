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
@synthesize appDelegate;
//@synthesize eventsTickets;


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
	addEventController.editingMode = NO;
	[endDate release];

	
	
	
	UINavigationController *addNavController =  [[UINavigationController alloc] initWithRootViewController:addEventController];

	[self presentModalViewController:addNavController animated:YES];
	
	[addNavController release];
	[addEventController release];


}

# pragma mark -
# pragma mark AddEventViewController delegate methods

- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event{
	NSLog(@"ests es event %d", event);
	if (event != nil){
		NSError *error = nil;
		[waitForManagedObjectContext lock];
		if (![self.managedObjectContext save:&error]) {

			NSLog(@"Unresolved error saving the event%@, %@", error, [error userInfo]);
		
		}
		[waitForManagedObjectContext unlock];
		if (!allCalendarsValue)
			self.selectedCalendar = event.calendar;
		
		[self insertCalendarEvent:event toCalendar:event.calendar];

		[self reloadCalendar];
	
	
	}
	NSLog(@"aqui");
	
	[self dismissModalViewControllerAnimated:YES];
	
}









#pragma mark -
#pragma mark Calenadar Methods




- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	self.selectedDate = date;
	
	[self setDayElements];
	[self.tableView reloadData];
	
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
	 


	Event *anEvent = (Event *)[self.eventsForGivenDate objectAtIndex:row];

	UIColor *colorForCell = [UIColor colorWithHexString:anEvent.calendar.color];

	if (colorForCell !=nil){
		Circle *circle_view = [[Circle alloc] initWithFrame:CGRectMake(10, 15, 15, 15) andColor:colorForCell];
		[cell addSubview:circle_view];
		[circle_view release];
	}
	if (anEvent.startDate){
		NSDate *date = anEvent.startDate;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setPMSymbol:@"p.m."];
		[dateFormatter setAMSymbol:@"a.m."];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//[dateFormatter setDateFormat:@"HH:mm"];
		cell.time.text = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	}
	cell.name.text = anEvent.title;
	
	if( anEvent.location )
		cell.addr.text = anEvent.location;
	else
		cell.addr.text = @"";
	

    return cell;
	
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Event *event = (Event *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.title;
}



-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

	self.title = [self.selectedDate month];
	EventViewController *eventController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
	eventController.managedObjectContext = self.managedObjectContext;
	Event *event = (Event *)[self.eventsForGivenDate objectAtIndex:[indexPath row]];
	eventController.event = event;
	
	[self.navigationController pushViewController:eventController animated:YES];
	[eventController release];

}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods


- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
	[self reloadCalendar];
	
    [HUD removeFromSuperview];
    [HUD release];
}

-(void) initializeData{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Retreiving Data From Google";
    // Show the HUD while the provided method executes in a new thread
	gCalService = self.appDelegate.gCalService;
	[HUD showWhileExecuting:@selector(loadCalendarsAndEvents:) onTarget:self withObject:nil animated:YES];
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
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																									managedObjectContext:managedObjectContext 
																									sectionNameKeyPath:nil cacheName:@"EventRoot"];
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
#pragma mark Google functions

-(void) loadCalendarsAndEvents:(GDataFeedCalendar *)feed{
	
	//NSURL *url = [GDataServiceGoogleCalendar  calendarFeedURLForUsername:appDelegate.username];
//
//	
//	GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:url];
//	[query setShouldShowDeleted:YES];
//	NSLog(@"este es mi query %@", query);
//	[[gCalService dd_invokeOnMainThread] fetchFeedWithQuery:query
//														delegate:self
//											   didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error: )];
//	
	

	[[gCalService dd_invokeOnMainThread]  fetchCalendarFeedForUsername:self.appDelegate.username
	 delegate:self
	 didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error:)];


	// This is to wait for retrieving google calendar
	[waitForCalendarTickectLock lock]; 
	while(!ticketDone) { 
		[waitForCalendarTickectLock wait]; 
	} 
	[waitForCalendarTickectLock unlock]; 
	// this is to wait for google event entries to be procesed

	[waitForEventTicketsLock lock]; 
	while([calendarsTicket count] != 0) { 
		[waitForEventTicketsLock wait]; 
	} 
	[waitForEventTicketsLock unlock]; 
	
		
	

	

	
}




- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{

	if( !error ){
		int count = [[feed entries] count];
	
		for( int i=0; i<count; i++ ){
		 
			GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
			
		//	NSLog(@"Fecha de updated %@ y edited: %@", [[calendar updatedDate] date], [calendar editedDate] );
			
			Calendar *aCalendar = [Calendar getCalendarWithId:[calendar identifier] andContext:self.managedObjectContext];
		
			if (  !aCalendar ){
				[waitForManagedObjectContext lock];
				aCalendar = [Calendar createCalendarFromGCal:calendar withContext:self.managedObjectContext];
				[waitForManagedObjectContext unlock];
				NSURL *feedURL = [[calendar alternateLink] URL];
					if(   feedURL ){
						[self fetchEventEntries:[NSArray arrayWithObjects:feedURL,aCalendar,nil]];
					}
			
			}
			
			else{
				
				NSComparisonResult	last_update_comparison = [aCalendar.updated compare:[[calendar updatedDate] date]];
				if (last_update_comparison == NSOrderedAscending) {
					[waitForManagedObjectContext lock];
					[aCalendar updateCalendarFromGCal:calendar withContext:self.managedObjectContext];
					[waitForManagedObjectContext unlock];
					NSURL *feedURL = [[calendar alternateLink] URL];
					if(   feedURL ){
						[self fetchEventEntries:[NSArray arrayWithObjects:feedURL,aCalendar,nil]];
					}
					
				}	
		
				
			}

//			NSURL *feedURL = [[calendar alternateLink] URL];
//			if(   feedURL ){
//				[self fetchEventEntries:[NSArray arrayWithObjects:feedURL,aCalendar,nil]];
//			}
	
			
			
					
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
			//
				break;
			}
		}
		
	
		if( !dictionary )
			return;		// This should never happen.  It means we couldn't find the ticket it relates to.
	
		int count = [[feed entries] count];	
	
		[waitForManagedObjectContext lock];
		for( int i=0; i<count; i++ ){

			GDataEntryCalendarEvent *event = [[feed entries]  objectAtIndex:i];
			//NSLog(@"event entry %@", [event title], [event eventStatus]);
			
			BOOL eventDeleted = [[[event eventStatus] stringValue] isEqualToString:kGDataEventStatusCanceled ];
			Calendar *calendarForEvent = [dictionary objectForKey:KEY_CALENDAR];
			Event *anEvent = [Event getEventWithId:[event iCalUID] forCalendar:calendarForEvent andContext:self.managedObjectContext];
	
			
			NSLog(@"event entry \n titulo: %@ \n status: %@ \n nombre:%@\n", [[event title] stringValue], [event identifier], calendarForEvent.name);
			if (  !anEvent &&  !eventDeleted){
				
		
				anEvent = [Event createEventFromGCal:event forCalendar:calendarForEvent withContext:self.managedObjectContext];
		
			}
			
			
			else if (anEvent && eventDeleted) {

				NSLog(@"que e da la comparacion %@", [event identifier]);
				[self.managedObjectContext deleteObject:anEvent];
				
				NSError *error = nil;
				if (![self.managedObjectContext save:&error]) 
					NSLog(@"Unresolved error deleting an envent%@, %@", error, [error userInfo]);
			
				
			}
			
			else if ( anEvent && [anEvent.updated compare:[[event updatedDate] date]] == NSOrderedAscending ){
				NSLog(@"Need to update event");
				
				[anEvent updateEventFromGCal:event forCalendar:calendarForEvent withContext:self.managedObjectContext];
				
			}
		
		}
		
		[waitForManagedObjectContext unlock];
		
		
		NSURL *nextURL = [[feed nextLink] URL];
		if( nextURL ){    // There are more events in the calendar...  Fetch again.
		
			GDataServiceTicket *newTicket = [gCalService fetchFeedWithURL:nextURL
																		   delegate:self
																  didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];   // Right back here...
			[dictionary setObject:newTicket forKey:KEY_TICKET];
		}
		else{
			[waitForEventTicketsLock lock]; 
			[self.calendarsTicket removeObject:dictionary];	
			[waitForEventTicketsLock signal]; 
			[waitForEventTicketsLock unlock]; 
			
		}
	}else
		[self handleError:error];
}


- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithDeletedEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error{
//	if( !error ){
//
//	
//	
//		int count = [[feed entries] count];	
//
//		[waitForManagedObjectContext lock];
//		for( int i=0; i<count; i++ ){
//		
//			GDataEntryCalendarEvent *event = [[feed entries]  objectAtIndex:i];
//			Event *anEvent = [Event getEventWithId:[event iCalUID]  andContext:self.managedObjectContext];
//
//			if (  anEvent ){
//				[self.managedObjectContext deleteObject:anEvent];
//				//NSLog(@"borre a alguien ");
//				NSError *error = nil;
//				if (![self.managedObjectContext save:&error]) 
//					NSLog(@"Unresolved error deleting an envent%@, %@", error, [error userInfo]);
//			}
//		}
//		
//			[self reloadCalendar];
//		
//		[waitForManagedObjectContext unlock];
//			
//			NSURL *nextURL = [[feed nextLink] URL];
//			if( nextURL ){    // There are more events in the calendar...  Fetch again.
//			//	NSLog(@"entre en refetch");
//				[gCalService fetchFeedWithURL:nextURL
//									 delegate:self
//									 didFinishSelector:@selector( eventsTicket:finishedWithDeletedEntries:error: )];   // Right back here...
//
//			}
//		
//	}else
//		[self handleError:error];
	
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


- (void)insertCalendarEvent:(Event *)event toCalendar:(Calendar *)calendar{
	
	GDataEntryCalendarEvent *newEntry = [GDataEntryCalendarEvent calendarEvent];
	[newEntry setTitleWithString:event.title];
	[newEntry addLocation:[GDataWhere whereWithString:event.location]];
	GDataDateTime *startDate = [GDataDateTime dateTimeWithDate:event.startDate timeZone:[NSTimeZone systemTimeZone]];
	GDataDateTime *endDate = [GDataDateTime dateTimeWithDate:event.endDate timeZone:[NSTimeZone systemTimeZone]];
	[newEntry addTime:[GDataWhen whenWithStartTime:startDate endTime:endDate]];
	[newEntry setContentWithString:event.note];
	
	
	GDataServiceTicket *addEventTicket= [gCalService fetchEntryByInsertingEntry:newEntry
										   forFeedURL:[NSURL URLWithString:calendar.link]
											 delegate:self
											 didFinishSelector:@selector( insertTicket:finishedWithEntry:error: )];

	if ([addEventTicket authToken])
	[self.appDelegate.addEventsQueue setObject:event forKey:[addEventTicket authToken]];
	else{
		srand([[NSDate date] timeIntervalSince1970]);
		int random_key = rand();
		[self.appDelegate.addEventsQueue setObject:event forKey:[NSNumber numberWithInt:random_key]];
		
	}

	
}

- (void)insertTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryCalendarEvent *)entry error:(NSError *)error{
	
//NSLog(@"%@",[ticket authToken]);
	Event *eventAdded = (Event *)[self.appDelegate.addEventsQueue objectForKey:[ticket authToken]];

	
	
	
	if( !error ){		
			if (!eventAdded) return; //this should never happen
			eventAdded.eventid = [entry iCalUID];
			eventAdded.updated = [[entry updatedDate] date];
			eventAdded.editLink = [[entry editLink] href];
			eventAdded.etag = [entry ETag];
			NSError *error = nil;
			[waitForManagedObjectContext lock];
			if (![self.managedObjectContext save:&error]) {
				
				NSLog(@"Unresolved error saving the event when coming  back from google%@, %@", error, [error userInfo]);
			
			}
			[waitForManagedObjectContext unlock];
			[self.appDelegate.addEventsQueue removeObjectForKey:[ticket authToken]];
			
		
	}
	else{
		NSString *title, *msg;
		if( [error code]==kGDataBadAuthentication ){
			title = @"Authentication Failed";
			msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials. This event won't be synchronize";
		}else if ( [error code] == NSURLErrorNotConnectedToInternet ) {
			
			
			title = @"No internet access.";
			msg = @"The application couldn't connect to internet. Please check your internet access.";
			
		}else{
			// some other error authenticating or retrieving the GData object or a 304 status
			// indicating the data has not been modified since it was previously fetched
			title = @"An unexpected error has ocurred.  This event won't synchronize";
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

	

	
}

#pragma mark -
#pragma mark Utility functions

- (void)handleError:(NSError *)error{
	NSString *title, *msg;
	if( [error code]==kGDataBadAuthentication ){
		title = @"Authentication Failed";
		msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
	}else if ( [error code] == NSURLErrorNotConnectedToInternet ) {
		
		
		title = @"No internet access.";
		msg = @"The application couldn't connect to internet. Please check your internet access.";
		
	}else{
		// some other error authenticating or retrieving the GData object or a 304 status
		// indicating the data has not been modified since it was previously fetched
		title = @"An unexpected error has ocurred.";
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
	if ([[[self.monthView dateSelected] month] isEqualToString:[self.selectedDate month]]) {
		[self.monthView selectDate:self.selectedDate];
		
		[self setDayElements];
		[self.tableView reloadData];
		if (self.selectedDate)
			[self.monthView selectDate:self.selectedDate];
	}
	else {
		
		[self.monthView selectDate:self.selectedDate];
		[self reloadCalendar];
		
		
	}

}
- (void) sync:(id)sender{
	[self initializeData];
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

	

	
	UIBarButtonItem *systemItem3 = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
									target:self action:@selector(sync:)];
//	
//	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"List", @"Day",
//																					  @"Month", nil]];
//	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	[segmentedControl addTarget:self action:@selector(month:)
//			forControlEvents:UIControlEventValueChanged];
//	
//	
//	UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc]
//									  initWithCustomView:segmentedControl];
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	//NSArray *items = [NSArray arrayWithObjects: systemItem1, flexItem,segmentButton ,flexItem,systemItem3, flexItem, nil];
	NSArray *items = [NSArray arrayWithObjects: systemItem1, flexItem,systemItem3, nil];
	
	//release buttons
	[systemItem1 release];
	[systemItem3 release];
	[flexItem release];
//	[segmentButton release];
//	[segmentedControl release];
	
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

-(GoogleCalAppDelegate *)appDelegate {
	
	if (appDelegate == nil) {
		appDelegate = [[UIApplication sharedApplication] delegate];		
	}
	return appDelegate;
	
}


-(NSMutableArray *)calendarsTicket {

	if (calendarsTicket ==nil) {
		calendarsTicket =  [[NSMutableArray alloc] initWithCapacity:5];
			
	}
	return calendarsTicket;

	
}

#pragma mark -
#pragma mark UIViewController functions

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
//NSLog(@"siempre entro a view did appear");
	self.title = @"All Calendars";
	if (self.selectedCalendar != nil) {
	
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat: @"calendar == %@", selectedCalendar];
		[fetchRequest setPredicate:predicate];
        
		
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"EventRoot"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
		
		NSError *error = nil;
		if (![self.fetchedResultsController performFetch:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
			//abort();
		}	
		
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
		
		
	}
	else {
		self.fetchedResultsController = nil;
		NSError *error = nil;
		if (![self.fetchedResultsController performFetch:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
			//abort();
		}	
		
		
	}

	[self reloadCalendar];

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

	
	//eventsTickets = nil;

}

- (void) viewDidLoad{
	[super viewDidLoad];
	waitForCalendarTickectLock = [NSCondition new];
	waitForManagedObjectContext = [NSLock new];
	waitForEventTicketsLock = [NSCondition new];
	ticketDone = NO;
	
	
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
		//abort();
	}	
	

	
	//select todays date at the begining
	self.selectedDate = [NSDate date];
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
	[waitForEventTicketsLock release];
	
	//[eventsTickets release];
	[super dealloc];
	
}


@end

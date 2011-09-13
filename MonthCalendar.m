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

#import "MonthCalendar.h"
#import "GoogleCalAppDelegate.h"
#import "Event.h"
#import "Calendar.h"
#import "EventViewController.h"
#import "Circle.h"
#import "UIColor+Extensions.h"
#import "NSObject+DDExtensions.h"


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
	Event *newEvent = [self getInitializedEvent];
	
	
	addEventController.event = newEvent;
	addEventController.managedObjectContext = self.managedObjectContext;
	addEventController.editingMode = NO;
	UINavigationController *addNavController =  [[UINavigationController alloc] initWithRootViewController:addEventController];
	[self presentModalViewController:addNavController animated:YES];
	[addNavController release];
	[addEventController release];


}



# pragma mark -
# pragma mark AddEventViewController delegate methods

- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event{
	
	if (event != nil){
		NSError *error = nil;
		[waitForManagedObjectContext lock];
		if (![self.managedObjectContext save:&error]) {

			NSLog(@"Unresolved error saving the event%@, %@", error, [error userInfo]);
		
		}
		[waitForManagedObjectContext unlock];
		if (!allCalendarsValue)
			self.selectedCalendar = event.calendar;
		
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:HUD];
		HUD.delegate = self;

		HUD.labelText =  NSLocalizedString(@"addingEventKey",@"Adding Event...");

		//HUD.detailsLabelText = @"The event is being deleted from Google";
		// Show the HUD while the provided method executes in a new thread
		self.navigationItem.rightBarButtonItem.enabled = NO;	
		self.navigationItem.hidesBackButton = YES;
		[HUD showWhileExecuting:@selector(insertEvent:) onTarget:self withObject:event animated:YES];
		
		//[self insertCalendarEvent:event toCalendar:event.calendar];
//
//		[self reloadCalendar];
	
	
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}

-(void)insertEvent:(Event *)event {
	
	insertDone = NO;
	[[self dd_invokeOnMainThread]insertCalendarEvent:event toCalendar:event.calendar];
	[waitForInsertLock lock];
	while (!insertDone) {
	
		[waitForInsertLock wait];

	}
	[waitForInsertLock unlock];
	

}




#pragma mark -
#pragma mark Calenadar Methods




- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	self.selectedDate = date;
	
	[self setDayElements];
	[self.tkmonthTableView reloadData];
	
}




- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	NSMutableArray *marksArray = [NSMutableArray arrayWithCapacity:40];
	NSDate *date = startDate;
	NSArray *eventObjects = [self.fetchedResultsController fetchedObjects];
	TKDateInformation info;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSMutableDictionary *objectsForMark = [NSMutableDictionary dictionaryWithCapacity:20];
	for (Event *event in eventObjects) {
        // hack to set date to current users timezone.
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:event.startDate];
        NSDate *currentCalendarStartDate = [calendar dateFromComponents:components];
        components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                 fromDate:event.endDate];
        NSDate *currentCalendarEndDate = [calendar dateFromComponents:components];
		[objectsForMark setValue:[NSNumber numberWithInt:1] forKey:[currentCalendarStartDate dateDescription]];
	
		//the event last from more theoone day
        if ([currentCalendarEndDate timeIntervalSinceDate:currentCalendarStartDate]  >= 86400 ) {
            
			NSDate *markDaysBetweenDate = currentCalendarStartDate;
			TKDateInformation markDaysBetweenDateInf = [markDaysBetweenDate dateInformation];
			TKDateInformation endDateInf = [currentCalendarEndDate dateInformation];
			while (markDaysBetweenDateInf.day <  endDateInf.day || markDaysBetweenDateInf.month < endDateInf.month ) {
				markDaysBetweenDate = [markDaysBetweenDate dateByAddingTimeInterval:86400];
				markDaysBetweenDateInf = [markDaysBetweenDate dateInformation];
				
				if ([event.allDay boolValue] == NO )
					[objectsForMark setValue:[NSNumber numberWithInt:1] forKey:[markDaysBetweenDate dateDescription]];
				else{
					// this is for all day event definition <gd:when startTime="2005-06-06" endTime="2005-06-07"/>
					if ( markDaysBetweenDateInf.day !=  endDateInf.day)
					[objectsForMark setValue:[NSNumber numberWithInt:1] forKey:[markDaysBetweenDate dateDescription]];
					
				}
				
			}
			
		}
		
	}
	
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
	[self.tkmonthTableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *keventCellIdentifier = @"eventCell";
	NSUInteger row = [indexPath row];	
	EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:keventCellIdentifier];
	if( !cell ){
		cell = [[[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keventCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	 


	Event *anEvent = (Event *)[self.eventsForGivenDate objectAtIndex:row];

	UIColor *colorForCell = [UIColor colorWithHexString:anEvent.calendar.color];

	if (colorForCell !=nil){
		Circle *circle_view = [[Circle alloc] initWithFrame:CGRectMake(10, 15, 15, 15) andColor:colorForCell];
		[cell addSubview:circle_view];
		[circle_view release];
	}
	if (anEvent.startDate && [anEvent.allDay boolValue] == NO) {
		NSDate *date = anEvent.startDate;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setPMSymbol:NSLocalizedString(@"pmKey",@"PM")];
		[dateFormatter setAMSymbol:NSLocalizedString(@"amKey",@"AM")];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//[dateFormatter setDateFormat:@"HH:mm"];
		cell.time.text = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	}
	else {
		cell.time.text = NSLocalizedString(@"allDayKey", @"All day");
		
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
	Event *event = (Event *)[self.fetchedResultsController objectAtIndexPath:indexPath];
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
	self.navigationItem.rightBarButtonItem.enabled = YES;	
	self.navigationItem.hidesBackButton = NO;
    [HUD removeFromSuperview];
    [HUD release];
}

-(void) syncWithGoogle{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;


    HUD.labelText =  NSLocalizedString(@"loadingKey",@"Loading"); 
    HUD.detailsLabelText =  NSLocalizedString(@"retrieveDataKey",@"Retrieving Data From Google");


    // Show the HUD while the provided method executes in a new thread
	gCalService = self.appDelegate.gCalService;
	if ([[gCalService username] isEqualToString:@"username@gmail.com"]) 
		return;
	ticketDone = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;	
	self.navigationItem.hidesBackButton = YES;
	
	[HUD showWhileExecuting:@selector(loadCalendarsAndEvents:) onTarget:self withObject:nil animated:YES];
}



#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	
    if (fetchedResultsController == nil) {
		
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																									managedObjectContext:self.managedObjectContext 
																									sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
		
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
		
    }
	
	return fetchedResultsController;
}    

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (!self.tkmonthTableView.editing) 
        [self.tkmonthTableView reloadData];
}



#pragma mark -
#pragma mark Google functions

-(void) loadCalendarsAndEvents:(GDataFeedCalendar *)feed{

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
		NSArray *calendars = [self getCalendars];
	
		if (  count != [calendars count]) {
			for (Calendar  *aCal in calendars) {
				BOOL intruder = YES;
				for( int i=0; i<count; i++ ){
					
					GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
					//NSLog(@"",)
					if ( [aCal.calid  isEqualToString:[calendar identifier]]) {
						
						intruder = NO;
						break;
						
						
					}
										
				}
				if (intruder == YES) {
					[self.managedObjectContext deleteObject:aCal];
										
					NSError *error = nil;
					if (![self.managedObjectContext save:&error]) {
						
						NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
						
					}	
				
					
				}
				
				
				
			}
		}
				for( int i=0; i<count; i++ ){
		 
			GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
		
			
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
		NSMutableDictionary *dictionary = nil;
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
			BOOL eventDeleted = [[[event eventStatus] stringValue] isEqualToString:kGDataEventStatusCanceled ];
			Calendar *calendarForEvent = [dictionary objectForKey:KEY_CALENDAR];
			Event *anEvent = [Event getEventWithId:[event iCalUID] forCalendar:calendarForEvent andContext:self.managedObjectContext];
	
			
		
			if (  !anEvent &&  !eventDeleted){
				
		
				[Event createEventFromGCal:event forCalendar:calendarForEvent withContext:self.managedObjectContext];
		
			}
			
			
			else if (anEvent && eventDeleted) {

				[self.managedObjectContext deleteObject:anEvent];
				
				NSError *error = nil;
				if (![self.managedObjectContext save:&error]) 
					NSLog(@"Unresolved error deleting an envent%@, %@", error, [error userInfo]);
			
				
			}
			
			else if ( anEvent && [anEvent.updated compare:[[event updatedDate] date]] == NSOrderedAscending ){
				
				
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





-(void)fetchEventEntries:(NSArray *) arrayOfElements{

	NSURL *feedURL =(NSURL *) [arrayOfElements objectAtIndex:0];
	Calendar *aCalendar = (Calendar *)[arrayOfElements objectAtIndex:1];
	
	NSMutableDictionary *calendarTicketPair = [NSMutableDictionary dictionaryWithCapacity:2];
	GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
	NSDate *minDate	= [self.selectedDate dateByAddingTimeInterval:-1*60*60*24*60]; // .. 60 days from selected date
	NSDate *maxDate = [self.selectedDate dateByAddingTimeInterval:60*60*24*90];  // ...to 90 days from selected date.
	
	[query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
	[query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
	[query setOrderBy:@"starttime"]; 
	[query setIsAscendingOrder:YES];
	[query setShouldExpandRecurrentEvents:YES];	
	[query setShouldShowDeleted:YES];
	[query setMaxResults:60];
 


	GDataServiceTicket *ticket = [gCalService fetchFeedWithQuery:query
											  delegate:self
											   didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];

	[calendarTicketPair setObject:ticket forKey:KEY_TICKET];
	[calendarTicketPair setObject:aCalendar forKey:KEY_CALENDAR];
	[self.calendarsTicket addObject:calendarTicketPair];
	

	
}


- (void)insertCalendarEvent:(Event *)event toCalendar:(Calendar *)calendar{
	
	GDataEntryCalendarEvent *newEntry = [GDataEntryCalendarEvent calendarEvent];
	[newEntry setTitleWithString:event.title];
	[newEntry addLocation:[GDataWhere whereWithString:event.location]];
	GDataDateTime *startDate = [GDataDateTime dateTimeWithDate:event.startDate timeZone:[NSTimeZone systemTimeZone]];
	GDataDateTime *endDate = [GDataDateTime dateTimeWithDate:event.endDate timeZone:[NSTimeZone systemTimeZone]];
	[newEntry addTime:[GDataWhen whenWithStartTime:startDate endTime:endDate]];
	[newEntry setContentWithString:event.note];
	
	
	gCalService = self.appDelegate.gCalService;
	GDataServiceTicket *addEventTicket= [gCalService fetchEntryByInsertingEntry:newEntry
										   forFeedURL:[NSURL URLWithString:calendar.link]
											 delegate:self
											 didFinishSelector:@selector( insertTicket:finishedWithEntry:error: )];
	
	
	
	NSMutableDictionary *eventTicketPair = [NSMutableDictionary dictionaryWithCapacity:2];
	[eventTicketPair setObject:addEventTicket forKey:KEY_TICKET];
	[eventTicketPair setObject:event forKey:KEY_EVENT];
	[self.appDelegate.addEventsQueue addObject:eventTicketPair];
	
}

- (void)insertTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryCalendarEvent *)entry error:(NSError *)error{
	
	NSMutableDictionary *dictionary =nil;
	int index_to_delete;
	for( int section=0; section<[self.appDelegate.addEventsQueue count]; section++ ){
		NSMutableDictionary *nextDictionary = [self.appDelegate.addEventsQueue objectAtIndex:section];
		GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
		if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
			dictionary = nextDictionary;
			index_to_delete = section;
			//
			break;
		}
	}

	if( !dictionary )
		return;		// This should never happen.  It means we couldn't find the ticket it relates to.
	
	
	Event *eventAdded = (Event *)[dictionary objectForKey:KEY_EVENT];
	
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

		
	}
	
	else{
		[self handleError:error];
		[self.managedObjectContext deleteObject:eventAdded];
		
		NSError *error = nil;
		if (![self.managedObjectContext save:&error]) {
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
		}	
	

	}

	
	[self.appDelegate.addEventsQueue removeObjectAtIndex:index_to_delete];
	
	[waitForInsertLock lock];

	insertDone = YES;
	[waitForInsertLock signal];
	[waitForInsertLock unlock];


	
}

#pragma mark -
#pragma mark alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 1) {
			NSLog(@"Tete %i", buttonIndex);
		
		//@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=382003793";
		
		NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=382003793&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
		NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *url = [NSURL URLWithString:escaped];
		NSLog(@"%@", url);
		[[UIApplication sharedApplication] openURL:url];
		
	}
}

#pragma mark -
#pragma mark Utility functions

-(void) askForRate{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (! [defaults objectForKey:@"firstRun"]) {
		[defaults setObject:[NSDate date] forKey:@"firstRun"];
	}
	NSInteger daysSinceInstall = [[NSDate date] timeIntervalSinceDate:[defaults objectForKey:@"firstRun"]] / 86400;
	if ( daysSinceInstall > 10 && [defaults boolForKey:@"askedForRating"] == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"likeAppKey",  @"Like This App?") message:NSLocalizedString(@"likeAppMsgKey",@"Please rate it in the App Store!") delegate:self cancelButtonTitle:NSLocalizedString(@"nothxsKey",@"No Thanks") otherButtonTitles:NSLocalizedString(@"rateKey",@"Rate It!"), nil];
        [alert show];
        [alert release];
		[defaults setBool:YES forKey:@"askedForRating"];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];	
	
	
}



-(NSArray *)getCalendars {
	

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updated" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:self.managedObjectContext 
																								  sectionNameKeyPath:nil cacheName:nil];
	//aFetchedResultsController.delegate = self;
	
	NSError *error;
	
	if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
        return nil;
	}	
	NSArray *calendars= [NSArray arrayWithArray:[aFetchedResultsController fetchedObjects]];
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	return calendars;
	
}

-(Event *)getInitializedEvent {
	
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];

	if ([self.selectedCalendar.edit_permission boolValue])
		newEvent.calendar = self.selectedCalendar;
	NSTimeInterval one_hour = 3600; 
	NSDate *today = [NSDate date];
	TKDateInformation selectedDateInfo = [self.selectedDate dateInformation];
	TKDateInformation todayInfo = [today dateInformation];
	selectedDateInfo.hour = todayInfo.hour+1;
	selectedDateInfo.minute = 0;
	newEvent.startDate = [NSDate dateFromDateInformation:selectedDateInfo];
	NSDate *endDate = [[NSDate alloc] initWithTimeInterval:one_hour sinceDate:newEvent.startDate]; 
	newEvent.endDate =endDate;
	[endDate release];
	return newEvent;
	
}

- (void)handleError:(NSError *)error{
	NSString *title, *msg;
	NSLog(@"este es el error %@", error);
	if( [error code]==kGDataBadAuthentication ){

		title = NSLocalizedString(@"authenticationFailedKey",@"Authentication Failed");
		msg = NSLocalizedString(@"authenticationFailedMsgKey",@"Authentication Failed Msg");
	}else if ( [error code] == NSURLErrorNotConnectedToInternet || [error code] == -1018 ) {
		
		
		title = NSLocalizedString(@"noInternetKey",@"No internet access.");
		msg = NSLocalizedString(@"noInternetMsgKey",@"The application couldn't connect to internet. Please check your internet access.");
		
	}else{
		// some other error authenticating or retrieving the GData object or a 304 status
		// indicating the data has not been modified since it was previously fetched
		title = NSLocalizedString(@"unexpectedErrorKey", @"An unexpected error has ocurred.");
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


	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
	}	
	[self setDayElements];
	[self.monthView reload];

	[self.tkmonthTableView reloadData];
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
		[self.tkmonthTableView reloadData];
		if (self.selectedDate)
			[self.monthView selectDate:self.selectedDate];
	}
	else {
		
		[self.monthView selectDate:self.selectedDate];
		[self reloadCalendar];
		
		
	}

}
- (void) sync:(id)sender{
	[self syncWithGoogle];
}
- (void) month:(id)sender{

}


-(void) addToolBar {
	
	UIToolbar *toolbar;
	
	
	
	//create toolbar using new
	toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	toolbar.frame = CGRectMake(0, 370, 320, 50);

	UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc]  initWithTitle:NSLocalizedString(@"nowKey", @"Now") style:UIBarButtonItemStyleBordered

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
	NSArray *items = [NSArray arrayWithObjects: systemItem3, flexItem,systemItem1, nil];
	
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
		//check for events that last for more the one day
		if ([event.endDate timeIntervalSinceDate:event.startDate]  >= 86400 ) {
			NSDate *markDaysBetweenDate = event.startDate;	
			TKDateInformation markDaysBetweenDateInf = [markDaysBetweenDate dateInformation];
			TKDateInformation endDateInf = [event.endDate dateInformation];
			while (markDaysBetweenDateInf.day <  endDateInf.day || markDaysBetweenDateInf.month < endDateInf.month ) {
				markDaysBetweenDate = [markDaysBetweenDate dateByAddingTimeInterval:86400];
				markDaysBetweenDateInf = [markDaysBetweenDate dateInformation];
				isTheSameDay = [self isSameDay:markDaysBetweenDate withDate:day];
				if (isTheSameDay){
					if ([event.allDay boolValue] == NO )
						[eventsForDay  addObject:event];
					
					else {
						// this is for all day event definition <gd:when startTime="2005-06-06" endTime="2005-06-07"/>
						if (markDaysBetweenDateInf.day != endDateInf.day) 
							[eventsForDay  addObject:event];
						
					}
				}
						
						
					
				
				
				

				
			}
			
		}
		
		
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

- (void)viewWillAppear:(BOOL)animated{
	NSIndexPath *tableSelection = [self.tkmonthTableView indexPathForSelectedRow];
	[self.tkmonthTableView deselectRowAtIndexPath:tableSelection animated:YES];
	if (self.selectedCalendar != nil) {

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat: @"calendar == %@", selectedCalendar];
		[fetchRequest setPredicate:predicate];
        
		
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
		
		NSError *error = nil;
		if (![self.fetchedResultsController performFetch:&error])
			NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
			
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
		
		
	}
	else {
		self.fetchedResultsController = nil;
		NSError *error = nil;
		if (![self.fetchedResultsController performFetch:&error])
			NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
	}
	[self reloadCalendar];
}

- (void)viewDidAppear:(BOOL)animated{
	
	if (self.selectedCalendar)
		self.title = self.selectedCalendar.name;
	else
		self.title = NSLocalizedString(@"allCalendarsKey", @"All Calendars");
	
	self.navigationController.navigationBar.backItem.title =  NSLocalizedString(@"calendarsKey", @"Calendars"); 

	
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
	[self askForRate];
	waitForCalendarTickectLock = [NSCondition new];
	waitForManagedObjectContext = [NSLock new];
	waitForEventTicketsLock = [NSCondition new];
	waitForInsertLock = [NSCondition new];
	
	
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

		NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);

	}	
	

	
	//select todays date at the begining
	self.selectedDate = [NSDate date];
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;

	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"sync_on_load_pref"])
		[self syncWithGoogle];

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
	[waitForInsertLock release];
	//[eventsTickets release];
	[super dealloc];
	
}


@end

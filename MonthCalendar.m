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


@implementation MonthCalendar
@synthesize managedObjectContext, fetchedResultsController;
@synthesize selectedDate;
@synthesize eventsForGivenDate;
@synthesize selectedCalendar;


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
		[self setDayElements];
		[tableView reloadData];
		[self.monthView reload];
		
	
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}







#pragma mark -
#pragma mark Calenadar Methods

- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
//	
	NSArray *eventObjects = [self.fetchedResultsController fetchedObjects];
	for (Event *event in eventObjects) {
		BOOL isTheSameDay = [self isSameDay:date withDate:event.startDate];
		if (isTheSameDay)
			return YES;
		
	}
	return NO;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date{
	
	
	self.selectedDate = date;

	[self setDayElements];
	[tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthWillAppear:(NSDate*)month{
	[super calendarMonthView:mv monthWillAppear:month];
	
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return numberOfRowsForGivenDate;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *keventCellIdentifier = @"eventCell";
	NSUInteger row = [indexPath row];	
    cell = [tv dequeueReusableCellWithIdentifier:keventCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:keventCellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Event *anEvent = (Event *)[self.eventsForGivenDate objectAtIndex:row];
	cell.textLabel.text = anEvent.title;
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
	NSLog(@"vamos  ver %i", test);
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
		
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
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
	
	return fetchedResultsController;
}    
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//	[self.tableView beginUpdates];
//}
////
////
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//
//	
//	switch(type) {
//		case NSFetchedResultsChangeInsert:
//			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeDelete:
//			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeUpdate:
//			[self configureCell:(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//			break;
//			
//		case NSFetchedResultsChangeMove:
//			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//	}
//}
////
////
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//	switch(type) {
//		case NSFetchedResultsChangeInsert:
//			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeDelete:
//			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//	}
//}
//
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//	NSLog(@"vamos a ver como funciona esta mieeeer %@", controller);
//	//[tableView reloadData];
//}


#pragma mark -
#pragma mark Utility functions

-(void)allCalendars:(BOOL)value{
	allCalendarsValue = value;
	
}

-(void) initializeData{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Retreiving Data From Google";
    // Show the HUD while the provided method executes in a new thread
	GDataServiceGoogleCalendar *gCalService = appDelegate.gCalService;
	
	
	[gCalService fetchCalendarFeedForUsername:appDelegate.username
									 delegate:self
							didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error:)];
	
	
	
  }

-(void) loadCalendarsAndEvents:(GDataFeedCalendar *)feed{
	if (feed){
		int count = [[feed entries] count];
		test = count;
		for( int i=0; i<count; i++ ){
			GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
			
			Calendar *newCalendar = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:self.managedObjectContext];
			newCalendar.name = [[calendar title] stringValue];
			newCalendar.calid = [[calendar id] stringValue];
			NSError *error = nil;
			if (![self.managedObjectContext save:&error]) {
				
				NSLog(@"Unresolved error saving the calenadar%@, %@", error, [error userInfo]);
				
			}
			
			// Create a dictionary containing the calendar and the ticket to fetch its events.
			dictionary = [[NSMutableDictionary alloc] init];
		//	[data addObject:dictionary];
			
			[dictionary setObject:calendar forKey:KEY_CALENDAR];
			[dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];
			
		//	if( [calendar ACLLink] )  // We can determine whether the calendar is under user's control by the existence of its edit link.
//				[dictionary setObject:KEY_EDITABLE forKey:KEY_EDITABLE];
			
//			NSURL *feedURL = [[calendar alternateLink] URL];
//			if( feedURL ){
//				GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
//				
//				// Currently, the app just shows calendar entries from 15 days ago to 31 days from now.
//				// Ideally, we would instead use similar controls found in Google Calendar web interface, or even iCal's UI.
//				NSDate *minDate = [NSDate date];  // From right now...
//				NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
//				
//				[query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
//				[query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
//				[query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
//				[query setIsAscendingOrder:YES];
//				[query setShouldExpandRecurrentEvents:YES];
//				
//				GDataServiceTicket *ticket = [googleCalendarService fetchFeedWithQuery:query
//																			  delegate:self
//																	 didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
//				// I add the service ticket to the dictionary to make it easy to find which calendar each reply belongs to.
//				[dictionary setObject:ticket forKey:KEY_TICKET];
//			}
		}

		
		
	}
//	test = @"loadCalendarsAndEvents";
	[NSThread sleepForTimeInterval:2];

	
}
- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{
	
	if( !error ){
		[HUD showWhileExecuting:@selector(loadCalendarsAndEvents:) onTarget:self withObject:feed animated:YES];

		NSLog(@"Auntentique adecuadamente");
//		int count = [[feed entries] count];
//		for( int i=0; i<count; i++ ){
//			GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
//			
//			// Create a dictionary containing the calendar and the ticket to fetch its events.
//			NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//			[data addObject:dictionary];
//			
//			[dictionary setObject:calendar forKey:KEY_CALENDAR];
//			[dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];
//			
//			if( [calendar ACLLink] )  // We can determine whether the calendar is under user's control by the existence of its edit link.
//				[dictionary setObject:KEY_EDITABLE forKey:KEY_EDITABLE];
//			
//			NSURL *feedURL = [[calendar alternateLink] URL];
//			if( feedURL ){
//				GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
//				
//				// Currently, the app just shows calendar entries from 15 days ago to 31 days from now.
//				// Ideally, we would instead use similar controls found in Google Calendar web interface, or even iCal's UI.
//				NSDate *minDate = [NSDate date];  // From right now...
//				NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
//				
//				[query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
//				[query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
//				[query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
//				[query setIsAscendingOrder:YES];
//				[query setShouldExpandRecurrentEvents:YES];
//				
//				GDataServiceTicket *ticket = [googleCalendarService fetchFeedWithQuery:query
//																			  delegate:self
//																	 didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
//				// I add the service ticket to the dictionary to make it easy to find which calendar each reply belongs to.
//				[dictionary setObject:ticket forKey:KEY_TICKET];
//			}
//		}
	}else
		[self handleError:error];
	
	//[self.tableView reloadData];
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
	NSLog(msg);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (BOOL)isSameDay:(NSDate *)dateOne withDate:(NSDate *)dateTwo{
    NSUInteger desiredComponents = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *myCalendarDate = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateOne];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateTwo];
    return [myCalendarDate isEqual:today];
}




//Action methods for toolbar buttons:
- (void) today:(id)sender{

	[self.monthView selectDate:[NSDate date]];
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

}

- (void) viewDidLoad{
	[super viewDidLoad];
	
	
	
	
	
	appDelegate = [[UIApplication sharedApplication] delegate];
	[self initializeData];

	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
	[self setDayElements];
	
	[self addToolBar];
	
	
}


-(void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[selectedDate release];
	[eventsForGivenDate release];
	[selectedCalendar release];
	[super dealloc];
	
}


@end

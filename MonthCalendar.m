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

@implementation MonthCalendar
@synthesize managedObjectContext, fetchedResultsController;
@synthesize selectedDate;
@synthesize eventsForGivenDate;
-(IBAction)addEvent:(id)sender{

		
	AddEventViewController *addEventController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
	addEventController.delegate = self;
//	Calendar *newCal = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:self.managedObjectContext];
//
//	newCal.name = @"google leisure";
//	newCal.calid = [NSNumber numberWithInt:1];
//	
//	
//	NSError *error = nil;
//	NSLog(@"este es mi context %@",newCal.managedObjectContext);
//	if (![newCal.managedObjectContext save:&error]) {
//		/*
//		 Replace this implementation with code to handle the error appropriately.
//		 
//		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//		 */
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		//abort();
//	}
//	NSLog(@"wbhhhaaaat tha fuck");
//	
//	NSLog(@"id %@", newCal);
////	
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	
	
	addEventController.event = newEvent;
	addEventController.managedObjectContext = self.managedObjectContext;
	
	NSTimeInterval one_hour = 3600; 

	addEventController.event.startDate = [NSDate  date];
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

			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		}	
	
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
	
//	NSInteger count = [[self.fetchedResultsController sections] count];
//    
//	if (count == 0) {
//		count = 1;
//	}
//	
//    return count;	
	return 1;
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date{
	self.selectedDate = date;
	NSArray *allMonthEvents = [self.fetchedResultsController fetchedObjects];
	//	
	NSMutableArray *eventsForToday = [[NSMutableArray alloc] init];

	for (Event *event in allMonthEvents) {
		
		BOOL isTheSameDay = [self isSameDay:event.startDate withDate:date];
		if (isTheSameDay)
			[eventsForToday  addObject:event];
	}
	self.eventsForGivenDate = [[NSArray alloc] initWithArray:eventsForToday];
	[eventsForToday release];
	numberOfRowsForGivenDate = [self.eventsForGivenDate count];
	
	
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



-(void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	
	[appDelegate eventClicked:[[[tableView2 cellForRowAtIndexPath:indexPath] textLabel] text]];
	
	
	
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


#pragma mark -
#pragma mark Utility functions

- (BOOL)isSameDay:(NSDate *)dateOne withDate:(NSDate *)dateTwo{
    NSUInteger desiredComponents = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *myCalendarDate = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateOne];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:desiredComponents fromDate:dateTwo];
    return [myCalendarDate isEqual:today];
}


#pragma mark -
#pragma mark UIViewController Functions

- (void) viewDidLoad{
	[super viewDidLoad];
	appDelegate = [[UIApplication sharedApplication] delegate];
	
	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
	
	
	NSArray *allMonthEvents = [self.fetchedResultsController fetchedObjects];
//	
	NSMutableArray *eventsForToday = [[NSMutableArray alloc] init];
	NSDate *today = [NSDate date];
	for (Event *event in allMonthEvents) {
		
		BOOL isTheSameDay = [self isSameDay:event.startDate withDate:today];
		if (isTheSameDay)
			[eventsForToday  addObject:event];
	}
	self.eventsForGivenDate = [[NSArray alloc] initWithArray:eventsForToday];
	[eventsForToday release];
	numberOfRowsForGivenDate = [self.eventsForGivenDate count];
	

}



- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

- (void)viewDidUnload {
	
	self.fetchedResultsController = nil;
	self.managedObjectContext =nil ;
	self.selectedDate = nil;
	self.eventsForGivenDate = nil;

}


-(void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[selectedDate release];
	[eventsForGivenDate release];
	[super dealloc];
	
}


@end

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

@implementation MonthCalendar
@synthesize managedObjectContext, fetchedResultsController;

-(IBAction)addEvent:(id)sender{

		
	AddEventViewController *addEventController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
	addEventController.delegate = self;
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	addEventController.event = newEvent;
	
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
	
	[self dismissModalViewControllerAnimated:YES];
	
}


- (void) viewDidLoad{
	[super viewDidLoad];
	appDelegate = [[UIApplication sharedApplication] delegate];

	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];

	srand([[NSDate date] timeIntervalSince1970]);
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
//											   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:
//											   @selector(addEvent:)] autorelease];
}


- (void)viewDidUnload {
	
	fetchedResultsController = nil;
	managedObjectContext =nil ;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
// data source

- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
	return (rand() % 2 == 0) ? YES : NO;
}

// delegate

- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date{

	[tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthWillAppear:(NSDate*)month{
	[super calendarMonthView:mv monthWillAppear:month];
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [appDelegate.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
    }
    
	// Configure the cell.

	cell.textLabel.text = [appDelegate.events objectAtIndex:indexPath.row];
    return cell;
	
}

-(void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	
	[appDelegate eventClicked:[[[tableView2 cellForRowAtIndexPath:indexPath] textLabel] text]];
	
	
	
}


- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}


-(void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	
	[super dealloc];
	
}


@end

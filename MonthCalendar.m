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

//#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation MonthCalendar

@synthesize addNavController;
 

//- (void)addTitlePlaceEventViewController:(AddTitlePlaceEventViewController *)addTitlePlaceEventViewController 
//				   didAddTitlePlaceEvent:(NSString *)eventId{
//	
//	if ( [allTrim( eventId ) length] != 0 ){
//	[appDelegate addNewEvent:eventId];
//	[tableView reloadData];
//	}
//	
//}


-(IBAction)addEvent:(id)sender{
	addNavController.navigationBarHidden = YES;
	[self presentModalViewController:addNavController animated:YES];
	


}





- (void) viewDidLoad{
	[super viewDidLoad];
	appDelegate = [[UIApplication sharedApplication] delegate];
	addEventController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
	//addEventController.delegate = self;
	addNavController = [[UINavigationController alloc] initWithRootViewController:addEventController];
	//[addNavController navigationBarHidden:YES];
	

	srand([[NSDate date] timeIntervalSince1970]);
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:
											   @selector(addEvent:)] autorelease];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[addEventController release];
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
	
	[addNavController release];
	[super dealloc];
	
}


@end

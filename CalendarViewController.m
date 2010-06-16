//
//  CalendarViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 15/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "CalendarViewController.h"
#import "Calendar.h"
#import "MonthCalendar.h"
#import "GoogleCalAppDelegate.h"


@implementation CalendarViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize calendarsTableView;
#pragma mark -
#pragma mark Table View dataSource delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	MonthCalendar *mainMonthCal = appDelegate.mainMonthCal;
//	Event *event = (Event *)[fetchedResultsController objectAtIndexPath:indexPath];
//	eventController.event = event;
	[self.navigationController pushViewController:mainMonthCal animated:YES];
		
}



#pragma mark -
#pragma mark Table View dataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return @"Prueba";
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//	return [menuList count];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	static NSString *kCell_ID = @"calendarCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_ID];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCell_ID] autorelease];
	}
	
    cell.textLabel.text = @"primera celda";
	
	
	return cell;
	
}



#pragma mark -
#pragma mark UIViewController functions
- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.calendarsTableView indexPathForSelectedRow];
	[self.calendarsTableView deselectRowAtIndexPath:tableSelection animated:YES];
}



- (void)viewDidLoad {
	self.title = @"Calendars";
	
	appDelegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}


@end

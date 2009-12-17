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

@implementation MonthCalendar
 

- (void) viewDidLoad{
	[super viewDidLoad];
	appDelegate = [[UIApplication sharedApplication] delegate];
	
	
	srand([[NSDate date] timeIntervalSince1970]);
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.

	cell.textLabel.text = [appDelegate.events objectAtIndex:indexPath.row];
    return cell;
	
}

-(void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	
	[appDelegate eventClicked:[[[tableView2 cellForRowAtIndexPath:indexPath] textLabel] text]];
	
	
	
}





@end

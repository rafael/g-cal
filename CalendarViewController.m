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


#import "CalendarViewController.h"
#import "Calendar.h"
#import "MonthCalendar.h"
#import "GoogleCalAppDelegate.h"
#import "UIColor+Extensions.h"
#import "Circle.h"


@implementation CalendarViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize calendarsTableView;


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	
    if (fetchedResultsController == nil) {
		
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
		
       // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"edit_permission" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																									managedObjectContext:managedObjectContext 
																									sectionNameKeyPath:@"ownSectionSeparator" 
																									cacheName:@"CalendarRoot"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
		
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
	
			NSLog(@"Unresolved error fetching events MonthCalendar.m %@, %@", error, [error userInfo]);
		
		}	
		
		
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
		
    }
	
	return fetchedResultsController;
}  
-(NSManagedObjectContext *)managedObjectContext {
	
	if (managedObjectContext == nil ) {
		GoogleCalAppDelegate *appDel = [[UIApplication sharedApplication] delegate];
		managedObjectContext = [appDel.managedObjectContext retain];
		
	}
	return managedObjectContext;
}


#pragma mark -
#pragma mark Table View dataSource delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger section = [indexPath section];
	if (section == 0){
	
		appDelegate.mainMonthCal.selectedCalendar = nil;
		[appDelegate.mainMonthCal allCalendars:YES];
	}
	else{
		[appDelegate.mainMonthCal allCalendars:NO];
		NSUInteger row = [indexPath row];

		section = section -1 ;
		NSIndexPath *fetchedIndex = [NSIndexPath indexPathForRow:row inSection:section];
		Calendar *aCalendar = (Calendar *)[self.fetchedResultsController objectAtIndexPath:fetchedIndex];
		appDelegate.mainMonthCal.selectedCalendar = aCalendar;
	}

	MonthCalendar *mainMonthCal = appDelegate.mainMonthCal;
	[self.navigationController pushViewController:mainMonthCal animated:YES];
		
}




#pragma mark -
#pragma mark Table View dataSource Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section)
	
	{
		case 0:
			
			return @"";
			
			break;
			
		case 1:
			
			return @"My Calendars";
			
			break;
		case 2:
			
			return @"Other Calendars";
			
			break;
			
	}
	return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = nil;
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	static NSString *kcalendarCell_ID = @"calendarCell_ID";
	cell = [tableView dequeueReusableCellWithIdentifier:kcalendarCell_ID];	
	if( cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcalendarCell_ID] autorelease];	
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}	
	

	if (section == 0) {
		cell.textLabel.text = @"All Calendars";
	}

	
	else{
		section = section -1 ;
		NSIndexPath *fetchedIndex = [NSIndexPath indexPathForRow:row inSection:section];
		Calendar *aCalendar = (Calendar *)[self.fetchedResultsController objectAtIndexPath:fetchedIndex];
		UIColor *colorForCell = [UIColor colorWithHexString:aCalendar.color];
		
		Circle *circle_view = [[Circle alloc] initWithFrame:CGRectMake(20, 20, 15, 15) andColor:colorForCell];
		[cell addSubview:circle_view];
		[circle_view release];
		UILabel *calendar_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
		calendar_title.font =  [UIFont boldSystemFontOfSize:16];
		calendar_title.text = aCalendar.name;
		[cell addSubview:calendar_title];
		[calendar_title release];
	
	}


	
	return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[self.fetchedResultsController sections] count];
    

	count++;
	
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
	

	if (section >=  1){
		section = section -1 ;
	
		if ([[self.fetchedResultsController sections] count] > 0) {
			id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
		
			numberOfRows = [sectionInfo numberOfObjects];
			
		}
		
	}
    
	
   return numberOfRows;
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
	
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	
		NSLog(@"Unresolved error fetching calendars %@, %@", error, [error userInfo]);
		
	}
	
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
	self.managedObjectContext = nil;
	self.fetchedResultsController = nil;

}


- (void)dealloc {
	[managedObjectContext release];
	[fetchedResultsController release];
    [super dealloc];
}


@end

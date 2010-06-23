//
//  SelectCalendarForEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 10/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "SelectCalendarForEventViewController.h"
#import "Calendar.h"



@implementation SelectCalendarForEventViewController

@synthesize fetchedResultsController,lastIndexPath;

-(void)done{
	//self.event.note = self.noteTextView.text;
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}


#pragma mark -
#pragma mark Table View delegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	
	Calendar *acalendar = (Calendar *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	self.event.calendar = acalendar;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int newRow = [indexPath row];
    int oldRow = [lastIndexPath row];
	
	
	if (self.lastIndexPath!= nil && newRow != oldRow )
	{
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		lastIndexPath = indexPath;  
	}
	else{
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.lastIndexPath = indexPath;
		
		
	}
	
    	
}




#pragma mark -
#pragma mark Table View dataSource Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return @"Your Calendars";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = nil;

	static NSString *kcalendarCell_ID = @"calendarCell_ID";
	cell = [tableView dequeueReusableCellWithIdentifier:kcalendarCell_ID];	
	if( cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcalendarCell_ID] autorelease];			
		
	}	

	Calendar *aCalendar = (Calendar *)[fetchedResultsController objectAtIndexPath:indexPath];
	NSLog(@"calendar permision %@", aCalendar.edit_permission);
	if (self.event.calendar != nil && self.event.calendar.calid == aCalendar.calid){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.lastIndexPath = indexPath;
		}
	cell.textLabel.text = aCalendar.name;
	
	return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}




#pragma mark -
#pragma mark UIViewController functions

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = @"Calendar";
	self.navigationItem.prompt = @"Set the details for this event";
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.fetchedResultsController = nil;
	self.lastIndexPath = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[lastIndexPath release];
    [super dealloc];
}


@end

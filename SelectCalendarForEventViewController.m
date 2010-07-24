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


#import "SelectCalendarForEventViewController.h"
#import "Circle.h"
#import "UIColor+Extensions.h"
#import "Calendar.h"



@implementation SelectCalendarForEventViewController

@synthesize fetchedResultsController,lastIndexPath,selectCalendartableView;
@synthesize editingMode;

-(void)done{
	if (lastIndexPath){
	Calendar *acalendar = (Calendar *)[self.fetchedResultsController objectAtIndexPath:lastIndexPath];
	self.event.calendar = acalendar;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}


#pragma mark -
#pragma mark Table View delegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (!self.editingMode){
		
	

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
		NSLog(@"este es el valor %d",self.editingMode);
		if (self.editingMode)
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	}	

	Calendar *aCalendar = (Calendar *)[fetchedResultsController objectAtIndexPath:indexPath];
	if (self.event.calendar != nil && self.event.calendar.calid == aCalendar.calid){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.lastIndexPath = indexPath;
		}
	
	
	UIColor *colorForCell = [UIColor colorWithHexString:aCalendar.color];
	
	Circle *circle_view = [[Circle alloc] initWithFrame:CGRectMake(20, 20, 15, 15) andColor:colorForCell];
	[cell addSubview:circle_view];
	[circle_view release];
	UILabel *calendar_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
	calendar_title.font =  [UIFont boldSystemFontOfSize:16];
	calendar_title.text = aCalendar.name;
	[cell addSubview:calendar_title];
	[calendar_title release];
		
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
	self.selectCalendartableView = nil;
}

//- (void)viewWillAppear:(BOOL)animated{
//	[self.selectCalendartableView reloadData];	
//}


- (void)dealloc {
	[fetchedResultsController release];
	[lastIndexPath release];
	[selectCalendartableView release];
    [super dealloc];
}


@end

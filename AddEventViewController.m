//
//  AddEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 08/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "AddEventViewController.h"
#import "MonthCalendar.h"

#define kTextFieldWidth	277
#define kTextFieldHeight 31

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

static NSString *kCellIdentifier = @"cell_ID";
static NSString *kTitleKey = @"title";
static NSString *kViewControllerKey = @"viewController";
static NSString *kRowSizeKey =@"rowSizeKey";
static NSString *kNormalRowsizeKey =@"normalRowSizeKey";


@implementation AddEventViewController


@synthesize menuList;


- (void)addTitlePlaceEventViewController:(AddTitlePlaceEventViewController *)addTitlePlaceEventViewController 
				   didAddTitlePlaceEvent:(NSString *)eventId{
	NSLog(@"delegation for Title and place it's working");
	if ( [allTrim( eventId ) length] != 0 ){
		//[appDelegate addNewEvent:eventId];
		//[tableView reloadData];
		
	}
	
}

- (void)addNoteEventViewController:(AddNoteEventViewController *)addNoteEventViewController 
				   didAddNoteEvent:(NSString *)eventId{
	NSLog(@"delegation for Notes and place it's working");
	if ( [allTrim( eventId ) length] != 0 ){
		//[appDelegate addNewEvent:eventId];
		//[tableView reloadData];
		
	}
	
}

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [addElementsTableView indexPathForSelectedRow];
	[addElementsTableView deselectRowAtIndexPath:tableSelection animated:NO];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self initializeMenuList];
	
}



-(IBAction)save:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancel:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController *targetViewController = [[self.menuList objectAtIndex: indexPath.section] objectForKey:kViewControllerKey];
	[[self navigationController] pushViewController:targetViewController animated:YES];
}


#pragma mark -
#pragma mark Table View dataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [self.menuList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	NSString *normalHeightSize = [[self.menuList objectAtIndex:indexPath.section] objectForKey:kNormalRowsizeKey];
	
	if (normalHeightSize == @"NO") {
		
		cell = [self cellForNoNormalHeight:cell indexAt:indexPath];
	}
	
	else {
		
		cell = [self cellForNormalHeight:cell indexAt:indexPath];
	}

	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	CGFloat		result =  [[[self.menuList objectAtIndex:indexPath.section] objectForKey:kRowSizeKey] floatValue];
	return result;
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	
	self.menuList = nil;
	
}

- (void)dealloc {
	
	
	[self.menuList release];
    [super dealloc];
}




-(UITableViewCell *)cellForNoNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath {
	
	
	if (cell == nil)
	{
		cell = [self getCellContentView:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	
	if (indexPath.section == 0) {
		
		lblTemp1.text = @"Title";
		lblTemp2.text = @"Location";
		
	}
	else{
		lblTemp1.textColor = [UIColor blackColor];
		lblTemp1.font = [UIFont boldSystemFontOfSize:16];
		lblTemp2.textColor = [UIColor blackColor];
		lblTemp2.font = [UIFont boldSystemFontOfSize:16];
		lblTemp1.text = @"Starts";
		lblTemp2.text = @"Ends";			
	}
	return cell;
	
	
}

-(UITableViewCell *)cellForNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath {
	
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [[self.menuList objectAtIndex:indexPath.section] objectForKey:kTitleKey];
	
	return cell;
	
	
}



- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 5, 240, 20);
	CGRect Label2Frame = CGRectMake(10, 25, 240, 20);
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	//lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	return cell;
}

-(void) initializeMenuList{
	
	self.menuList = [NSMutableArray array];
	// for showing various UIButtons:
	AddTitlePlaceEventViewController *addTitlePlaceEventViewController = [[AddTitlePlaceEventViewController alloc]
																		  initWithNibName:@"AddTitlePlaceEventViewController" bundle:nil];
	addTitlePlaceEventViewController.delegate = self;
	[addTitlePlaceEventViewController.navigationItem setHidesBackButton:YES];
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Title and Place", kTitleKey,
							  addTitlePlaceEventViewController, kViewControllerKey,
							  @"54.0f", kRowSizeKey,
							  @"NO",kNormalRowsizeKey,
							  nil]];
	[addTitlePlaceEventViewController release];
	
	AddDateEventViewController *addDateViewController = [[AddDateEventViewController alloc] 
														 initWithNibName:@"AddDateEventViewController" bundle:nil];

	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Starts Ends", kTitleKey,
							  addDateViewController, kViewControllerKey,
							  @"54.0f", kRowSizeKey,
							  
							  @"NO",kNormalRowsizeKey,
							  nil]];
	[addDateViewController release];
	
	
	
	AddTitlePlaceEventViewController *addTitlePlaceEventViewController2 = [[AddTitlePlaceEventViewController alloc]
																		   initWithNibName:@"AddTitlePlaceEventViewController" bundle:nil];
	addTitlePlaceEventViewController2.delegate = self;
	
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Calendar", kTitleKey,
							  addTitlePlaceEventViewController2, kViewControllerKey,
							  @"44.0f", kRowSizeKey,
							  @"YES",kNormalRowsizeKey,
							  nil]];
	[addTitlePlaceEventViewController2 release];
	
	AddNoteEventViewController *addNoteEventViewController = [[AddNoteEventViewController alloc]
																initWithNibName:@"AddNoteEventViewController" bundle:nil];
	addNoteEventViewController.delegate = self;
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Notes", kTitleKey,
							  addNoteEventViewController, kViewControllerKey,
							  @"44.0f", kRowSizeKey,
							  @"YES",kNormalRowsizeKey,
							  nil]];
	[addNoteEventViewController release];
	
}



@end

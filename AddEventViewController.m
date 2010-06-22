//
//  AddEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 08/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//


#import "AddEventViewController.h"
#import "SelectCalendarForEventViewController.h"
#import "Event.h"


#import "MonthCalendar.h"
#define kTextFieldWidth	277
#define kTextFieldHeight 31

#define kTextFieldWidthForHour	180
#define kTextFieldHeightForHour 26


#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

static NSString *kCellIdentifier = @"cell_ID";
static NSString *kTitleKey = @"title";
static NSString *kViewControllerKey = @"viewController";
static NSString *kRowSizeKey =@"rowSizeKey";
static NSString *kNormalRowsizeKey =@"normalRowSizeKey";

//static inline BOOL IsEmpty(NST thing) {
//	NSLog(@"esto es todo: %i,%i ",thing == nil,[(NSData *)thing length] );
//	return thing == nil
//	|| ([thing respondsToSelector:@selector(length)]
//		&& [(NSData *)thing length] == 0)
//	|| ([thing respondsToSelector:@selector(count)]
//		&& [(NSArray *)thing count] == 0);
//}

@implementation AddEventViewController


@synthesize menuList;
@synthesize event;
@synthesize delegate;
@synthesize addElementsTableView;
@synthesize dateFormater;
@synthesize managedObjectContext, fetchedResultsController;

//
//- (void)addNoteEventViewController:(AddNoteEventViewController *)addNoteEventViewController didAddNoteEvent:(Event *)ievent{
//	
//	[self.navigationController popViewControllerAnimated:YES];
//	
//}


-(void)save{
	
	if (event.title == nil)
		event.title = @"New Event";
	
	[self.delegate addEventViewController:self didAddEvent:self.event];
}

-(void)cancel{
	
	[self.managedObjectContext deleteObject:event];
	
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {

		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

	}	
	
	[self.delegate addEventViewController:self didAddEvent:nil];
}


#pragma mark -
#pragma mark Table View dataSource delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSString *className = [[menuList objectAtIndex: indexPath.section] objectForKey:kViewControllerKey];
	Class viewControllerClass = NSClassFromString(className);
	AddCalendarEventViewController *targetViewController = [[viewControllerClass alloc] initWithNibName:className bundle:nil];	
	targetViewController.event = self.event;
	if ( [className isEqualToString:@"SelectCalendarForEventViewController"]) {
		((SelectCalendarForEventViewController *)targetViewController).fetchedResultsController = self.fetchedResultsController;
	}
	[self.navigationController pushViewController:targetViewController animated:YES];
	[targetViewController release];
	
}


#pragma mark -
#pragma mark Table View dataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [menuList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	NSString *normalHeightSize = [[menuList objectAtIndex:indexPath.section] objectForKey:kNormalRowsizeKey];

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
	
	CGFloat		result =  [[[menuList objectAtIndex:indexPath.section] objectForKey:kRowSizeKey] floatValue];
	return result;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	
    if (fetchedResultsController == nil) {
		
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
		
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;


        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
	
    }
	
	return fetchedResultsController;
}    


#pragma mark -
#pragma mark utility functions





-(UITableViewCell *)cellForNoNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath {
	
	
	if (cell == nil)
	{
		cell = [self getCellContentView:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	
	if (indexPath.section == 0) {
		
		if (self.event.title != nil && [self.event.title length] != 0)
			lblTemp1.text = self.event.title;
		else
			lblTemp1.text = @"Title";
		
		
		if (self.event.location != nil && [self.event.location length] != 0)
			lblTemp2.text = self.event.location;
		else
			lblTemp2.text = @"Place";

				
	}
	else{
		
		UILabel *hLabel1;
		
		//		UILabel *hLabel2 = (UILabel *)[cell viewWithTag:4];
		lblTemp1.textColor = [UIColor blackColor];
		lblTemp1.font = [UIFont boldSystemFontOfSize:16];
		lblTemp2.textColor = [UIColor blackColor];
		lblTemp2.font = [UIFont boldSystemFontOfSize:16];
		lblTemp1.text = @"Starts";
		lblTemp2.text = @"Ends";	
		
		[self startDateFormater];
		NSString *startDateString =[dateFormater stringFromDate:self.event.startDate]; 
	
		
		if( ![[cell contentView] viewWithTag:3] ){
	
			hLabel1 = [self newStartHourLabel:startDateString];
			hLabel1.tag = 3;
			[cell.contentView addSubview:hLabel1];
			[hLabel1 release];
			
		}
		
		else{			
			UILabel *alreadySetLabel = (UILabel *)[[cell contentView] viewWithTag:3];
			alreadySetLabel.text = startDateString;

		}
		
		[self endDateFormater];
		NSString *endDateString =[dateFormater stringFromDate:self.event.endDate]; 
		
		if( ![[cell contentView] viewWithTag:4] ){
			
			hLabel1 = [self newEndHourLabel:endDateString];
			hLabel1.tag = 4;
			[cell.contentView addSubview:hLabel1];
			[hLabel1 release];
			
		}
		else{			
			UILabel *alreadySetLabel = (UILabel *)[[cell contentView] viewWithTag:4];
			alreadySetLabel.text = endDateString;
		}
		
		
	}
	return cell;
	
	
}

-(UITableViewCell *)cellForNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath {
	
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [[menuList objectAtIndex:indexPath.section] objectForKey:kTitleKey];
	
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


- (UILabel *)newStartHourLabel:(NSString *)string{
	
	CGRect frame = CGRectMake(90, 2, kTextFieldWidthForHour, kTextFieldHeightForHour);
	UILabel *newHourLabel = [[UILabel alloc] initWithFrame:frame] ;
	//	label.highlightedTextColor = [UIColor whiteColor];
	newHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	newHourLabel.highlightedTextColor = [UIColor whiteColor];
	newHourLabel.textAlignment = UITextAlignmentRight;
	newHourLabel.font = [UIFont systemFontOfSize:16.0];
	newHourLabel.text = string;
	
	return newHourLabel;
	
}

- (UILabel *)newEndHourLabel:(NSString *)string{
	
	CGRect frame = CGRectMake(90, 22, kTextFieldWidthForHour, kTextFieldHeightForHour);
	UILabel *newHourLabel = [[UILabel alloc] initWithFrame:frame] ;
	//	label.highlightedTextColor = [UIColor whiteColor];
	newHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	newHourLabel.highlightedTextColor = [UIColor whiteColor];
	newHourLabel.textAlignment = UITextAlignmentRight;
	newHourLabel.font = [UIFont systemFontOfSize:16.0];
	newHourLabel.text = string;
	
	return newHourLabel;
	
}





-(void) initializeMenuList{
	
	menuList = [[NSMutableArray alloc] init];

	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Title and Place", kTitleKey,
							  @"AddTitlePlaceEventViewController", kViewControllerKey,
							  @"54.0f", kRowSizeKey,
							  @"NO",kNormalRowsizeKey,
							  nil]];


	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Starts Ends", kTitleKey,
							  @"AddDateEventViewController", kViewControllerKey,
							  @"54.0f", kRowSizeKey,
							  
							  @"NO",kNormalRowsizeKey,
							  nil]];

	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 @"Calendar", kTitleKey,
						 @"SelectCalendarForEventViewController", kViewControllerKey,
						 @"44.0f", kRowSizeKey,
						 @"YES",kNormalRowsizeKey,
						 nil]];

	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Notes", kTitleKey,
							  @"AddNoteEventViewController", kViewControllerKey,
							  @"44.0f", kRowSizeKey,
							  @"YES",kNormalRowsizeKey,
							  nil]];

	
}


- (void) startDateFormater{
//	if (wDaySelector.on){
		
//		[dateFormater setDateStyle:NSDateFormatterLongStyle];
//		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
//	}
//	else{
		[dateFormater setDateStyle:NSDateFormatterShortStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];
//		
//	}
	
	
}

- (void) endDateFormater{
	
//	if (wDaySelector.on){
		
//		[dateFormater setDateStyle:NSDateFormatterLongStyle];
//		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
//	}
//	else{
//		
		[dateFormater setDateStyle:NSDateFormatterNoStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];
//	}
//	
}

#pragma mark -
#pragma mark UIViewController Functions

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.menuList = nil;
	self.event = nil;
	addElementsTableView = nil;
	self.dateFormater = nil;
	self.managedObjectContext = nil;
	self.fetchedResultsController = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[menuList release];
	[event release];
	[addElementsTableView release];
	[dateFormater release];
	[fetchedResultsController release];
	[managedObjectContext release];

    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [addElementsTableView indexPathForSelectedRow];
	[addElementsTableView deselectRowAtIndexPath:tableSelection animated:NO];
	[addElementsTableView reloadData]; 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	dateFormater = [[NSDateFormatter alloc] init];
	[dateFormater setPMSymbol:@"p.m."];
	[dateFormater setAMSymbol:@"a.m."];
	[dateFormater setDateStyle:NSDateFormatterShortStyle];
	[dateFormater setTimeStyle:NSDateFormatterShortStyle];
	
	
	
	
	self.title = @"Add Event";
	self.navigationItem.prompt = @"Set the details for this event";
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error fetching calendars %@, %@", error, [error userInfo]);
		abort();
	}
	
	Calendar *aDefaultCalendar = self.event.calendar;
	if ( [fetchedResultsController.fetchedObjects count] > 0){
		if (!self.event.calendar){
		aDefaultCalendar = (Calendar *)[fetchedResultsController.fetchedObjects objectAtIndex:0];
		event.calendar = aDefaultCalendar;
		}
	}
	else   {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Calendars Found" message:@"We were not able to find any calendars for your google account. It's not possbile to create events" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
		// optional - add more buttons:
		[alert addButtonWithTitle:@"Ok"];
		[alert show];
		
	}

		//	
    [super viewDidLoad];
	[self initializeMenuList];
	
}




@end

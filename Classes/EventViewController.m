//
//  EventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
// 
//

#import "EventViewController.h"
#import "GoogleCalAppDelegate.h"
#import "Calendar.h"

@implementation EventViewController
@synthesize managedObjectContext;
@synthesize eventDetailTableView;





-(void)edit{
	
	AddEventViewController *addEventController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
	addEventController.delegate = self;
	Event *editEvent = self.event;	
	addEventController.event = editEvent;
	addEventController.managedObjectContext = self.managedObjectContext;
	addEventController.editingMode = YES;	
	UINavigationController *addNavController =  [[UINavigationController alloc] initWithRootViewController:addEventController];
	[self presentModalViewController:addNavController animated:YES];
	[addNavController release];
	[addEventController release];
	
}

- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event{
	if (event != nil){
		GoogleCalAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];	
		GDataServiceGoogleCalendar *service = appDelegate.gCalService;
		
		NSURL *editURL = [NSURL URLWithString:event.editLink ];
		GDataEntryCalendarEvent *entryToUpdate = [event eventGDataEntry];
		
		[service fetchEntryByUpdatingEntry:entryToUpdate
								   forEntryURL:editURL
									  delegate:self
							 didFinishSelector:@selector(updateTicket:updatedEntry:error:)];
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	
}

- (void)addEventViewController:(AddEventViewController *)addEventViewController didDeleteEvent:(Event *)event{
	

		[self.managedObjectContext deleteObject:event];
		NSError *error = nil;
		if (![self.managedObjectContext save:&error]) {
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
		}	

	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:NO];
	
	
	
	
}

#pragma mark -
#pragma mark Google Methods 


// event deleted callback
- (void)updateTicket:(GDataServiceTicket *)ticket
        updatedEntry:(GDataFeedCalendarEvent *)entry
               error:(NSError *)error {

	if (error != nil) {
		NSString *title, *msg;
		if( [error code]==kGDataBadAuthentication ){
			title = @"Authentication Failed";
			msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials. The event wasn't updated.";
		}else if ( [error code] == NSURLErrorNotConnectedToInternet ) {
			
			
			title = @"No internet access.";
			msg = @"The application couldn't connect to internet. Please check your internet access. The event wasn't updated.";
			
		}else{
			// some other error authenticating or retrieving the GData object or a 304 status
			// indicating the data has not been modified since it was previously fetched
			title = @"An unexpected error has ocurred.";
			msg = [error localizedDescription];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
		
	}
	else{
		self.event.etag = [entry ETag];
		self.event.updated = [[entry updatedDate] date];
	//	self.event.calendar.updated = [[entry updatedDate] date];
		NSError *core_data_error = nil;
		if (![self.managedObjectContext save:&core_data_error]) {
			NSLog(@"Unresolved error updating a event %@, %@", core_data_error, [core_data_error userInfo]);
			
		}
	
	
	}

	

}


#pragma mark -
#pragma mark Table View dataSource Methods

-(NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {

		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCell_ID = @"eventCell"; 
	CGSize theSize;
	NSString *str;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_ID];


	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCell_ID] autorelease];
	}
	CGRect frame = CGRectMake(20, 5, 250.0f, 20.0f);
//	NSString *str = [NSString stringWithFormat:@"What: %@",
//					 self.event.title];
	//frame.size.height = 40.0f;
	

	theSize= [self stringSize:self.event.title withFont:[UIFont boldSystemFontOfSize:18.0f] andWidth:250.0f];
		
	
	frame.size.height =theSize.height;
	
	
	//NSLog(@"frame size heightdddd %f", ( );
	UILabel *eventDetails = [[UILabel alloc] initWithFrame:frame];

	eventDetails.font =  [UIFont boldSystemFontOfSize:18.0f];
	eventDetails.textAlignment = UITextAlignmentCenter;
	eventDetails.numberOfLines = 5;
	eventDetails.text = self.event.title;
	
	[cell addSubview:eventDetails];
	[eventDetails release];
	frame.origin.y += frame.size.height +10;
	frame.size.height = 20;
	
	if (! (self.event.location == NULL  || [  self.event.location  isEqualToString:@""])){
		str = [NSString stringWithFormat:@"Where: %@",
			   self.event.location];
		frame.size.height = ([self stringSize:str withFont:[UIFont boldSystemFontOfSize:16.0f] andWidth:250.0f] ).height;
		eventDetails = [[UILabel alloc] initWithFrame:frame];
		eventDetails.numberOfLines = 5;
		eventDetails.text = str;
		
		[cell addSubview:eventDetails];
		[eventDetails release];
		frame.origin.y += frame.size.height;
		frame.size.height = 20;
	}
	
	//when
	//frame.origin.y += 25; 

	eventDetails = [[UILabel alloc] initWithFrame:frame];
	NSDate *startDate = self.event.startDate;
	NSDate *endDate = self.event.endDate;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setPMSymbol:@"p.m."];
	[dateFormatter setAMSymbol:@"a.m."];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	//[dateFormatter setDateFormat:@"HH:mm"];
	NSString *startDateString = [dateFormatter stringFromDate:startDate];
	NSString *endDateString = [dateFormatter stringFromDate:endDate];
	//str = [NSString stringWithFormat:@"When:",startDateString, endDateString];
	eventDetails.text = @"When:";
	[cell addSubview:eventDetails];
	[eventDetails release];
	
	//frame.origin.y += 20; 
	frame.origin.x += 55;
	frame.size.width -= 55.0f;
	eventDetails = [[UILabel alloc] initWithFrame:frame];
	eventDetails.text =startDateString;
	[cell addSubview:eventDetails];
	[eventDetails release];
	
	frame.origin.y += 20;
	eventDetails = [[UILabel alloc] initWithFrame:frame];
	eventDetails.text =endDateString;
	[cell addSubview:eventDetails];
	[eventDetails release];
	
	//description
	frame.size.width += 55.0f;
	frame.origin.x -= 55;
	if (! ( self.event.note == NULL  || [self.event.note isEqualToString:@""])){
	frame.origin.y += 25; 
	eventDetails = [[UILabel alloc] initWithFrame:frame];
	eventDetails.text = @"Description:";
	
	[cell addSubview:eventDetails];
	[eventDetails release];
	frame.origin.x += 55;
	frame.size.width -= 55.0f;
	frame.origin.y += 20; 
	frame.size.height = ([self stringSize:self.event.note withFont:[UIFont boldSystemFontOfSize:16.0f] andWidth:175.0f]).height;
	eventDetails = [[UILabel alloc] initWithFrame:frame];
	eventDetails.textColor = [UIColor grayColor];
	eventDetails.numberOfLines = 10;
	eventDetails.text = self.event.note;
	
	[cell addSubview:eventDetails];
	[eventDetails release];
		
	}
  //  cell.textLabel.text = self.event.title;
	

	return cell;
}

#pragma mark -
#pragma mark UITableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat location = 0.0f; 
	CGFloat note = 0.0f; 
	CGFloat title = ([self stringSize:self.event.title withFont:[UIFont boldSystemFontOfSize: 18] andWidth:250.0f ]).height ;
	if (! (self.event.location == NULL || [self.event.location isEqualToString:@""])){
		location = 20.0f;
		NSString *str = [NSString stringWithFormat:@"Where: %@",self.event.location];
		location +=  ([self stringSize:str withFont:[UIFont systemFontOfSize: 16] andWidth:250.0f]).height;
		}
	
	if (!(self.event.note == NULL || [self.event.note isEqualToString:@""])){
		note = 40.0f;
		note += ([self stringSize:self.event.note withFont:[UIFont systemFontOfSize: 16] andWidth:175.0f]).height;
	}
	
	return  65.0 + location + title + note;
}
#pragma mark -
#pragma mark utility functions

-(CGSize) stringSize:(NSString *)text withFont:(UIFont *)font andWidth:(CGFloat)width {
	return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	
}

#pragma mark -
#pragma mark UIViewController functions



- (void)viewWillAppear:(BOOL)flag{

	
	
}

- (void)viewDidAppear:(BOOL)animated{
	

	//add code to put the month
	//self.navigationController.navigationBar.backItem.title = @"June";
}



-(void)viewDidLoad{
	self.title = @"Event";
	Calendar *event_calendar = self.event.calendar;
	
	if (event_calendar && [event_calendar.edit_permission boolValue]){
		UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
		self.navigationItem.rightBarButtonItem = editButtonItem;
		[editButtonItem release];
	}
    [super viewDidLoad];	
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.eventDetailTableView = nil;
	self.managedObjectContext = nil;

}


- (void)dealloc {
	[managedObjectContext release];
	[eventDetailTableView release];
    [super dealloc];
}


@end

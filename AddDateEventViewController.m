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


#import "AddDateEventViewController.h"


#define kTextFieldWidth	180
#define kTextFieldHeight 31


@implementation AddDateEventViewController


@synthesize wDaySelector,dateSelect,endDate,startDate,dateFormater,startHourLabel,endHourLabel,dtableView;




-(void)done{
	if ( [self.endDate compare:self.startDate ] ==  NSOrderedAscending) {
		

		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"checkDateKey", @"Check start and end date") 
														 message:NSLocalizedString(@"checkDateMsgKey", @"The end date selected is before start date. Please check your date.") 
														 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];

	
		[alert show];
		
	}
	else{
		self.event.startDate = self.startDate;
		self.event.endDate = self.endDate;
		[self.navigationController popViewControllerAnimated:YES];
	}

}


-(void)cancel{
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) dateChanged:(UIDatePicker *)sender{
	
	if (rowSelected == 0){		
		NSTimeInterval interval = [self.endDate timeIntervalSinceDate: self.startDate];
		self.startDate = [self.dateSelect date];
		NSDate *newEndDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.startDate]; 
		self.endDate =newEndDate;
	
		[newEndDate release];
		
		[self startHourBehavior];
		
	}
	else{
		
		self.endDate = [self.dateSelect date];
		[self endHourBehavior];

	}
}

- (void) switchChange:(UISwitch *)sender{
	
	
	if (wDaySelector.on) {
		
		[self startDateFormater];
		// it's the same for ] both not neccesary to do this.
		//[self endDateFormater];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		NSString *startDateString = [dateFormater stringFromDate:startDate];
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		self.dateSelect.datePickerMode = UIDatePickerModeDate;
	}
	
	else {
		
		[self startDateFormater];
		NSString *startDateString = [dateFormater stringFromDate:startDate];
		[self endDateFormater];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		self.dateSelect.datePickerMode = UIDatePickerModeDateAndTime;
		
	}
	
}


#pragma mark -
#pragma mark Table View delegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	//rowSelected = indexPath;
	if (row == 0) {
		rowSelected = 0;
		[self.dateSelect setDate:startDate animated:YES];
		[self startHourBehavior];

	}
	else{	
		rowSelected = 1;
		[self.dateSelect setDate:endDate animated:YES];
		[self endHourBehavior];
	}
	
	
}


#pragma mark -
#pragma mark Table View dataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = nil;
	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		
		static NSString *kstartDateCell_ID = @"startDateCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kstartDateCell_ID];
		
		if( cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kstartDateCell_ID] autorelease];			
		}		
		
		[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
		NSString *startDateString =[dateFormater stringFromDate:startDate]; 
		cell.textLabel.text = NSLocalizedString(@"startsKey", @"Starts"); 
		UILabel *hLabel = [self initStartHourLabelWithHourString:startDateString];
		[cell.contentView addSubview:hLabel];
		
	}
	else if (row == 1) {
		
		static NSString *kendDateCell_ID = @"endDateCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kendDateCell_ID];
		if( cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kendDateCell_ID] autorelease];
		}
		[self endHourBehavior];
		NSString *endDateString = [dateFormater stringFromDate:endDate];
		
		
		cell.textLabel.text = NSLocalizedString(@"endsKey", @"Ends"); 
		UILabel *hLabel = [self initEndHourLabelWithHourString:endDateString];
		[cell.contentView addSubview:hLabel];
		
	}
	
	else{
		
		static NSString *kwholeDayCell_ID = @"wholeDayCell";
		cell = [tableView dequeueReusableCellWithIdentifier:kwholeDayCell_ID];
		
		if (cell == nil) {
			cell = [self getCellForWholeDay:kwholeDayCell_ID];
		}
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//normally is 3 this is for this version all Day behavior is nil
	return 2;
}

#pragma mark -
#pragma mark utility functions

- (void) startHourBehavior {
	Boolean diffrenceGreaterThan24h = [self checkStartEndHourDifference];
	[self startDateFormater];
	if (diffrenceGreaterThan24h == YES) {
		
		endHourLabel.text = [dateFormater stringFromDate:endDate];	
		endHourLabel.textColor = [self labelColor];
		startHourLabel.text = [dateFormater stringFromDate:startDate];	
		
		
	}
	else{
		startHourLabel.text = [dateFormater stringFromDate:startDate];	
		[self endDateFormater];
		endHourLabel.text = [dateFormater stringFromDate:endDate];	
		endHourLabel.textColor = [self labelColor];
	}
	
}


- (void) endHourBehavior {
	Boolean diffrenceGreaterThan24h = [self checkStartEndHourDifference];
	[self endDateFormater];
	if (diffrenceGreaterThan24h == YES) {
		[self startDateFormater];
		startHourLabel.textColor = [self labelColor];
		endHourLabel.text = [dateFormater stringFromDate:endDate];
	}
	else {
		[self endDateFormater];
		startHourLabel.textColor = [self labelColor];
		endHourLabel.text = [dateFormater stringFromDate:endDate];
	}
	
}

- (UITableViewCell *) getCellForWholeDay:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 12, 120, 20);
	
	UILabel *lblTemp;
	UISwitch *switchTemp;
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.font = [UIFont boldSystemFontOfSize:16];
	lblTemp.text = NSLocalizedString(@"wholeDayKey", @"Whole day");
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Switch
	switchTemp = self.wDaySelector;
	[cell.contentView addSubview:switchTemp];
	cell.accessoryView = wDaySelector;
	[(UISwitch *)cell.accessoryView setOn:NO];   
	
	
	
	
	return cell;
}

- (UISwitch *)wDaySelector{
	if (	wDaySelector == nil ) {
		
		CGRect SwitchFrame = CGRectMake(195, 9, 40, 40);
		wDaySelector = [[UISwitch alloc] initWithFrame:SwitchFrame];
		[wDaySelector addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
	}
	
	
	return wDaySelector;
}


- (UILabel *)initStartHourLabelWithHourString:(NSString *)string{
	if (startHourLabel == nil){
		CGRect frame = CGRectMake(110, 8, kTextFieldWidth, kTextFieldHeight);
		startHourLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		//	label.highlightedTextColor = [UIColor whiteColor];
		startHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		startHourLabel.highlightedTextColor = [UIColor whiteColor];
		startHourLabel.textAlignment = UITextAlignmentRight;
		startHourLabel.font = [UIFont systemFontOfSize:18.0];
		startHourLabel.text = string;
	}
	return startHourLabel;
	
}


- (UILabel *)initEndHourLabelWithHourString:(NSString *)string{
	if (endHourLabel == nil){
		CGRect frame = CGRectMake(110, 8, kTextFieldWidth, kTextFieldHeight);
		endHourLabel = [[UILabel alloc] initWithFrame:frame];
		//	label.highlightedTextColor = [UIColor whiteColor];
		endHourLabel.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		endHourLabel.highlightedTextColor = [UIColor whiteColor];
		endHourLabel.textAlignment = UITextAlignmentRight;
		endHourLabel.font = [UIFont systemFontOfSize:18.0];
		endHourLabel.text = string;
	}
	return endHourLabel;
}

- (void) startDateFormater{
	if (wDaySelector.on){
		
		[dateFormater setDateStyle:NSDateFormatterLongStyle];
		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
	}
	else{
		[dateFormater setDateStyle:NSDateFormatterShortStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];
		
	}
	
	
}

- (void) endDateFormater{
	
	if (wDaySelector.on){
		
		[dateFormater setDateStyle:NSDateFormatterLongStyle];
		[dateFormater setTimeStyle:NSDateFormatterNoStyle];
		
	}
	else{
		
		[dateFormater setDateStyle:NSDateFormatterNoStyle];
		[dateFormater setTimeStyle:NSDateFormatterShortStyle];
	}
	
}

- (UIColor *) labelColor{
	
	NSComparisonResult startLaterThanEnd = [startDate compare:endDate];
	if (startLaterThanEnd == NSOrderedDescending){
		return [UIColor redColor];
		
	}
	else{
		return [UIColor blackColor];
	}
	
}

- (Boolean) checkStartEndHourDifference{

	NSTimeInterval diff = [endDate timeIntervalSinceDate:startDate];
	if (diff > 86400.00 || diff < -86400.00) 
		return YES	;
	else
		return NO;
	
}

#pragma mark -
#pragma mark UIViewController functions

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidLoad {

	dateFormater = [[NSDateFormatter alloc] init];
	[dateFormater setPMSymbol:@"p.m."];
	[dateFormater setAMSymbol:@"a.m."];
	[dateFormater setDateStyle:NSDateFormatterShortStyle];
	[dateFormater setTimeStyle:NSDateFormatterShortStyle];
	self.startDate = self.event.startDate;

	self.endDate = self.event.endDate;
	dtableView.scrollEnabled= NO;
	
	self.title = NSLocalizedString(@"startsAndEndsKey", @"Starts & Ends");
	self.navigationItem.prompt = NSLocalizedString(@"detailsKey", @"Set the details for this event");
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"doneKey", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	
	
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
	[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	[self.dateSelect setDate:self.startDate animated:NO];
    
	
}


- (void)viewDidUnload {
	
	self.wDaySelector = nil;
	self.startHourLabel = nil;
	self.endHourLabel = nil;
	self.dateFormater = nil;
	self.startDate = nil;
	self.endDate = nil;
	self.dateSelect = nil;
	//	self.dtableView = nil;
	
}

- (void)dealloc {
	[wDaySelector release];
	[startHourLabel release];
	[endHourLabel release];
	[dateFormater release];
	[startDate release];
	[endDate release];
	[dateSelect release];
	//	[dtableView release];
	
    [super dealloc];
}


@end

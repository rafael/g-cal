//
//  AddDateEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "AddDateEventViewController.h"

#define kTextFieldWidth	155
#define kTextFieldHeight 31


@implementation AddDateEventViewController

@synthesize wDaySelector,dateSelect,endDate,startDate,dateFormatter,startHourLabel,endHourLabel,dtableView;

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
	NSTimeInterval one_hour = 3600; 
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setPMSymbol:@"p.m."];
	[dateFormatter setAMSymbol:@"a.m."];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	startDate = [[NSDate alloc] init];
	[dateSelect setDate:startDate animated:NO];
	endDate = [[NSDate alloc] initWithTimeInterval:one_hour sinceDate:startDate]; 

    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
	[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	[self.dateSelect setDate:[NSDate date] animated:YES];
    
     
}

-(IBAction)done:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
//    if ([delegate respondsToSelector:@selector(addNoteEventViewController:didAddNoteEvent:)]) {
//        [delegate addNoteEventViewController:self didAddNoteEvent:noteTextView.text];
//    }
}


-(IBAction)cancel:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) switchChange:(UISwitch *)sender{

	
	if (wDaySelector.on) {
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSString *endDateString = [dateFormatter stringFromDate:endDate];
		NSString *startDateString = [dateFormatter stringFromDate:startDate];
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		dateSelect.datePickerMode = UIDatePickerModeDate;
	}
	else {
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
		NSString *startDateString = [dateFormatter stringFromDate:startDate];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		NSString *endDateString = [dateFormatter stringFromDate:endDate];
		
		startHourLabel.text = startDateString;
		endHourLabel.text = endDateString;
		
		dateSelect.datePickerMode = UIDatePickerModeDateAndTime;
		
	}
	
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	wDaySelector = nil;
	dateSelect = nil;
	startDate = nil;
	endDate = nil;
	dateFormatter = nil;
	endHourLabel = nil;
	startHourLabel = nil;
	dtableView = nil;
}


- (void)dealloc {
	[wDaySelector release];
	[startHourLabel release];
	[endHourLabel release];
	[dateSelect release];
	[startDate release];
	[endDate release];
	[dateFormatter release];
	[dtableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	if (row == 0) {
		
		[dateSelect setDate:startDate animated:YES];
		
	
	}
	else{		
		
		[dateSelect setDate:endDate animated:YES];

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

////		
////		
//	//	startDate = [NSDate date];
		[dtableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];

		NSString *startDateString =[dateFormatter stringFromDate:startDate]; 
		
		
////	
		
		cell.textLabel.text = [NSString stringWithFormat:@"Starts"]; 
		UILabel *hLabel = [self initStartHourLabelWithHourString:startDateString];
		[cell.contentView addSubview:hLabel];
		
	}
	else if (row == 1) {
	
		static NSString *kendDateCell_ID = @"endDateCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kendDateCell_ID];
		if( cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kendDateCell_ID] autorelease];
		}
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		NSString *endDateString = [dateFormatter stringFromDate:endDate];
		
		
		cell.textLabel.text = [NSString stringWithFormat:@"Ends"]; 
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
	return 3;
}

#pragma mark -
#pragma mark utility functions

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
	lblTemp.text = @"Whole day";
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
// deprecated
//- (UILabel *)hourLabel:(NSString *)hourString{
//	CGRect frame = CGRectMake(140, 8, kTextFieldWidth, kTextFieldHeight);
//	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
//	//	label.highlightedTextColor = [UIColor whiteColor];
//	label.textColor =  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
//	label.highlightedTextColor = [UIColor whiteColor];
//	label.textAlignment = UITextAlignmentRight;
//	label.font = [UIFont systemFontOfSize:18.0];
//	label.text = hourString;
//	return label;
//}

- (UILabel *)initStartHourLabelWithHourString:(NSString *)string{
	if (startHourLabel == nil){
		CGRect frame = CGRectMake(135, 8, kTextFieldWidth, kTextFieldHeight);
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
			CGRect frame = CGRectMake(135, 8, kTextFieldWidth, kTextFieldHeight);
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



@end

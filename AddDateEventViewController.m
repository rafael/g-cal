//
//  AddDateEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "AddDateEventViewController.h"


@implementation AddDateEventViewController

@synthesize wDaySelector,dateSelect;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
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
		dateSelect.datePickerMode = UIDatePickerModeDate;
	}
	else {
		dateSelect.datePickerMode = UIDatePickerModeDateAndTime;
		
	}
	
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.wDaySelector = nil;
	self.dateSelect = nil;
}


- (void)dealloc {
	
	[self.wDaySelector release];
	[self.dateSelect release];
    [super dealloc];
}




#pragma mark -
#pragma mark Table View dataSource Methods



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kDateCell_ID = @"dateCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDateCell_ID];

	if (cell == nil) {
		cell = [self getCellForWholeDay:kDateCell_ID];
	}

	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
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
	[(UISwitch *)cell.accessoryView setOn:NO];   // Or NO, obviously!
//	[(UISwitch *)cell.accessoryView addTarget:self action:@selector(switchChange)
//	 forControlEvents:UIControlEventValueChanged];
////	

	
	
	

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



@end

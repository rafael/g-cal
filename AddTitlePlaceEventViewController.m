//
//  AddEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 17/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import "AddTitlePlaceEventViewController.h"
#import "MonthCalendar.h"

#define kTextFieldWidth	277
#define kTextFieldHeight 31



@implementation AddTitlePlaceEventViewController

@synthesize delegate,placeTextField,titleTextField;





-(IBAction)save:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    if ([delegate respondsToSelector:@selector(addTitlePlaceEventViewController:didAddTitlePlaceEvent:)]) {
		
        [delegate addTitlePlaceEventViewController:self didAddTitlePlaceEvent:titleTextField.text];
    }
}

-(IBAction)cancel:(id)sender{
	
 [self.navigationController popViewControllerAnimated:YES];
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = nil;
	NSUInteger row = [indexPath row];
	
	
	if (row == 0) {
		static NSString *kTitleCell_ID = @"TitleCell_ID";
	
		cell = [tableView dequeueReusableCellWithIdentifier:kTitleCell_ID];
		
		if( cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTitleCell_ID] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
		else{
			// a cell is being recycled, remove the old edit field (if it contains one of our tagged edit fields)
			UIView *viewToCheck = nil;
			viewToCheck = [cell.contentView viewWithTag:1];
			if (!viewToCheck)
				[viewToCheck removeFromSuperview];
		}
		
	
				
		[cell.contentView addSubview:titleTextField];
	
			
	
	}
	else{
		
		static NSString *kPlaceCell_ID = @"PlaceCell_ID";
		cell = [tableView dequeueReusableCellWithIdentifier:kPlaceCell_ID];
		if (cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceCell_ID] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		else{
			// a cell is being recycled, remove the old edit field (if it contains one of our tagged edit fields)
			UIView *viewToCheck = nil;
			viewToCheck = [cell.contentView viewWithTag:2];
			if (!viewToCheck)
				[viewToCheck removeFromSuperview];
		}
		
		UITextField *textField = self.placeTextField;
		[cell.contentView addSubview:textField];
		
		
	}
	
	return cell;
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [titleTextField becomeFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 2;
}



- (UITextField *)titleTextField{
	if (titleTextField == nil)
	{
		CGRect frame = CGRectMake(13, 5, kTextFieldWidth, kTextFieldHeight);
		titleTextField = [[UITextField alloc] initWithFrame:frame];
		titleTextField.borderStyle = UITextBorderStyleNone;
		titleTextField.textColor = [UIColor blackColor];
		titleTextField.font = [UIFont systemFontOfSize:18.0];
		titleTextField.placeholder = @"Title";
		titleTextField.backgroundColor = [UIColor whiteColor];
		titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;	
		titleTextField.keyboardType = UIKeyboardTypeDefault;	
		titleTextField.returnKeyType = UIReturnKeyDefault;
		titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	
		titleTextField.tag = 1;		
		titleTextField.delegate = self;		
		// Add an accessibility label that describes what the text field is for.
		[titleTextField setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return titleTextField;
}


- (UITextField *)placeTextField{
	if (placeTextField == nil)
	{
		CGRect frame = CGRectMake(13, 5, kTextFieldWidth, kTextFieldHeight);
		placeTextField = [[UITextField alloc] initWithFrame:frame];
		placeTextField.borderStyle = UITextBorderStyleNone;
		placeTextField.textColor = [UIColor blackColor];
		placeTextField.font = [UIFont systemFontOfSize:18.0];
		placeTextField.placeholder = @"Place";
		placeTextField.backgroundColor = [UIColor whiteColor];
		placeTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		placeTextField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		placeTextField.returnKeyType = UIReturnKeyDefault;
		placeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		placeTextField.tag = 2;		// tag this control so we can remove it later for recycled cells
		placeTextField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed		
		// Add an accessibility label that describes what the text field is for.
		[placeTextField setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return placeTextField;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//	titleTextField = self.titleTextField;
//	[titleTextField becomeFirstResponder];
	
	titleTextField = self.titleTextField;
	

}



#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	
	if(textField.tag ==1){
		[placeTextField becomeFirstResponder];
		
	}
	else{
		[textField resignFirstResponder];
		
	}
	return YES; // We do not want UITextField to insert line-breaks.
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[super viewDidUnload];
	[placeTextField release];
	placeTextField = nil;
	[titleTextField release];
	titleTextField = nil;

}


- (void)dealloc {
	[placeTextField release];
	[titleTextField release];

    [super dealloc];
}


@end

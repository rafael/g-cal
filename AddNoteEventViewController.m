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


#import "AddNoteEventViewController.h"


@implementation AddNoteEventViewController
@synthesize  noteTextView;



-(void)done{
		self.event.note = self.noteTextView.text;
		[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
	
	    [self.navigationController popViewControllerAnimated:YES];

}



//#pragma mark -
//#pragma mark UITextViewDelegate
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//	
//	NSLog(@"entre aqui donde creo que entreo");
////	if(textField.tag ==1){
////		[placeTextField becomeFirstResponder];
////		
////	}
////	else{
////		[self done];
////		
////	}
//	//return YES; // We do not want UITextField to insert line-breaks.
//	
//}



#pragma mark -
#pragma mark Table View dataSource Methods



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kNoteCell_ID = @"noteCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCell_ID];
	
	if (cell == nil) {
		
		CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	

		cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:kNoteCell_ID] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

	}
	UITextView *textView = self.noteTextView;
	[cell.contentView addSubview:textView];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat		result = 150.0f;
	return result;
}

#pragma mark -
#pragma mark Utility functions
- (UITextView *)noteTextView{
	if (noteTextView == nil)
	{
		CGRect frame = CGRectMake(10, 5, 280, 140);
		noteTextView = [[UITextView alloc] initWithFrame:frame];
		noteTextView.textColor = [UIColor blackColor];
		noteTextView.font = [UIFont systemFontOfSize:18.0];
		noteTextView.keyboardType = UIKeyboardTypeDefault;	
		noteTextView.returnKeyType = UIReturnKeyDefault;
		
				

	}	
	return noteTextView;
}

#pragma mark -
#pragma mark UIViewController functions
- (void)viewDidLoad {
	self.title = @"Description";
	self.navigationItem.prompt = @"Set the details for this event";
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	[self noteTextView]; //to become first responder
	self.noteTextView.delegate = self;
	
	if (self.event.note != nil & [ self.event.note length] != 0)
		self.noteTextView.text = self.event.note;
	
    [super viewDidLoad];
	
}


- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [noteTextView becomeFirstResponder];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.noteTextView = nil;
	
}


- (void)dealloc {
	
	[noteTextView release];
    [super dealloc];
}


@end

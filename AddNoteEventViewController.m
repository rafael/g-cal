//
//  AddNoteEventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 17/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "AddNoteEventViewController.h"

@implementation AddNoteEventViewController
@synthesize  noteTextView;



-(void)done{
       [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
	
	    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad {
	self.title = @"Add Note";
	self.navigationItem.prompt = @"Set the details for this event";
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	[self noteTextView]; //to become first responder

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

- (UITextView *)noteTextView{
	if (noteTextView == nil)
	{
		CGRect frame = CGRectMake(10, 5, 280, 140);
		noteTextView = [[UITextView alloc] initWithFrame:frame];
		noteTextView.textColor = [UIColor blackColor];
		noteTextView.font = [UIFont systemFontOfSize:18.0];
		noteTextView.keyboardType = UIKeyboardTypeDefault;	
		noteTextView.returnKeyType = UIReturnKeyDefault;
		
		noteTextView.delegate = self;		

	}	
	return noteTextView;
}

@end

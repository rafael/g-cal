//
//  EventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
// 
//

#import "EventViewController.h"

@implementation EventViewController





-(void)edit{
	//self.event.note = self.noteTextView.text;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View dataSource Methods

-(NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {

		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCell_ID = @"eventCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_ID];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCell_ID] autorelease];
	}
	
    cell.textLabel.text = self.event.title;
	

	return cell;
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
	
   
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    [editButtonItem release];
	
	
    [super viewDidLoad];	
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}


@end

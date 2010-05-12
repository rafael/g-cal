//
//  EventViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
// 
//

#import "EventViewController.h"

@implementation EventViewController

@synthesize eventinformation;

-(void) loadEvent{
	//NSLog(@"Si voy bien %@", eventTableView);
	
	[eventTableView reloadData];
}

#pragma mark -
#pragma mark Table View dataSource Methods

-(NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	//NSLog("TENGO TANTOS %@", [self.eventinformation count]);
		return [self.eventinformation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCell_ID = @"eventCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_ID];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCell_ID] autorelease];
	}
	
	cell.textLabel.text = [self.eventinformation objectAtIndex:indexPath.row];
	return cell;
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

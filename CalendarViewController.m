//
//  CalendarViewController.m
//  GoogleCal
//
//  Created by Rafael Chacon on 15/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "CalendarViewController.h"
#import "Calendar.h"

@implementation CalendarViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;




#pragma mark -
#pragma mark Table View dataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return @"Prueba";
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//	return [menuList count];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	static NSString *kCell_ID = @"calendarCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_ID];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCell_ID] autorelease];
	}
	
    cell.textLabel.text = @"primera celda";
	
	
	return cell;
	
}



#pragma mark -
#pragma mark UIViewController functions



- (void)viewDidLoad {
	
	self.title = @"Calendars";
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}


@end

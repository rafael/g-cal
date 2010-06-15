//
//  EventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"

@interface EventViewController :  AddCalendarEventViewController <UITableViewDataSource> {
	
	IBOutlet UITableView *eventTableView;

}




-(void)edit;

@end

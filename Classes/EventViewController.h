//
//  EventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCalendarEventViewController.h"
#import "AddEventViewController.h"


@interface EventViewController :  AddCalendarEventViewController <AddEventDelegate,UITableViewDataSource> {
	@private
		NSManagedObjectContext *managedObjectContext;


}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



-(void)edit;
- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event;

@end

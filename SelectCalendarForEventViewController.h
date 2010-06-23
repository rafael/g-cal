//
//  SelectCalendarForEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 10/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCalendarEventViewController.h"


@interface SelectCalendarForEventViewController : AddCalendarEventViewController  <UITableViewDataSource, UITableViewDelegate> {
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSIndexPath     *lastIndexPath;
	
}
@property(nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
-(void)done;
-(void)cancel;

@end

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


@interface EventViewController :  AddCalendarEventViewController <AddEventDelegate,UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *eventDetailTableView;
	@private
		NSManagedObjectContext *managedObjectContext;


}
@property (nonatomic,retain ) IBOutlet UITableView *eventDetailTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



-(void)edit;
- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event;
- (void)addEventViewController:(AddEventViewController *)addEventViewController didDeleteEvent:(Event *)event;
-(CGSize) stringSize:(NSString *)text withFont:(UIFont *)font andWidth:(CGFloat)width;

@end

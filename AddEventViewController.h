//
//  AddEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonthCalendar;
@class AddEventViewController;


@protocol AddEventDelegate <NSObject>

@required

- (void)addEventViewController:(AddEventViewController *)addEventViewController 
				   didAddEvent:(NSString *)eventId;

@end


@interface AddEventViewController : UIViewController<UITableViewDataSource> {
	id <AddEventDelegate> delegate;
	IBOutlet UITextField *titleTextField;
	IBOutlet UITableViewCell *titlePlacetextFieldCell;	
}


@property (nonatomic, assign) id <AddEventDelegate> delegate;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;


@end

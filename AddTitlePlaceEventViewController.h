//
//  AddEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonthCalendar;
@class AddTitlePlaceEventViewController;

@protocol AddEventDelegate <NSObject>

@required

- (void)addTitlePlaceEventViewController:(AddTitlePlaceEventViewController *)addTitlePlaceEventViewController 
				   didAddTitlePlaceEvent:(NSString *)eventId;

@end


@interface AddTitlePlaceEventViewController : UIViewController<UITableViewDataSource, UITextFieldDelegate> {
	id <AddEventDelegate> delegate;
	UITextField *titleTextField;
	UITextField *placeTextField;
}


@property (nonatomic, assign) id <AddEventDelegate> delegate;
@property (nonatomic, retain, readonly) UITextField	*placeTextField;
@property (nonatomic, retain, readonly) UITextField	*titleTextField;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;


@end

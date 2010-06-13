//
//  AddEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCalendarEventViewController.h"




@interface AddTitlePlaceEventViewController : AddCalendarEventViewController <UITableViewDataSource, UITextFieldDelegate> {

	UITextField *titleTextField;
	UITextField *placeTextField;
}


@property (nonatomic, retain) UITextField	*placeTextField;
@property (nonatomic, retain) UITextField	*titleTextField;

-(void)done;
-(void)cancel;


@end



//
//  AddDateEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddDateEventViewController : UIViewController<UITableViewDataSource> {
	IBOutlet UIDatePicker *dateSelect;
	UISwitch *wDaySelector;

}
-(IBAction)cancel:(id)sender;

@property (nonatomic, retain) UISwitch *wDaySelector;
@property (nonatomic, retain) IBOutlet UIDatePicker *dateSelect;



-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

- (UITableViewCell *) getCellForWholeDay:(NSString *)cellIdentifier;

- (void) switchChange:(UISwitch *)sender;  
@end


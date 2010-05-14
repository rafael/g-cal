//
//  AddDateEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface AddDateEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	UIDatePicker *dateSelect;
	UISwitch *wDaySelector;
	NSDate *startDate;
	NSDate *endDate;
	NSDateFormatter *dateFormatter;
	UILabel *endHourLabel;
	UILabel *startHourLabel;
	UITableView *dtableView;
	
	
	

}
-(IBAction)cancel:(id)sender;

@property (nonatomic, retain) UISwitch *wDaySelector;
@property (nonatomic, retain) UILabel *startHourLabel;
@property (nonatomic, retain) UILabel *endHourLabel;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *dateSelect;
@property (nonatomic, retain) IBOutlet UITableView *dtableView;


-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;
-(UILabel*) initStartHourLabelWithHourString:(NSString *)string;
-(UILabel*) initEndHourLabelWithHourString:(NSString *)string;

- (UITableViewCell *) getCellForWholeDay:(NSString *)cellIdentifier;
//- (UILabel *)hourLabel:(NSString *)hourString; deprecated
- (void) switchChange:(UISwitch *)sender;  
@end


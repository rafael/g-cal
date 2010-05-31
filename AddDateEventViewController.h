//
//  AddDateEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 24/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AddCalendarEventViewController.h"


@interface AddDateEventViewController : AddCalendarEventViewController <UITableViewDataSource, UITableViewDelegate> {
	UIDatePicker *dateSelect;
	UISwitch *wDaySelector;
	NSDate *startDate;
	NSDate *endDate;
	NSDateFormatter *dateFormater;
	UILabel *endHourLabel;
	UILabel *startHourLabel;
	UITableView *dtableView;
	NSInteger rowSelected;

}



//@property (nonatomic, retain) NSIndexPath *rowSelected;
@property (nonatomic, retain) UISwitch *wDaySelector;
@property (nonatomic, retain) UILabel *startHourLabel;
@property (nonatomic, retain) UILabel *endHourLabel;
@property (nonatomic, retain) NSDateFormatter *dateFormater;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *dateSelect;
@property (nonatomic, retain) IBOutlet UITableView *dtableView;



-(void)done;
-(void)cancel;
-(UILabel*) initStartHourLabelWithHourString:(NSString *)string;
-(UILabel*) initEndHourLabelWithHourString:(NSString *)string;
- (void) dateChanged:(UIDatePicker *)sender;

- (UITableViewCell *) getCellForWholeDay:(NSString *)cellIdentifier;
//- (UILabel *)hourLabel:(NSString *)hourString; deprecated
- (void) switchChange:(UISwitch *)sender;  
- (void) startDateFormater;
- (void) endDateFormater;
- (UIColor *) labelColor;
- (Boolean) checkStartEndHourDifference;

@end


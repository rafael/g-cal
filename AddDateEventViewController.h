/*
 
 Copyright (c) 2010 Rafael Chacon
 g-Cal is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 g-Cal is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with g-Cal.  If not, see <http://www.gnu.org/licenses/>.
 */

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
- (void) startHourBehavior;
- (void) endHourBehavior;


@end


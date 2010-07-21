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
#import "AddTitlePlaceEventViewController.h"
#import "AddNoteEventViewController.h"
#import "AddDateEventViewController.h"
#import "MBProgressHUD.h"


@protocol AddEventDelegate;
@class Event;



@interface AddEventViewController : UIViewController<UIActionSheetDelegate, 
													 UITableViewDataSource,
													 UITableViewDelegate,
													 UITextFieldDelegate,
													 MBProgressHUDDelegate,
												     NSFetchedResultsControllerDelegate> {
	
	NSMutableArray *menuList;
 	IBOutlet UITableView *addElementsTableView;
	@private
		Event *event;
		id <AddEventDelegate> delegate;
		NSDateFormatter *dateFormater;
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		BOOL editingMode;
		NSCondition  *waitForDeleteEventLock;
		MBProgressHUD *HUD;						
		BOOL deleteDone; 
		BOOL eventDeleted;
														 
											
}

@property BOOL editingMode;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UITableView *addElementsTableView;
@property(nonatomic, retain) Event *event;
@property (nonatomic, retain) NSDateFormatter *dateFormater;
@property(nonatomic, assign) id <AddEventDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



-(void)save;
-(void)cancel;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
- (UILabel *)newStartHourLabel:(NSString *)string;
- (UILabel *)newEndHourLabel:(NSString *)string;
-(UITableViewCell *)cellForNoNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;
-(UITableViewCell *)cellForNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;
- (void) startDateFormater;
- (void) endDateFormater;
- (void)eventDeleteConfirmation;
+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				darkTextColor:(BOOL)darkTextColor;


-(void) initializeMenuList;
-(void) deleteEvent:(id)object;

@end

@protocol AddEventDelegate <NSObject>

@required
- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event;
@optional
- (void)addEventViewController:(AddEventViewController *)addEventViewController didDeleteEvent:(Event *)event;
@end
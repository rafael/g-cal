//
//  AddEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 08/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

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
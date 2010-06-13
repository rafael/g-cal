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


@protocol AddEventDelegate;
@class Event;



@interface AddEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSFetchedResultsControllerDelegate> {
	
	NSMutableArray *menuList;
 	IBOutlet UITableView *addElementsTableView;
	@private
		Event *event;
		id <AddEventDelegate> delegate;
		NSDateFormatter *dateFormater;
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		

}



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


-(void) initializeMenuList;

@end

@protocol AddEventDelegate <NSObject>

@required
- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event;
@end
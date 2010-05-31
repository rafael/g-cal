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



@interface AddEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
	
	NSMutableArray *menuList;
 	IBOutlet UITableView *addElementsTableView;
//	UILabel *titleLabel;
	@private
		Event *event;
		id <AddEventDelegate> delegate;
		

}



@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UITableView *addElementsTableView;
@property(nonatomic, retain) Event *event;
//@property (nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, assign) id <AddEventDelegate> delegate;



-(void)save;
-(void)cancel;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
-(UITableViewCell *)cellForNoNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;
-(UITableViewCell *)cellForNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;

-(void) initializeMenuList;

@end

@protocol AddEventDelegate <NSObject>

@required
- (void)addEventViewController:(AddEventViewController *)addEventViewController didAddEvent:(Event *)event;
@end
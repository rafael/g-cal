//
//  AddEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 08/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTitlePlaceEventViewController.h"

@interface AddEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AddEventDelegate> {
	
	NSMutableArray *menuList;
	
	
 	IBOutlet UITableView *addElementsTableView;
	

}



@property (nonatomic, retain) NSMutableArray *menuList;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
-(UITableViewCell *)cellForNoNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;
-(UITableViewCell *)cellForNormalHeight:(UITableViewCell *)cell indexAt:(NSIndexPath *) indexPath;

@end

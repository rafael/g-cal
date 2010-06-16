//
//  CalendarViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoogleCalAppDelegate;
@interface CalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate> {
	
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		GoogleCalAppDelegate *appDelegate;
		IBOutlet UITableView *calendarsTableView;

}
@property (nonatomic, retain) IBOutlet UITableView *calendarsTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

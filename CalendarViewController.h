//
//  CalendarViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarViewController : UIViewController <UITableViewDataSource> {
	
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;

}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

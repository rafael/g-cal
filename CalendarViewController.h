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

@class GoogleCalAppDelegate;
@interface CalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate> {
	IBOutlet UITableView *calendarsTableView;
	@private
		NSFetchedResultsController *fetchedResultsController;
		NSManagedObjectContext *managedObjectContext;
		GoogleCalAppDelegate *appDelegate;
		

}

-(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic, retain) IBOutlet UITableView *calendarsTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

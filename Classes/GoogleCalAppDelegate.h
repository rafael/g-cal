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

//

@class MonthCalendar;
@class DayViewController;
@class CalendarViewController;

#import "GDataCalendar.h"


@interface GoogleCalAppDelegate : NSObject <UIApplicationDelegate> {
	
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	IBOutlet UINavigationController *navController;
	
	
    UIWindow *window;
	MonthCalendar *mainMonthCal;
	CalendarViewController *mainCalendar;
	GDataServiceGoogleCalendar *gCalService;
	NSString *username;


	NSMutableArray *addEventsQueue;

	

}

@property (nonatomic, retain) NSMutableArray *addEventsQueue;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) GDataServiceGoogleCalendar *gCalService;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MonthCalendar *mainMonthCal; 
@property (nonatomic, retain) CalendarViewController *mainCalendar; 



- (NSString *)applicationDocumentsDirectory;

-(void) checkIfUserChanged;

- (void) deleteAllObjects: (NSString *) entityDescription;
-(void) checkAccountConf;


@end


//
//  GoogleCalAppDelegate.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/11/09.
//  Copyright Universidad Simon Bolivar 2009. All rights reserved.
//

@class MonthCalendar;
@class DayViewController;

#import "GDataCalendar.h"


@interface GoogleCalAppDelegate : NSObject <UIApplicationDelegate> {
	
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	IBOutlet UINavigationController *navController;
	
	
    UIWindow *window;
	MonthCalendar *mainMonthCal;
	GDataServiceGoogleCalendar *gCalService;
	NSString *username;
	NSMutableDictionary *addEventsQueue;



	

}

@property (nonatomic, retain) NSMutableDictionary *addEventsQueue;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) GDataServiceGoogleCalendar *gCalService;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MonthCalendar *mainMonthCal; 

//@property (nonatomic, retain)  DayViewController *dayview; 






- (NSString *)applicationDocumentsDirectory;



@end


//
//  GoogleCalAppDelegate.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/11/09.
//  Copyright Universidad Simon Bolivar 2009. All rights reserved.
//

@class MonthCalendar;
@interface GoogleCalAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	MonthCalendar *monthcal;

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MonthCalendar *monthcal; 

- (NSString *)applicationDocumentsDirectory;

@end


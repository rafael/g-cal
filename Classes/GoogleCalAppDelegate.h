//
//  GoogleCalAppDelegate.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/11/09.
//  Copyright Universidad Simon Bolivar 2009. All rights reserved.
//

@class MonthCalendar;
@class DayViewController;


@interface GoogleCalAppDelegate : NSObject <UIApplicationDelegate> {
	NSMutableDictionary *data;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	IBOutlet UINavigationController *navController;
	
	
    UIWindow *window;
	
	//DayViewController *dayview;
	NSString* username;
	NSString* password;

	

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) MonthCalendar *monthcal; 

//@property (nonatomic, retain)  DayViewController *dayview; 

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;




- (NSString *)applicationDocumentsDirectory;



@end


//
//  GoogleCalAppDelegate.h
//  GoogleCal
//
//  Created by Rafael Chacon on 15/11/09.
//  Copyright Universidad Simon Bolivar 2009. All rights reserved.
//

@class MonthCalendar;
@class DayViewController;
@class EventViewController;

@interface GoogleCalAppDelegate : NSObject <UIApplicationDelegate> {
	NSMutableDictionary *data;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	IBOutlet UINavigationController *navController;
	IBOutlet EventViewController *EventController;
	
    UIWindow *window;
	
	MonthCalendar *monthcal;
	DayViewController *dayview;
	

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MonthCalendar *monthcal; 

@property (nonatomic, retain)  DayViewController *dayview; 
@property (readonly) NSArray *events;



- (NSString *)applicationDocumentsDirectory;
-(void) eventClicked:(NSString *) eventId;
-(NSArray *) eventInfo:(NSString *) eventId;
-(void) createDefaultData;

-(void) addNewEvent:(NSString *) eventId;


@end


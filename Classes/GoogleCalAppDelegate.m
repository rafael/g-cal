//
//  GoogleCalAppDelegate.m
//  GoogleCal
//
//  Created by Rafael Chacon on 15/11/09.
//  Copyright Universidad Simon Bolivar 2009. All rights reserved.
//

#import "GoogleCalAppDelegate.h"
#import "MonthCalendar.h"
#import "DayViewController.h"
#import "EventViewController.h"
#import "CalendarViewController.h"


@implementation GoogleCalAppDelegate

@synthesize window;
@synthesize username;
@synthesize password;
@synthesize mainMonthCal;


#pragma mark -
#pragma mark Application lifecycle






- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    

	MonthCalendar *aMonthCal = [[MonthCalendar alloc] init];
	aMonthCal.managedObjectContext = self.managedObjectContext;
	self.mainMonthCal = aMonthCal;
	
	CalendarViewController *calendarController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];

	navController.viewControllers= [NSArray arrayWithObjects:calendarController,aMonthCal,nil];
	[window addSubview:navController.view];
	[aMonthCal release]; 
	[calendarController release];

	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
	
	self.username = [defaults stringForKey:@"username_pref"];
	if (!self.username)
		self.username = @"user@gmail.com";
	if( ![username rangeOfString:@"@"].length )		
		username = [username stringByAppendingString:@"@gmail.com"];
	
	self.password =  [defaults stringForKey:@"password"];
	if( !self.password )
		password = @"password";
	NSLog(@" esto es lo que hay en los preferences %@, %@", self.username, self.password );


	
//	DayViewController *aDayView = [[DayViewController alloc] init];
//	[self setDayview:aDayView]; 
//	[aDayView release]; 
//	navController.viewControllers= [NSArray arrayWithObject:aDayView];
//	[window addSubview:navController.view];
//	
//	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
	
			// I'm not sure is this worlk as I expected
			[managedObjectContext rollback];
		
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"GoogleCal.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [mainMonthCal release]; 

	[window release];
	
	[super dealloc];
}


@end


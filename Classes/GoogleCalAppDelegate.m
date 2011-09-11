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

#import "GoogleCalAppDelegate.h"
#import "MonthCalendar.h"
//#import "DayViewController.h"
#import "EventViewController.h"
#import "CalendarViewController.h"
#import "Event.h"

@implementation GoogleCalAppDelegate

@synthesize window;
@synthesize mainMonthCal;
@synthesize gCalService;
@synthesize username;
@synthesize addEventsQueue;
@synthesize mainCalendar;

#pragma mark -
#pragma mark Application lifecycle


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    

	MonthCalendar *aMonthCal = [[MonthCalendar alloc] init];
	aMonthCal.managedObjectContext = self.managedObjectContext;
	self.mainMonthCal = aMonthCal;
	[self.mainMonthCal allCalendars:YES];
	CalendarViewController *calendarController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
	self.mainCalendar = calendarController;
	calendarController.managedObjectContext = self.managedObjectContext;
	//calendarController.managedObjectContext = self.managedObjectContext;
	navController.viewControllers= [NSArray arrayWithObjects:calendarController,aMonthCal,nil];
	[window addSubview:navController.view];
	[aMonthCal release]; 
	[calendarController release];
	
	//detecting first run , set sync_on_load as yes for default
	
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	
	if ([ud objectForKey:@"sync_on_load_pref"]== nil) {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"1", @"sync_on_load_pref",
                          nil];
    [ud registerDefaults:dict];
	}
	
	[self checkIfUserChanged];
	[self checkAccountConf];
		
								  
						
//	
	[window makeKeyAndVisible];

	
	
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self checkIfUserChanged];
	[self checkAccountConf];
	if (gCalService != nil ) {
		[gCalService release];
		gCalService = nil;
					
		}
	
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
		
		for (NSMutableDictionary *dic in self.addEventsQueue) {
			Event *event = [dic objectForKey:@"event"];
			[self.managedObjectContext deleteObject:event];
			NSError *error = nil;			
			[self.managedObjectContext save:&error];
						
			
		}
		
//		NSArray *eventsArray =  [self.addEventsQueue allValues];
//		
//		for (Event *event  in eventsArray) {
//				[self.managedObjectContext deleteObject:event];
//				NSError *error = nil;			
//				[self.managedObjectContext save:&error];
//		
//		
//		}
			
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


- (GDataServiceGoogleCalendar *)gCalService {
	
	
	if (gCalService == nil) {
		gCalService = [[GDataServiceGoogleCalendar alloc] init];

		[gCalService setUserAgent:@"oubinite-GoogleCalc-1.0.4"];

//		[gCalService setShouldCacheDatedData:YES];
		[gCalService setServiceShouldFollowNextLinks:YES];
		
		
		// update the username/password each time the service is requested
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		
		self.username = [defaults stringForKey:@"username_pref"];
		if (!self.username)
			self.username = @"username@gmail.com";
		if( ![self.username rangeOfString:@"@"].length )		
			self.username = [self.username stringByAppendingString:@"@gmail.com"];
		
		NSString *password =  [defaults stringForKey:@"password_pref"];
		if( !password )
			password = @"password";

		
		[gCalService setUserCredentialsWithUsername:username
										   password:password];
		
		
	}
	
	return gCalService;
}
-(void) checkIfUserChanged {
	
	NSArray *current_user_array = [NSArray arrayWithContentsOfFile:@"current_user.plist"];

	if  (current_user_array == nil ){		
		if (!self.username)
			self.username = @"username@gmail.com";
		current_user_array = [NSArray arrayWithObjects:self.username, nil];
		[current_user_array writeToFile:@"current_user.plist" atomically:YES];
	}
	else{
		NSString *current_user = [current_user_array objectAtIndex:0];
		if (self.username != nil && ![self.username isEqualToString:current_user]){
		
			[self deleteAllObjects:@"Calendar" ];

			self.mainMonthCal.fetchedResultsController = nil;
			[self.mainMonthCal reloadCalendar];
			self.mainCalendar.fetchedResultsController = nil;
			[self.mainCalendar.calendarsTableView reloadData];
	
			current_user_array = [NSArray arrayWithObjects:self.username, nil];
			[current_user_array writeToFile:@"current_user.plist" atomically:YES];

		
		}
		
	}
	
}

-(void) checkAccountConf{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *default_username = [defaults stringForKey:@"username_pref"];
	
	
	if (!default_username || [default_username isEqualToString:@"username@gmail.com"]) {
		NSString *title = NSLocalizedString(@"gCalNotConfiguredTitle", @"g-Cal is not configured"); 
		NSString *msg = NSLocalizedString(@"gCalNotConfiguredMsg", @"It seem's that g-Cal haven't been configured yet. Please go to g-Cal settings in your  iPhone settings and set the information for you account. If you are using iOS 4, be sure that g-Cal is close and is not running in the background, before setting the account information");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
		
		
	}
	
	
	
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
	
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
	//[NSFetchedResultsController deleteCacheWithName:@"CalendarRoot"]; 
	[NSFetchedResultsController deleteCacheWithName:@"Root"]; 
	[NSFetchedResultsController deleteCacheWithName:@"EventRoot"]; 
	[NSFetchedResultsController deleteCacheWithName:@"RootEvent"]; 
	

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

-(NSMutableArray *)addEventsQueue{
	if (addEventsQueue ==nil)
		addEventsQueue = [[NSMutableArray alloc] initWithCapacity:5];
	return addEventsQueue;
	
}


- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [mainMonthCal release]; 
	[mainCalendar release];
	[addEventsQueue release];
	[window release];
	
	[super dealloc];
}





@end


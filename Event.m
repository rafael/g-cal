// 
//  Event.m
//  GoogleCal
//
//  Created by Rafael Chacon on 17/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "Event.h"

#import "Calendar.h"

@implementation Event 

@dynamic location;
@dynamic note;
@dynamic title;
@dynamic endDate;
@dynamic startDate;
@dynamic eventid;
@dynamic calendar;
@dynamic updated;


+(Event *)getEventWithId:(NSString *)eventId andContext:(NSManagedObjectContext *) context{

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
	[request setEntity:entity];
	// retrive the objects with a given value for a certain property
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @"eventid == %@", eventId];
	[request setPredicate:predicate];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventid" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																								managedObjectContext:context 
																								  sectionNameKeyPath:nil
																										   cacheName:@"RootEvent"];
	
	aFetchedResultsController.delegate = self;
	
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:request error:&error];
	
	[request release];
	[sortDescriptor release];
	[sortDescriptors release];
	[aFetchedResultsController release];
	if (error) return nil;
	if (error) return nil;
	if(result != nil && [result count] == 1)
		return (Event *)[result objectAtIndex:0];
	return nil;
	
	
}

+(Event *)createEventFromGCal:(GDataEntryCalendarEvent *)event forCalendar:(Calendar *)calendar withContext:(NSManagedObjectContext *)context{

	GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
	// Note: An event might have multiple locations.  We're only displaying the first one.
	GDataWhere *addr = [[event locations] objectAtIndex:0];
	Event *anEvent;
	anEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
	anEvent.title = [[event title] stringValue];
	
	if( when ){
		anEvent.startDate =  [[when startTime] date];
		anEvent.endDate = [[when endTime] date];
	}

	anEvent.eventid = [event iCalUID];
	anEvent.updated = [[event updatedDate] date];
	anEvent.note = [[event content] stringValue];
	if( addr )
		anEvent.location =  [addr stringValue];
	anEvent.calendar = calendar;
	
	//anEvent.calendar =


	

	NSError *core_data_error = nil;
	if (![context save:&core_data_error]) {
		NSLog(@"Unresolved error saving a event %@, %@", core_data_error, [core_data_error userInfo]);
		return nil;
	}
	return anEvent;
	
}


-(BOOL)updateEventFromGCal:(GDataEntryCalendarEvent *)event forCalendar:(Calendar *)calendar withContext:(NSManagedObjectContext *)context{
		
	
	
	GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
	// Note: An event might have multiple locations.  We're only displaying the first one.
	GDataWhere *addr = [[event locations] objectAtIndex:0];
	
	self.title = [[event title] stringValue];
	
	if( when ){
		self.startDate =  [[when startTime] date];
		self.endDate = [[when endTime] date];
	}
	
	self.eventid = [event iCalUID];
	self.updated = [[event updatedDate] date];
	self.note = [[event content] stringValue];
	if( addr )
		self.location =  [addr stringValue];
	self.calendar = calendar;
	
	//anEvent.calendar =
	
	
	
	
	NSError *core_data_error = nil;
	if (![context save:&core_data_error]) {
		NSLog(@"Unresolved error saving a event %@, %@", core_data_error, [core_data_error userInfo]);
	
	}
	if (core_data_error) return NO;

	return YES;
	
}


@end

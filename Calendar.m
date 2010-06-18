// 
//  Calendar.m
//  GoogleCal
//
//  Created by Rafael Chacon on 18/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "Calendar.h"

#import "Event.h"

@implementation Calendar 

@dynamic edit_permission;
@dynamic updated;
@dynamic name;
@dynamic calid;
@dynamic color;
@dynamic has_many_events;

+(Calendar *)getCalendarWithId:(NSString *)calId andContext:(NSManagedObjectContext *) context{

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:context];
	[request setEntity:entity];
	// retrive the objects with a given value for a certain property
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @"calid == %@", calId];
	[request setPredicate:predicate];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calid" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																								managedObjectContext:context 
																								  sectionNameKeyPath:nil
																										   cacheName:@"RootCalendar"];
	
	aFetchedResultsController.delegate = self;
	
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:request error:&error];
	
	[request release];
	[sortDescriptor release];
	[sortDescriptors release];
	[aFetchedResultsController release];
	if (error) return nil;
	if(result != nil && [result count] == 1)
		return (Calendar *)[result objectAtIndex:0];
	return nil;
	
	
}
+(Calendar *)createCalendarFromGCal:(GDataEntryCalendar *)calendar withContext:(NSManagedObjectContext *)context {
		
		Calendar *aCalendar;
		aCalendar = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:context];
		aCalendar.name = [[calendar title] stringValue];
		aCalendar.color = [[calendar color] stringValue];
		aCalendar.calid = [calendar identifier];
		aCalendar.updated = [[calendar updatedDate] date];
		aCalendar.edit_permission = [NSNumber numberWithBool:[calendar canEdit]];
		NSError *core_data_error = nil;
		if (![context save:&core_data_error]) {
			NSLog(@"Unresolved error saving a calenadar%@, %@", core_data_error, [core_data_error userInfo]);
		}
		return aCalendar;
}


-(BOOL)updateCalendarFromGCal:(GDataEntryCalendar *)calendar withContext:(NSManagedObjectContext *)context {
	
	
	
	self.name = [[calendar title] stringValue];
	self.color = [[calendar color] stringValue];
	self.calid = [calendar identifier];
	self.updated = [[calendar updatedDate] date];
	self.edit_permission = [NSNumber numberWithBool:[calendar canEdit]];
	NSError *core_data_error = nil;
	if (![context save:&core_data_error]) {
		NSLog(@"Unresolved error saving a calenadar%@, %@", core_data_error, [core_data_error userInfo]);
	}
	
	if (core_data_error) return NO;
	else YES;
	
}


@end


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


+(NSArray *)getEventWithId:(NSString *)eventId andContext:(NSManagedObjectContext *) context{

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:context];
	[request setEntity:entity];
	// retrive the objects with a given value for a certain property
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @"eventid == %@", eventId];
	[request setPredicate:predicate];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calid" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																								managedObjectContext:context 
																								  sectionNameKeyPath:nil
																										   cacheName:@"Root"];
	
	aFetchedResultsController.delegate = self;
	
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:request error:&error];
	
	[request release];
	[sortDescriptor release];
	[sortDescriptors release];
	[aFetchedResultsController release];
	if (error) return nil;
	return result;
	//	
	return nil;
	
	
}


@end

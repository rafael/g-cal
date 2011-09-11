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

#import "Calendar.h"

#import "Event.h"

@implementation Calendar 

@dynamic edit_permission;
@dynamic updated;
@dynamic name;
@dynamic calid;
@dynamic link;
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
    aFetchedResultsController.delegate = nil;
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
		aCalendar.link = [[[calendar alternateLink] URL] relativeString];
		aCalendar.calid = [calendar identifier];
		aCalendar.updated = [[calendar updatedDate] date];
		//NSLog(@"permiso de edicion a la creacion %d, %@", [calendar canEdit], );
		NSNumber *permission;	
		NSString *accessLevel = [[calendar accessLevel] stringValue];
		if ( [accessLevel isEqualToString:@"owner"] || [accessLevel isEqualToString:@"editor"])
			permission= [NSNumber numberWithInt:1];
		else
			permission= [NSNumber numberWithInt:0];
		aCalendar.edit_permission = permission;
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
	self.link = [[[calendar alternateLink] URL] relativeString];
	self.updated = [[calendar updatedDate] date];
		
	NSNumber *permission;	
	NSString *accessLevel = [[calendar accessLevel] stringValue];
	if ( [accessLevel isEqualToString:@"owner"] || [accessLevel isEqualToString:@"editor"])
		permission= [NSNumber numberWithInt:1];
	else
		permission= [NSNumber numberWithInt:0];
	self.edit_permission = permission;
	
	NSError *core_data_error = nil;
	if (![context save:&core_data_error]) {
		NSLog(@"Unresolved error saving a calenadar%@, %@", core_data_error, [core_data_error userInfo]);
	}
	
	if (core_data_error) return NO;
	else return YES;
	
}
-(NSString *)ownSectionSeparator{
	if ( [self.edit_permission boolValue])
		return @"1";
	else
		return @"2";
			
	
	
}


@end


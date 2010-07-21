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


#import <CoreData/CoreData.h>
#import "GDataCalendar.h"
@class Event;

@interface Calendar :  NSManagedObject  
{
}
+(Calendar *)getCalendarWithId:(NSString *)calId andContext:(NSManagedObjectContext *) context;

+(Calendar *)createCalendarFromGCal:(GDataEntryCalendar *)calendar withContext:(NSManagedObjectContext *)context;


-(BOOL)updateCalendarFromGCal:(GDataEntryCalendar *)calendar withContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSNumber * edit_permission;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * calid;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSSet* has_many_events;


@end


@interface Calendar (CoreDataGeneratedAccessors)



- (void)addHas_many_eventsObject:(Event *)value;
- (void)removeHas_many_eventsObject:(Event *)value;
- (void)addHas_many_events:(NSSet *)value;
- (void)removeHas_many_events:(NSSet *)value;
-(NSString *)ownSectionSeparator;

@end


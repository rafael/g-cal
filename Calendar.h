//
//  Calendar.h
//  GoogleCal
//
//  Created by Rafael Chacon on 26/05/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;

@interface Calendar :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet* has_many_events;

@end


@interface Calendar (CoreDataGeneratedAccessors)
- (void)addHas_many_eventsObject:(Event *)value;
- (void)removeHas_many_eventsObject:(Event *)value;
- (void)addHas_many_events:(NSSet *)value;
- (void)removeHas_many_events:(NSSet *)value;

@end


//
//  Calendar.h
//  GoogleCal
//
//  Created by Rafael Chacon on 18/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;

@interface Calendar :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * edit_permission;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * calid;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSSet* has_many_events;

@end


@interface Calendar (CoreDataGeneratedAccessors)
- (void)addHas_many_eventsObject:(Event *)value;
- (void)removeHas_many_eventsObject:(Event *)value;
- (void)addHas_many_events:(NSSet *)value;
- (void)removeHas_many_events:(NSSet *)value;

@end


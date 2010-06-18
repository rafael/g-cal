//
//  Event.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "GDataCalendar.h"
@class Calendar;

@interface Event :  NSManagedObject  
{
}
+(Event *)getEventWithId:(NSString *)eventId andContext:(NSManagedObjectContext *) context;
+(Event *)createEventFromGCal:(GDataEntryCalendarEvent *)event forCalendar:(Calendar *)calendar withContext:(NSManagedObjectContext *)context;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * eventid;
@property (nonatomic, retain) Calendar * calendar;
@property (nonatomic, retain) NSDate * updated;

@end




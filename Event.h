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
@class Calendar;

@interface Event :  NSManagedObject  
{
}
+(Event *)getEventWithId:(NSString *)eventId forCalendar:(Calendar *)calendar andContext:(NSManagedObjectContext *) context;
+(Event *)createEventFromGCal:(GDataEntryCalendarEvent *)event forCalendar:(Calendar *)calendar withContext:(NSManagedObjectContext *)context;
-(BOOL)updateEventFromGCal:(GDataEntryCalendarEvent *)event forCalendar:(Calendar *)calendar withContext:(NSManagedObjectContext *)context;
-(GDataEntryCalendarEvent *)eventGDataEntry;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * eventid;
@property (nonatomic, retain) Calendar * calendar;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSString *editLink;
@property (nonatomic, retain) NSString *etag;
@property (nonatomic, retain) NSString *identifier;

@end




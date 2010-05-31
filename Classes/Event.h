//
//  Event.h
//  GoogleCal
//
//  Created by Rafael Chacon on 30/05/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Calendar;

@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Calendar * belongs_to_calendar;

@end




//
//  Event.h
//  GoogleCal
//
//  Created by Rafael Chacon on 25/05/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * calendar_id;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSManagedObject * belongs_to_calendar;

@end




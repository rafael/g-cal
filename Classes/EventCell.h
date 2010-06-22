//
//  EventCell.h
//  GoogleCalendar
//
//  Created by Rafael Chacon on 7/18/10.
//  Copyright Rafael Chacon 2010 All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface EventCell : UITableViewCell{
	UILabel  *time, *name, *addr;

}

@property (readonly, retain) UILabel  *time, *name, *addr;


@end
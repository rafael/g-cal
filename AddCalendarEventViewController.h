//
//  AddCalendarEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 31/05/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface AddCalendarEventViewController : UIViewController {
		@private
			Event *event;

}

@property(nonatomic, retain) Event *event;
@end

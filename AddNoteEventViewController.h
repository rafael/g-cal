//
//  AddNoteEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCalendarEventViewController.h"

//
//@protocol AddNoteEventDelegate;
@class Event;


@interface AddNoteEventViewController : AddCalendarEventViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
	
	UITextView *noteTextView;

		
}

@property (nonatomic, retain) UITextView	*noteTextView;

-(void)done;
-(void)cancel;


@end
//
//@protocol AddNoteEventDelegate <NSObject>
//
//@required
//- (void)addNoteEventViewController:(AddNoteEventViewController *)addNoteEventViewController didAddNoteEvent:(Event *)ievent;
//@end


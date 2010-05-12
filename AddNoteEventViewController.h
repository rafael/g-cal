//
//  AddNoteEventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 17/01/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>




@class AddNoteEventViewController;

@protocol AddNoteEventDelegate <NSObject>

@required

- (void)addNoteEventViewController:(AddNoteEventViewController *)addNoteEventViewController 
				   didAddNoteEvent:(NSString *)eventId;

@end





@interface AddNoteEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
	
	id <AddNoteEventDelegate> delegate;
	UITextView *noteTextView;
}

@property (nonatomic, assign) id <AddNoteEventDelegate> delegate;
@property (nonatomic, retain, readonly) UITextView	*noteTextView;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;


@end

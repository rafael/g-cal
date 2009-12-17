//
//  EventViewController.h
//  GoogleCal
//
//  Created by Rafael Chacon on 10/12/09.
//  Copyright 2009 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventViewController :  UIViewController<UITableViewDataSource> {
	
	
	NSArray *eventinformation;
	IBOutlet UITableView *eventTableView;

}


@property (nonatomic, retain) NSArray *eventinformation; 
-(void) loadEvent;

@end

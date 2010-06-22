//
//  Circle.h
//  GoogleCal
//
//  Created by Rafael Chacon on 20/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Circle : UIView {
	UIColor *circleColor;

}

@property (nonatomic,retain) UIColor *circleColor;

- (void)drawRect:(CGRect)rect;
- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color;

@end

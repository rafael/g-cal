//
//  Circle.m
//  GoogleCal
//
//  Created by Rafael Chacon on 20/06/10.
//  Copyright 2010 Universidad Simon Bolivar. All rights reserved.
//

#import "Circle.h"

#import "UIColor+Extensions.h"


@implementation Circle

@synthesize circleColor;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = self.circleColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		self.circleColor = color;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
   
		CGContextRef theContext = UIGraphicsGetCurrentContext();
		CGContextSetRGBStrokeColor(theContext, 1.0, 1.0, 1.0, 1.0);
		[self.circleColor set];
		CGContextFillEllipseInRect(theContext, CGRectMake(0, 0, 12.5, 12.5));
	
	
}


- (void)dealloc {
	[circleColor release];
    [super dealloc];
}


@end

// CODE FOR GRADIENT
//	CGContextSetAllowsAntialiasing(theContext, true);
//	CGContextSetShouldAntialias(theContext, true);
//	
//	size_t num_locations = 2;
//	CGFloat locations[2] = { 0.0, 1.0 };
//	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.0,  // Start color
//	1.0, 1.0, 1.0, 0.5 }; // End color
//	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
//	CGGradientRef glossGradient = 
//	CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
//	
//	CGContextAddEllipseInRect(theContext, CGRectMake(5, 5, 40, 40));
//	CGContextClip(theContext);
//	
//	CGPoint topCenter = CGPointMake(25, 20);
//	CGPoint midCenter = CGPointMake(25, 25);
//	CGContextDrawRadialGradient(theContext, glossGradient, topCenter, 10, midCenter, 20, kCGGradientDrawsAfterEndLocation);

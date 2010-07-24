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

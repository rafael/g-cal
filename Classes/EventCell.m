//
//  EventCell.m
//  GoogleCalendar
//
//
//  Created by Rafael Chacon on 7/18/10.
//  Copyright Rafael Chacon 2010 All rights reserved.

#import "EventCell.h"


@implementation EventCell

@synthesize  time, name, addr;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
	if( self=[super initWithFrame:frame reuseIdentifier:reuseIdentifier] ){
		
	
		time = [[UILabel alloc] initWithFrame:CGRectZero];
		time.font = [UIFont boldSystemFontOfSize:12];
		time.textColor = [UIColor darkGrayColor];
		time.textAlignment = UITextAlignmentRight;
		time.backgroundColor = [UIColor clearColor];
		
		name = [[UILabel alloc] initWithFrame:CGRectZero];
		name.font = [UIFont boldSystemFontOfSize:14];
		name.backgroundColor = [UIColor clearColor];
		
		addr = [[UILabel alloc] initWithFrame:CGRectZero];
		addr.font = [UIFont boldSystemFontOfSize:10];
		addr.textColor = [UIColor darkGrayColor];
		addr.backgroundColor = [UIColor clearColor];
		
	
		[self.contentView addSubview:time];
		[self.contentView addSubview:name];
		[self.contentView addSubview:addr];
	
	
	}
	return self;
}





- (void)dealloc{

	[time release];
	[name release];
	[addr release];

	[super dealloc];
}



- (void)layoutSubviews{
	[super layoutSubviews];
	// Start with a rect that is inset from the content view by 10 pixels on all sides.
	CGRect baseRect = CGRectInset( self.contentView.bounds, 10, 10 );
	CGRect rect = baseRect;
	
	// Position each label with a modified version of the base rect.
	rect.origin.x += 17;

	
	// First column...
	rect.size.width = 60;
	//rect.origin.x -= 5;
	rect.origin.y -= 7;

	rect.origin.y += 6;
	time.frame = rect;
	rect.origin.y += 10;
	// Second column...
	rect.size.width = 200;
	rect.origin.x += 65;
	rect.origin.y -= 16;
	name.frame = rect;
	rect.origin.y += 14;
	addr.frame = rect;
}

// Update the text color of each label when entering and exiting selected mode.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	if( selected )
		time.textColor = name.textColor = addr.textColor  = [UIColor whiteColor];
	else{
	
		time.textColor = [UIColor darkGrayColor];
		name.textColor = [UIColor blackColor];
		addr.textColor = [UIColor darkGrayColor];
	
	}
}

@end
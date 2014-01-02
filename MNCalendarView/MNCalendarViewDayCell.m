//
//  MNCalendarViewDayCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewDayCell.h"

NSString *const MNCalendarViewDayCellIdentifier = @"MNCalendarViewDayCellIdentifier";

@interface MNCalendarViewDayCell()
{
    
}
@property(nonatomic,strong,readwrite) NSDate *date;
@property(nonatomic,strong,readwrite) NSDate *month;
@property(nonatomic,assign,readwrite) NSUInteger weekday;
@property(nonatomic, strong) CAShapeLayer *bottomShapeLayer;
@end

@implementation MNCalendarViewDayCell

-(CAShapeLayer *)bottomShapeLayer{
    if (!_bottomShapeLayer) {
        _bottomShapeLayer = [CAShapeLayer layer];
    }
    return _bottomShapeLayer;
}

- (void)setDate:(NSDate *)date
          month:(NSDate *)month
       calendar:(NSCalendar *)calendar {
    
    self.date     = date;
    self.month    = month;
    self.calendar = calendar;
    
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:self.date];
    
    NSDateComponents *monthComponents =
    [self.calendar components:NSMonthCalendarUnit
                     fromDate:self.month];
    
    self.weekday = components.weekday;
    self.titleLabel.text = [NSString stringWithFormat:@"%d", components.day];
    self.enabled = monthComponents.month == components.month;
    
    [self setNeedsDisplay];
}

-(void)hideIfOtherMonthDate{
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:self.date];
    
    NSDateComponents *monthComponents =
    [self.calendar components:NSMonthCalendarUnit
                     fromDate:self.month];
    if (monthComponents.month != components.month) {
        [self.titleLabel setText:@""];
        self.selected = NO;
        //        self.enabled = NO;
    }
    
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.titleLabel.textColor =
    self.enabled ? UIColor.darkTextColor : UIColor.lightGrayColor;
    
    self.backgroundColor =
    self.enabled ? UIColor.whiteColor : [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
}

-(void)prepareForReuse{
    [_bottomShapeLayer removeFromSuperlayer];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.drawSplitColor) {
        [self.selectedBackgroundView.layer insertSublayer:self.bottomShapeLayer atIndex:0];
        
        CGRect frame = self.bounds;
        frame.size.height /= 2.0f;
        CGRect topFrame = frame;
        CGRect bottomFrame = CGRectOffset(topFrame, 0.0f, frame.size.height);
        
        UIBezierPath *bottomPath =[UIBezierPath bezierPathWithRect:bottomFrame];
        
        [self.bottomShapeLayer setPath:bottomPath.CGPath];
        
        [_bottomShapeLayer setFillColor:self.bottomHalfColor.CGColor];
    }else{
        [_bottomShapeLayer removeFromSuperlayer];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef separatorColor = self.separatorColor.CGColor;
    
    CGSize size = self.bounds.size;
    
    if (self.weekday != 7) {
        CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
        MNContextDrawLine(context,
                          CGPointMake(size.width - pixel, pixel),
                          CGPointMake(size.width - pixel, size.height),
                          separatorColor,
                          pixel);
    }
}

@end

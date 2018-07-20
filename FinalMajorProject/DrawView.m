//
//  DrawView.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/17.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextRef fullContext = UIGraphicsGetCurrentContext();
 if (!self.isPlaying)
 {
 CGContextSetRGBFillColor(context, 0, 0, 0.1, 0.3);
 
 }
 else if (self.isPlaying)
 {
 CGContextSetRGBFillColor(context, 0, 0.1, 0.1, 0.8);
 }
 CGContextFillRect(context, CGRectMake(0,0, self.Left, rect.size.height));
 CGContextFillRect(context, CGRectMake(self.Right, 0, rect.size.width-self.Right, rect.size.height));
 CGContextSetRGBFillColor(fullContext, 1, 0, 0, 0.35);
 CGContextFillRect(fullContext, CGRectMake(self.Left-10, 0, 10, rect.size.height));
 CGContextFillRect(fullContext, CGRectMake(self.Right, 0, 10, rect.size.height));
 CGContextRef linecontext = UIGraphicsGetCurrentContext();
 CGContextSetRGBFillColor(linecontext, 1, 0.15, 1, 0.85);
 CGContextFillRect(linecontext, CGRectMake(self.LineX-4, 0, 4, rect.size.height));
 CGContextStrokePath(linecontext);
 CGContextStrokePath(fullContext);
 CGContextStrokePath(context);
 //    CGContextRelease(context);
 //    CGContextRelease(fullContext);
 //    CGContextRelease(linecontext);
 //---------------------------------------
 if (self.Temp==3)
 {
 CGContextRef playcontext = UIGraphicsGetCurrentContext();
 CGContextSetRGBFillColor(playcontext, 0, 0.25, 0, 0.5);
 CGContextFillRect(playcontext, CGRectMake(self.StartX, 0, self.LineX-self.StartX, rect.size.height));
 CGContextStrokePath(playcontext);
 //        CGContextRelease(playcontext);
 }
 else if (self.Temp==4)
 {
 CGContextRef playcontext = UIGraphicsGetCurrentContext();
 CGContextSetRGBFillColor(playcontext, 0, 0.25, 0, 0.5);
 CGContextFillRect(playcontext, CGRectMake(self.StartX, 0, self.EndX-self.StartX, rect.size.height));
 CGContextStrokePath(playcontext);
 //        CGContextRelease(playcontext);
 }
}


@end

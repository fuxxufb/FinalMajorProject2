//
//  DrawView.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/17.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (assign,nonatomic) CGFloat x;
@property (assign,nonatomic) CGFloat y;
@property (assign,nonatomic) CGPoint touchPoint;
@property (assign,nonatomic) CGFloat Left;
@property (assign,nonatomic) CGFloat Right;
@property (assign,nonatomic) NSInteger Temp;
@property (assign,nonatomic) CGFloat LineX;
@property (assign,nonatomic) CGFloat StartX;
@property (assign,nonatomic) CGFloat EndX;
@property (assign,nonatomic) BOOL isPlaying;

@end

//
//  MemoryandCPUTest.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/8/18.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MemoryandCPUTest : NSObject
+ (unsigned long)memoryUsage;
+ (CGFloat)cpuUsage;

@end

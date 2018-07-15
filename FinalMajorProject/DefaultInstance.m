//
//  DefaultInstance.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/11.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "DefaultInstance.h"

@implementation DefaultInstance

+(instancetype)sharedInstance{
    static DefaultInstance *sharedVC=nil;
    if (sharedVC==nil)
    {
        sharedVC=[[DefaultInstance alloc]init];
        
    }
    return sharedVC;
}

@end

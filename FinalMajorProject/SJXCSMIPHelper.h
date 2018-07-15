//
//  SJXCSMIPHelper.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/8.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJXCSMIPHelper : NSObject

/** 获取ip地址 */
+ (NSString *)deviceIPAdress;

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

//
//  DefaultInstance.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/11.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultInstance : NSObject

+(instancetype)sharedInstance;

@property (nonatomic,assign) NSInteger *audioNumber;
@property(nonatomic,strong) NSMutableArray *filenameArray;
@property(nonatomic,strong) NSMutableArray *filepathArray;
@property(nonatomic,strong) NSMutableArray *fileArray;

@end

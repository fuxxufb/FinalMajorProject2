//
//  ViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/8.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "ViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "SJXCSMIPHelper.h"
#import "DefaultInstance.h"
@interface ViewController ()
{
    HTTPServer *httpServer;
    NSMutableArray *filenameArray;
    NSInteger *AudioNumber;
    NSString *filename;
    NSURL *fileURL;
}


@end
NSInteger mp3Number;
@implementation ViewController

#pragma mark - setup
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupNotifications];
    filenameArray=[DefaultInstance sharedInstance].filenameArray;
    AudioNumber=[DefaultInstance sharedInstance].audioNumber;
    filename=filenameArray[(int)AudioNumber];
    fileURL=[DefaultInstance sharedInstance].filepathArray[(int)AudioNumber];
}
@end

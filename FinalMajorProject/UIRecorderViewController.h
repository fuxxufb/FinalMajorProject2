//
//  UIRecorderViewController.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio.h>
#import "DefaultInstance.h"
#import <AVFoundation/AVFoundation.h>

@interface UIRecorderViewController : UIViewController
@property (strong, nonatomic) IBOutlet EZAudioPlot *EZRecordPlot;
@property (strong, nonatomic) IBOutlet UILabel *RecordCurrentTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *UIRecordStartButton;
- (IBAction)UIRecordStartButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UIRecordStopButton;
- (IBAction)UIRecordStopButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *UIRecordTableView;

@end

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

@interface UIRecorderViewController : UIViewController<EZAudioPlayerDelegate,EZMicrophoneDelegate,EZRecorderDelegate,UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet EZAudioPlot *EZRecordPlot;
@property(strong,nonatomic) EZRecorder *EZRecorder;
@property(strong,nonatomic)EZMicrophone *microphone;
@property(strong,nonatomic)EZAudioPlayer *Player;
@property (strong, nonatomic) IBOutlet UILabel *RecordCurrentTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *UIRecordStartButton;
- (IBAction)UIRecordStartButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UIRecordStopButton;
- (IBAction)UIRecordStopButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *UIRecordTableView;
@property(strong,nonatomic)NSFileManager *FileManager;
@property (strong, nonatomic) IBOutlet UILabel *microphoneStateLabel;
@property (strong, nonatomic) IBOutlet UITableView *UIRecordFileTableView;
@property(strong,nonatomic)UIAlertAction *OKAction;
- (IBAction)PushPlayerlistVC:(UIButton *)sender;
@property(strong,nonatomic)NSMutableArray *RecordFileNameArray;
@end

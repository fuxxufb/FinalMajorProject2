//
//  ViewController.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/8.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <EZAudio/EZAudio.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController :
    UIViewController<EZAudioPlayerDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    
}

@property (nonatomic,strong) NSArray *mp3Array;
@property (nonatomic,strong) AVAudioPlayer *SPlayer;
@property (nonatomic,assign) NSInteger mp3Count;


@property (nonatomic,strong) EZAudioFile *musicFile;
@property (nonatomic,strong) EZAudioPlayer *player;
@property (strong, nonatomic) IBOutlet EZAudioPlot *audioPlot;


@property (strong, nonatomic) IBOutlet UILabel *CurrentTime;
@property (strong, nonatomic) IBOutlet UILabel *DuringTime;
@property (assign,nonatomic) NSString *ipString;
@property (strong, nonatomic) IBOutlet UILabel *UIAudioName;


@end


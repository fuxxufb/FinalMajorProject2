//
//  ViewController.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/8.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <EZAudio/EZAudio.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DefaultInstance.h"
#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"BGM/BGM-remix" ofType:@"mp3"]

#pragma mark - ViewController

@interface ViewController : UIViewController<EZAudioPlayerDelegate,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,UIAlertViewDelegate>
{
    //NSMutableArray *musicArray;
}

#pragma mark - Properties
@property (nonatomic, strong) EZAudioFile *audioFile;
@property (nonatomic, strong) EZAudioPlayer *player;
@property (strong, nonatomic) NSMutableArray *mp3Array;
@property (strong, nonatomic) IBOutlet EZAudioPlot *audioPlot;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *Playcontroller;
- (IBAction)PlayController:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentTime;
@property (strong, nonatomic) IBOutlet UILabel *During;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *setPlayMode;
- (IBAction)setPlayMode:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UISlider *UIPositionSlider;
- (IBAction)UIPositionSliderValueChange:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *UIVolumeLabel;
@property (strong, nonatomic) IBOutlet UISlider *UIVolumeSlider;
- (IBAction)UIVolumeSliderChange:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *UIPanLabel;
@property (strong, nonatomic) IBOutlet UISlider *UIPanSlider;
- (IBAction)UIPanSliderChange:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UILoopButton;
- (IBAction)UILoopButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UIPlayButton;
- (IBAction)UIPlayButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UINextButton;
- (IBAction)UINextButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *UIPreButton;
- (IBAction)UIPreButtonClick:(UIButton *)sender;
- (IBAction)NextAudio:(UIButton *)sender;
- (IBAction)PreAudio:(UIButton *)sender;
@property (assign,nonatomic) BOOL IsLoop;
@property (strong, nonatomic) IBOutlet UIButton *LoopButton;
- (IBAction)LoopButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *OrderButton;
- (IBAction)OrderButtonClick:(UIButton *)sender;



@end




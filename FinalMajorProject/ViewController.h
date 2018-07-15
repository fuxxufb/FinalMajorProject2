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
@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *PlayController;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *setPlayMode;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *During;
@property (strong, nonatomic) NSMutableArray *mp3Array;
@property (strong, nonatomic) IBOutlet UIButton *changeViews;
@property (strong,nonatomic) AVAudioPlayer *SPlayer;
//@property (assign,nonatomic) NSMutableArray* musicArray;
@property (strong,nonatomic) MPMediaPickerController *picker;


#pragma mark - Actions
- (IBAction)setPlayMode:(UITapGestureRecognizer *)sender;
- (IBAction)PlayController:(UITapGestureRecognizer *)sender;
- (IBAction)DownSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)UpSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)RightSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)LeftSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)LongPress:(UILongPressGestureRecognizer *)sender;
- (IBAction)changeViews:(UIButton *)sender;
- (IBAction)selectMusic:(UIButton *)sender;
- (IBAction)ChangeView:(UIBarButtonItem *)sender;

@end




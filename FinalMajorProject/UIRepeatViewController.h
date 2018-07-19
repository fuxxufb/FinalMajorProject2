//
//  UIRepeatViewController.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio.h>
#import "DrawView.h"
#import <AVFoundation/AVFoundation.h>
@interface UIRepeatViewController : UIViewController<EZAudioPlayerDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate,UIDocumentInteractionControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet EZAudioPlot *editAudioPlot;
@property (strong,nonatomic) EZAudioFile *audioFile;
@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) IBOutlet DrawView *drawView;
@property (strong, nonatomic) IBOutlet DrawView *DrawView;
@property (strong, nonatomic) IBOutlet UILabel *CurrentTime;
@property (strong, nonatomic) IBOutlet UILabel *During;
@property (strong, nonatomic) IBOutlet UIButton *ResetSpeed;
- (IBAction)ResetSpeed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *CutB;
- (IBAction)couTouchCancel:(UIButton *)sender;
- (IBAction)cutTouchDown:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *SaveB;
- (IBAction)SaveButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UISlider *SpeedSilder;
- (IBAction)SpeedSilderChange:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *SpeedLabel;
@property (assign,nonatomic) float playEnding;
@property(strong,nonatomic)NSData *musicData;
@property(strong,nonatomic)NSData *fileData;
@property(assign,nonatomic)NSUInteger musicDataLength;
@property(assign,nonatomic)int InteractionMode;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)NSTimer *playTimer;
@property(strong,nonatomic)NSString *NewMusicFileName;
@property(strong,nonatomic)UIDocumentInteractionController *documentInteractionController;
@property (strong,nonatomic) UIAlertAction *OKAction;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *OneTap;
- (IBAction)OneTap:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *TwoTap;
- (IBAction)TwoTap:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *PanTap;
- (IBAction)PanTap:(UIPanGestureRecognizer *)sender;

@end

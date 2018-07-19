//
//  ViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/8.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

//EZAudioPlayer *player;
@implementation ViewController
NSInteger mp3Number;
NSMutableArray* musicNames;
NSMutableArray* musicPaths;
NSString *documentsPath;


NSInteger mp3Count;
#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Status Bar Style


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    //---------------------------------------
    
    musicNames=[[NSMutableArray alloc]init];
    musicPaths=[[NSMutableArray alloc]init];
    self.player=[[EZAudioPlayer alloc]init];
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    musicNames=[NSMutableArray arrayWithArray:[DefaultInstance sharedInstance].filenameArray];
    musicPaths=[NSMutableArray arrayWithArray:[DefaultInstance sharedInstance].filepathArray];
    mp3Number=[DefaultInstance sharedInstance].audioNumber;
    [self openFileWithFilePathURL:musicPaths[mp3Number]];
    //self.tabBarController.tabBar.hidden=true;
    //----------------------------------------
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    //---------------------
    
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 255.0/255.0 alpha: 1.0];
    self.audioPlot.color           = [UIColor colorWithRed:255.0/255.0 green:162.0/255.0 blue:0/255.0 alpha: 1.0];
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    self.audioPlot.shouldOptimizeForRealtimePlot = NO;
    [self.audioPlot setRollingHistoryLength:512];
    NSLog(@"outputs: %@", [EZAudioDevice outputDevices]);
    
    //---------------------
    
    self.player.shouldLoop = NO;
    self.player.volume=0.5;
    [self.player play];
    //-------------------------------
    
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
    //-------------------------
    
    [self setupNotifications];
    
    //--------------------   Gestures set
    
    [self.Playcontroller requireGestureRecognizerToFail:self.setPlayMode];
    
    //---------------------- Labers set
    self.currentTime.text=@"00:00";
    
    //---------------------------------------------
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.UIVolumeLabel.text=[NSString stringWithFormat:@"%.2f",self.player.volume];
    [self.UIVolumeLabel sizeToFit];
    self.UIPanLabel.text=[NSString stringWithFormat:@"%.2f",self.player.pan];
    [self.UIPanLabel sizeToFit];
    [self.UIPlayButton setTitle:@"暂停" forState:UIControlStateNormal];
    [self.UIPlayButton.titleLabel sizeToFit];
    
}




//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeAudioFile:)
                                                 name:EZAudioPlayerDidChangeAudioFileNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeOutputDevice:)
                                                 name:EZAudioPlayerDidChangeOutputDeviceNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
}
//------------------------------------------------------------------------------
- (void)audioPlayerDidChangeAudioFile:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed audio file: %@", [player audioFile]);
}

//------------------------------------------------------------------------------

- (void)audioPlayerDidChangeOutputDevice:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed output device: %@", [player device]);
}

//------------------------------------------------------------------------------

- (void)audioPlayerDidChangePlayState:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player change play state, isPlaying: %i", [player isPlaying]);
}


#pragma mark - OpenFilePath
- (void)openFileWithFilePathURL:(NSURL*)filePathURL
{
    //self.Name.text=filePathURL.lastPathComponent;
    self.navigationItem.title=filePathURL.lastPathComponent;
    self.audioFile=nil;
    self.audioFile=[EZAudioFile audioFileWithURL:filePathURL];
    self.During.text=self.audioFile.formattedDuration;
    self.currentTime.text=@"00:00";
    self.UIPositionSlider.maximumValue = (float)self.audioFile.totalFrames;
    //--------------------------
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    //--------------------------
    __weak typeof (self) weakSelf = self;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [weakSelf.audioPlot updateBuffer:waveformData[0]
                           withBufferSize:length];
     }];
    //----------------------------
    [self.player setAudioFile:self.audioFile];
    //[self.player play];
}





#pragma mark - Actions



- (IBAction)RightSwipe:(UISwipeGestureRecognizer *)sender {
    //self.mp3Array=[[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"BGM"];
    if ([self.player isPlaying])
    {
        if (mp3Number<(mp3Count-1))
        {
            [self.player pause];
            mp3Number++;
            NSURL *URL;
            URL=[NSURL fileURLWithPath:musicPaths[mp3Number]];
            [self openFileWithFilePathURL:URL];
            [self.player setAudioFile:self.audioFile];
            [self.player play];
            
        }
        else if (mp3Number>=(mp3Count-1))
        {
            [self.player pause];
            mp3Number=0;
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:musicPaths[mp3Number]]];
            [self.player setAudioFile:self.audioFile];
            [self.player play];
        }
    }
    else if (![self.player isPlaying])
    {
        if (mp3Number<(mp3Count-1))
        {
            //[self.player pause];
            mp3Number++;
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:musicPaths[mp3Number]]];
            [self.player setAudioFile:self.audioFile];
            
            //[self.player play];
            
        }
        else if (mp3Number>=(mp3Count-1))
        {
            //[self.player pause];
            mp3Number=0;
            [self openFileWithFilePathURL:[NSURL fileURLWithPath:musicPaths[mp3Number]]];
            [self.player setAudioFile:self.audioFile];
            //[self.player play];
        }
    }
}







/*- (IBAction)selectMusic:(UIButton *)sender {
 self.picker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];
 self.picker.prompt = @"Please select your music";
 self.picker.showsCloudItems = NO;
 self.picker.allowsPickingMultipleItems =YES;
 self.picker.delegate=self;
 [self presentViewController:self.picker animated:YES completion:nil];
 }*/










#pragma mark - Delegate
- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlot updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
    });
}

//----------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentTime.text = [audioPlayer formattedCurrentTime];
        if (!weakSelf.UIPositionSlider.touchInside)
        {
            weakSelf.UIPositionSlider.value = (float)framePosition;
        }
    });
}




//-----------------------------------------------------------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sec"])
    {
        [self.player pause];
    }
    
}
#pragma mark - Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)UIPositionSliderValueChange:(UISlider *)sender {
   // self.player.currentTime=sender.value*self.player.duration;
  //  self.currentTime.text=self.player.formattedCurrentTime;
    [self.player seekToFrame:(SInt64)[(UISlider *)sender value]];
}
- (IBAction)UIVolumeSliderChange:(UISlider *)sender {
    self.player.volume=sender.value;
    self.UIVolumeLabel.text=[NSString stringWithFormat:@"%.2f",self.player.volume];
}
- (IBAction)UIPanSliderChange:(UISlider *)sender {
    self.player.pan=sender.value;
    self.UIPanLabel.text=[NSString stringWithFormat:@"%.2f",self.player.pan];
}
- (IBAction)UILoopButtonClick:(UIButton *)sender {
    if (self.player.shouldLoop)
    {
        self.player.shouldLoop=false;
        [self.UILoopButton setTitle:@"No loop" forState:UIControlStateNormal];
        [self.UILoopButton sizeToFit];
    }
    else
    {
        {
            self.player.shouldLoop=true;
            [self.UILoopButton setTitle:@"loop" forState:UIControlStateNormal];
            [self.UILoopButton sizeToFit];
        }
    }
}
- (IBAction)UIPlayButtonClick:(UIButton *)sender {
    if ([self.player isPlaying])
    {
        [self.player pause];
        [self.UIPlayButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    else if (![self.player isPlaying])
    {
        [self.player play];
        [self.UIPlayButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
}
- (IBAction)UINextButtonClick:(UIButton *)sender {
    if (self.player.currentTime<self.player.duration-2)
    {
        self.player.currentTime++;
        
    }
    
}
- (IBAction)UIPreButtonClick:(UIButton *)sender {
    if (self.player.currentTime>1.5)
    {
        self.player.currentTime=self.player.currentTime-2;
    }
}
@end


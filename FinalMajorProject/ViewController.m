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
UIImage *Playimage;
UIImage *Pauseimage;
UIImage *Loop1;
UIImage *Loop2;
UIImage *List1;
UIImage *List2;
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
    mp3Count=musicPaths.count;
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
    
    self.audioPlot.backgroundColor = [UIColor clearColor];
    self.audioPlot.color           = [UIColor colorWithRed:133.0/255.0 green:98.0/255.0 blue:198.0/255.0 alpha: 1.0];
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    self.audioPlot.shouldOptimizeForRealtimePlot = NO;
    [self.audioPlot setRollingHistoryLength:512];
    NSLog(@"outputs: %@", [EZAudioDevice outputDevices]);
    
    //---------------------
    //--------------------------------set background image
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"BG_Image_3"ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.view.layer.contents=(id)image.CGImage;
    //------------------------------
    Playimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play"ofType:@"png"]];
    Pauseimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"pause"ofType:@"png"]];
    Loop1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Loop1"ofType:@"png"]];
    Loop2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Loop2"ofType:@"png"]];
    List1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"list1"ofType:@"png"]];
    List2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"List2"ofType:@"png"]];
    //------------------------
    self.player.shouldLoop = NO;
    self.player.volume=0.5;
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
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
   // [self.OrderButton setHidden:true];
    //[self.LoopButton setHidden:false];
    self.IsLoop=true;
    self.player.shouldLoop=true;
    self.UIPanLabel.textColor=[UIColor whiteColor];
    self.UIVolumeLabel.textColor=[UIColor whiteColor];
    self.During.textColor=[UIColor whiteColor];
    self.currentTime.textColor=[UIColor whiteColor];
    //--------------------------------------------
    if ([DefaultInstance sharedInstance].isFirst)
    {
        UIImageView *GudianceBG=[[UIImageView alloc]initWithFrame:self.view.bounds];
        GudianceBG.image=[UIImage imageNamed:@"PlayGuidanceImage"];
        GudianceBG.userInteractionEnabled=true;
        [self.view addSubview:GudianceBG];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
        [GudianceBG addGestureRecognizer:tap];
    }
    else
    {
        [self.player play];
    }
}

-(void)dismissGuideView:(UITapGestureRecognizer*)tap
{
   // NSLog(@"errererererer");
    UIView *view=tap.view;
    [view removeFromSuperview];
    [view removeGestureRecognizer:tap];
    [self.player play];
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
    self.navigationItem.title=filePathURL.lastPathComponent;//tittle name
    self.audioFile=nil;//init audiofile
    self.audioFile=[EZAudioFile audioFileWithURL:filePathURL];//load audio file
    self.During.text=self.audioFile.formattedDuration;//During Time
    self.currentTime.text=@"00:00";//init CurrentTime
    self.UIPositionSlider.maximumValue = (float)self.audioFile.totalFrames;//init Slider length
    //-------------------------- set Plot Type
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    //--------------------------
    //-------------------------- load Plot in Multi-thread
    __weak typeof (self) weakSelf = self;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [weakSelf.audioPlot updateBuffer:waveformData[0]
                           withBufferSize:length];
     }];
    //----------------------------
    [self.player setAudioFile:self.audioFile];
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
- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
reachedEndOfAudioFile:(EZAudioFile *)audioFile
{
    //__weak typeof (self) weakSelf=self;
    if (!self.IsLoop)
    {
        [self PlaynextAudio];
        [self.player play];
    }
    
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

- (IBAction)UIPlayButtonClick:(UIButton *)sender {
    if ([self.player isPlaying])
    {
        [self.player pause];
        [self.UIPlayButton setImage:Pauseimage forState:UIControlStateNormal];
    }
    else if (![self.player isPlaying])
    {
        [self.player play];
        [self.UIPlayButton setImage:Playimage forState:UIControlStateNormal];
    }
}


- (IBAction)NextAudio:(UIButton *)sender {
    [self PlaynextAudio];
}
-(void)PlaynextAudio
{
    if ([self.player isPlaying])
    {
        if (mp3Number<(mp3Count-1))
        {
            [self.player pause];
            mp3Number++;
            NSURL *URL;
            URL=musicPaths[mp3Number];
            [self openFileWithFilePathURL:URL];
            [self.player setAudioFile:self.audioFile];
            [self.player play];
            
        }
        else if (mp3Number>=(mp3Count-1))
        {
            [self.player pause];
            mp3Number=0;
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
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
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
            [self.player setAudioFile:self.audioFile];
            
            //[self.player play];
            
        }
        else if (mp3Number>=(mp3Count-1))
        {
            //[self.player pause];
            mp3Number=0;
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
            [self.player setAudioFile:self.audioFile];
            //[self.player play];
        }
    }
}

- (IBAction)PreAudio:(UIButton *)sender {
    if ([self.player isPlaying])
    {
        if (mp3Number>0)
        {
            [self.player pause];
            mp3Number--;
            NSURL *URL;
            URL=musicPaths[mp3Number];
            [self openFileWithFilePathURL:URL];
            [self.player setAudioFile:self.audioFile];
            [self.player play];
            
        }
        else if (mp3Number<=0)
        {
            [self.player pause];
            mp3Number=mp3Count-1;
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
            [self.player setAudioFile:self.audioFile];
            [self.player play];
        }
    }
    else if (![self.player isPlaying])
    {
        if (mp3Number>0)
        {
            mp3Number--;
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
            [self.player setAudioFile:self.audioFile];
            
        }
        else if (mp3Number<=0)
        {
            mp3Number=mp3Count-1;
            [self openFileWithFilePathURL:musicPaths[mp3Number]];
            [self.player setAudioFile:self.audioFile];
        }
    }
}
- (IBAction)LoopButtonClick:(UIButton *)sender {
    if (self.IsLoop==false)
    {
        [self.OrderButton setImage:List2 forState:UIControlStateNormal];
        [self.LoopButton setImage:Loop1 forState:UIControlStateNormal];
    }
    self.IsLoop=true;
    self.player.shouldLoop=self.IsLoop;
    
}
- (IBAction)OrderButtonClick:(UIButton *)sender {
    if (self.IsLoop)
    {
        [self.OrderButton setImage:List1 forState:UIControlStateNormal];
        [self.LoopButton setImage:Loop2 forState:UIControlStateNormal];
    }
    self.IsLoop=false;
    self.player.shouldLoop=self.IsLoop;
}
@end


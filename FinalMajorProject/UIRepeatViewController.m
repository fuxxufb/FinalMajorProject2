//
//  UIRepeatViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)



#import "UIRepeatViewController.h"
#import "DefaultInstance.h"
@interface UIRepeatViewController ()
@property (assign,nonatomic) NSURL *filePath;
@property(assign,nonatomic) NSInteger mp3Number;
@end

//NSInteger mp3Number;
//NSArray* musicNames;
//NSMutableArray* musicPaths;
//NSString *documentsPath;
//NSString* timeToString(float ctime);
@implementation UIRepeatViewController

UIImage *play1;
UIImage *play2;
UIImage *pause1;
UIImage *pause2;
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mp3Number=[DefaultInstance sharedInstance].audioNumber;
    self.filePath=[DefaultInstance sharedInstance].filepathArray[self.mp3Number];
    [self openFileWithFilePathURL:self.filePath];
    [self initAudioPlayer:self.filePath];
    //self.tabBarController.tabBar.hidden=true;
    //----------------------------------------
    self.editAudioPlot.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 255.0/255.0 alpha: 0.0];
    self.editAudioPlot.color           = [UIColor colorWithRed:133.0/255.0 green:98.0/255.0 blue:198.0/255.0 alpha: 1.0];
    self.editAudioPlot.plotType = EZPlotTypeBuffer;
    self.editAudioPlot.shouldFill = YES;
    self.editAudioPlot.shouldMirror = YES;
    self.editAudioPlot.shouldOptimizeForRealtimePlot = NO;
    self.editAudioPlot.waveformLayer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.editAudioPlot.waveformLayer.shadowRadius = 0.0;
    self.editAudioPlot.waveformLayer.shadowColor = [UIColor
                                                    colorWithRed: 0.069 green: 0.543 blue: 0.575 alpha: 1].CGColor;
    self.editAudioPlot.waveformLayer.shadowOpacity = 1.0;
    //----------------------------------------
    
    self.drawView.Temp=1;
    self.drawView.Left=50;
    self.drawView.Right=SCREEN_WIDTH;
    [self setplayerBeginPosition:self.drawView.Left];
    self.playEnding=self.drawView.Right*self.player.duration/SCREEN_WIDTH;
    //----------------------------------------
    self.During.text=timeToString(self.playEnding);
    self.CurrentTime.text=timeToString(self.drawView.Left*self.player.duration/SCREEN_WIDTH);
    //----------------------------------------
    self.musicData=[[NSData alloc]initWithContentsOfURL:self.filePath];
    self.musicDataLength=self.musicData.length;
    NSLog(@"rrrrrrrrrrrr%lu",(unsigned long)self.musicData.length);
    //----------------------------------------
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //----------------------------------------
    self.InteractionMode=2;
    self.SpeedLabel.text=[NSString stringWithFormat:@"%.1f" ,self.SpeedSilder.value];
    [self.SpeedLabel sizeToFit];
    
    //----------------------------------------
    
    [self initTimer];
    [self initplayTimer];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.playTimer setFireDate:[NSDate distantFuture]];
    
    self.drawView.isPlaying=false;
    
    [self.CurrentTime sizeToFit];
    [self.During sizeToFit];
    
    //------------------------------navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent=true;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //-----------------------------
    //--------------------------------set background image
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"BG_Image_3"ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.view.layer.contents=(id)image.CGImage;
    //------------------------------
    play1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"play"ofType:@"png"]];
    play2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"LinePlay"ofType:@"png"]];
    pause1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"pause"ofType:@"png"]];
    pause2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"LinePause"ofType:@"png"]];
    //------------------------------
    
     [self.OneTap requireGestureRecognizerToFail:self.TwoTap];
    
    if ([DefaultInstance sharedInstance].isFirst)
    {
        UIImageView *GudianceBG=[[UIImageView alloc]initWithFrame:self.view.bounds];
        GudianceBG.image=[UIImage imageNamed:@"EditGuidanceImage"];
        GudianceBG.userInteractionEnabled=true;
        [self.view addSubview:GudianceBG];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
        [GudianceBG addGestureRecognizer:tap];
        
        
    }
}
-(void)dismissGuideView:(UITapGestureRecognizer*)tap
{
   // NSLog(@"errererererer");
    UIView *view=tap.view;
    [view removeFromSuperview];
    [view removeGestureRecognizer:tap];
    //[self.player play];
}

- (void)openFileWithFilePathURL:(NSURL*)filePathURL
{
    self.audioFile = [EZAudioFile audioFileWithURL:filePathURL];
    self.editAudioPlot.plotType = EZPlotTypeBuffer;
    self.editAudioPlot.shouldFill = YES;
    self.editAudioPlot.shouldMirror = YES;
    __weak typeof (self) weakSelf = self;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [weakSelf.editAudioPlot updateBuffer:waveformData[0]
                               withBufferSize:length];
     }];
    
}
-(void)initAudioPlayer:(NSURL*)filePathURL
{
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:filePathURL error:nil];
    self.player.delegate=self;
    self.player.enableRate=true;
    self.player.rate=1.0;
    //self.currentTime.text=timeToString(self.player.currentTime);
}
-(void)initTimer{
    //    if (self.timer) {
    //        [self.timer invalidate];
    //        self.timer = nil;
    //    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(ShowCurrentTime) userInfo:@"admin" repeats:YES];
}
-(void)ShowCurrentTime{
    self.CurrentTime.text=timeToString(self.player.currentTime);//set time to 00:00
    double f=self.player.currentTime;
    double t=self.playEnding;
    if (f>=t)
    {
        if (self.InteractionMode==2)
        {
            self.player.currentTime=self.drawView.Left*self.player.duration/SCREEN_WIDTH;
        }
        else if (self.InteractionMode==1)
        {
            self.player.currentTime=self.drawView.StartX*self.player.duration/SCREEN_WIDTH;
        }
    }
    
}


-(void)initplayTimer{
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(UpdateCurrentPlayLine) userInfo:@"admin" repeats:YES];
}
-(void)UpdateCurrentPlayLine{
    
    double ctime=self.player.currentTime;
    self.drawView.LineX=ctime*SCREEN_WIDTH/self.player.duration;
    [self.drawView setNeedsDisplay];
    
}
-(void)deallocplayTimer{
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer=nil;
    }
}
#pragma mark - setPlayer
-(void)setplayerBeginPosition:(float)position
{
    self.player.currentTime=position*self.player.duration/SCREEN_WIDTH;
    self.CurrentTime.text=timeToString(self.player.currentTime);
    //[self dellocTimer];
    
}
-(void)setplayerEndPosition:(float)position
{
    self.playEnding=position*self.player.duration/SCREEN_WIDTH;
    self.During.text=timeToString(self.playEnding);
    //[self dellocTimer];
}

NSString* timeToString(float ctime)
{
    int totalTime=(int)(ctime+0.5);
    int mins;
    int secs;
    mins=totalTime/60;
    secs=totalTime%60;
    return [NSString stringWithFormat:@"%02d:%02d",mins,secs];
}


- (IBAction)SpeedSilderChange:(UISlider *)sender
{
    self.player.rate=self.SpeedSilder.value;
    self.SpeedLabel.text=[NSString stringWithFormat:@"%.1f" ,self.SpeedSilder.value];
}
- (IBAction)SaveButton:(UIButton *)sender
{
    if (![self.player isPlaying])
    {
        //[self deleteFile];
        float StartTime=self.drawView.Left*self.player.duration/SCREEN_WIDTH;
        float StopTime=self.drawView.Right*self.player.duration/SCREEN_WIDTH;
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.filePath options:nil];
        NSString *documentsPath=NSTemporaryDirectory();
        //NSData *filedata=[self.musicData subdataWithRange:range];
        // [filedata writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audio.mp3"] atomically:YES];
    
        //--------------------------------------------------------
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField)
         {
             textField.placeholder=@"New music";
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
         }];
        UIAlertAction *saveaction=[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            UITextField *login = alertController.textFields.firstObject;//get input field
            self.NewMusicFileName=login.text;//get input content
            NSLog(@"%@", self.NewMusicFileName);
            NSString *fileName=[self.NewMusicFileName stringByAppendingString:@".m4a"];
            //add .m4a suffix
            [self deleteFile:fileName];//find same file and delete
            NSString *filePath=[documentsPath stringByAppendingString:fileName];
            //combine filename with filepath
            NSLog(@"%@",filePath);
            
            [self exportAsset:asset toFilePath:filePath startTime:StartTime endTime:StopTime];
            //invoke export
            
            NSURL *url = [NSURL fileURLWithPath:filePath];//获取这个路径文件的url
            //---------------------------------------------调用分享
            self.documentInteractionController = [UIDocumentInteractionController
                                              interactionControllerWithURL:url];
            [self.documentInteractionController setDelegate:self];
            
            [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            //[self deleteFile:fileName];
            //            [self initAudioPlayer:url];
            //            [self.player play];
            NSFileManager *fm=[[NSFileManager alloc]init];
            [fm removeItemAtURL:url error:nil];
            
        }];
        [alertController addAction:saveaction];
        UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelaction];
        saveaction.enabled=NO;
        self.OKAction=saveaction;
        [self presentViewController:alertController animated:YES completion:nil];
        //-------------------------------------------
        
    }
}







- (IBAction)PanTap:(UIPanGestureRecognizer *)sender {
    if (![self.player isPlaying]&&(self.InteractionMode==2))
    {
        CGPoint point=[sender locationInView:self.drawView];
        float x=point.x;
        float y=point.y;
        NSLog(@"touch (x, y) is (%f, %f)", x, y);
        if (x>(self.drawView.Right-10))
        {
            self.drawView.Temp=2;
        }
        else if (x<(self.drawView.Left+3))
        {
            self.drawView.Temp=1;
        }
        switch (self.drawView.Temp)
        {
            case 1:
                if (x<self.drawView.Right)
                {
                    self.drawView.Left=x;
                }
                break;
            case 2:
                if ((x>self.drawView.Left)&&(x>self.drawView.LineX))
                {
                    self.drawView.Right=x;
                }
                break;
            default:
                break;
        }
        [self.drawView setNeedsDisplay];
        if (self.drawView.Temp==1)
        {
            self.CurrentTime.text=timeToString(x*self.player.duration/SCREEN_WIDTH);
            //[self setplayerBeginPosition:x];
        }
        else if (self.drawView.Temp==2)
        {
            [self setplayerEndPosition:self.drawView.Right];
        }
    }
}


#pragma mark - files
-(void)deleteFile:(NSString*)ssfilename {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:ssfilename];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

#pragma mark - audiocut
- (BOOL)exportAsset:(AVURLAsset *)avAsset toFilePath:(NSString *)filePath startTime:(float )Begin endTime:(float)End

{
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:filePath];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL fileType:AVFileTypeCoreAudioFormat error:nil];
    CMTime assetTime = [avAsset duration];//get the audio during time by second
    
    Float64 duration = CMTimeGetSeconds(assetTime); //return Float64
    
    
    CMTime startTime = CMTimeMake(Begin, 1);//CMTimeMake(frame position， frame rate)
    
    CMTime stopTime = CMTimeMake(End, 1);//CMTimeMake(frame postion，frame rate )
    
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);//time range
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                           initWithAsset:avAsset presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path
    
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
    
    exportSession.timeRange = exportTimeRange; // trim time range
    
    // perform the export
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         
         switch ([exportSession status]) {
             case AVAssetExportSessionStatusFailed:
                 
                 NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                 break;
             case AVAssetExportSessionStatusCancelled:
                 
                 NSLog(@"Export canceled");
                 break;
             default:
                 NSLog(@"Success");
         }
     }];
    
    return YES;
    
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    // Enforce a minimum length of >= 5 characters for secure text alerts.
    self.OKAction.enabled = textField.text.length >= 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LineButtonClick:(UIButton *)sender {
    if (![self.player isPlaying]){
        
        [self setplayerBeginPosition:self.drawView.Left];
        [self.player play];
        [self.PlayButton setImage:pause1 forState:UIControlStateNormal];
        [self.LineButton setImage:pause2 forState:UIControlStateNormal];
        self.drawView.isPlaying=true;
        [self.timer setFireDate:[NSDate date]];
        [self.playTimer setFireDate:[NSDate date]];
    }
    else if ([self.player isPlaying])
    {
        [self.player pause];
        [self.PlayButton setImage:play1 forState:UIControlStateNormal];
        [self.LineButton setImage:play2 forState:UIControlStateNormal];
        self.drawView.isPlaying=false;
        [self.drawView setNeedsDisplay];
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.playTimer setFireDate:[NSDate distantFuture]];
    }
}
- (IBAction)PlayButtonClick:(UIButton *)sender {
    if (![self.player isPlaying]){
        
        if (self.player.currentTime<(self.drawView.Left*self.player.duration/SCREEN_WIDTH))
        {
            [self setplayerBeginPosition:self.drawView.Left];
        }
        [self.player play];
        [self.PlayButton setImage:pause1 forState:UIControlStateNormal];
        [self.LineButton setImage:pause2 forState:UIControlStateNormal];
        self.drawView.isPlaying=true;
        [self.timer setFireDate:[NSDate date]];
        [self.playTimer setFireDate:[NSDate date]];
    }
    else if ([self.player isPlaying])
    {
        [self.player pause];
        [self.PlayButton setImage:play1 forState:UIControlStateNormal];
        [self.LineButton setImage:play2 forState:UIControlStateNormal];
        self.drawView.isPlaying=false;
        [self.drawView setNeedsDisplay];
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.playTimer setFireDate:[NSDate distantFuture]];
    }
}

- (IBAction)ResetSpeedButtonClick:(UIButton *)sender {
    self.SpeedSilder.value=1.0;
    self.SpeedLabel.text=[NSString stringWithFormat:@"%.1f" ,self.SpeedSilder.value];
    self.player.rate=1.0;
}
@end

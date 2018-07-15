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
    
    //-----------------------------------SPlayer
    //---------------------------------------------
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
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
    [self.player play];
}

-(void)getMusiclist
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    
    NSArray *queryArry = [query items];
    
    for (MPMediaItem *item in queryArry)
    {
        
        NSURL *assetURL;
        
        if ([item valueForProperty:MPMediaItemPropertyAssetURL])
        {
            
            assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
            
        }
        if (assetURL)
        {
            [self convertToMp3:item];
            //
            //AVAudioPlayer *pptempPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:assetURL error:nil];
            //            [pptempPlayer play];
            //            NSData *pptempPlayerData=[[NSData alloc]initWithData:pptempPlayer.data];
            //            NSString *tmpPath=NSTemporaryDirectory();
            //            NSString *tmpFileName=[item valueForProperty:MPMediaItemPropertyTitle];
        }
    }
    
}

- (void) convertToMp3: (MPMediaItem *)song
{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    //NSString *documentsDirectoryPath = NSTemporaryDirectory();
    
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray *ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile])
    {
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFile];
    
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         //NSData *data1 = [NSData dataWithContentsOfFile:exportFile];
         //NSLog(@"==================data1:%@",data1);
         
         
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
                 
             case AVAssetExportSessionStatusFailed: {
                 
                 // log error to text view
                 NSError *exportError = exporter.error;
                 
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 
                 
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusCompleted: {
                 
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusUnknown: {
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 break;
             }
             case AVAssetExportSessionStatusExporting: {
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 break;
             }
                 
             case AVAssetExportSessionStatusCancelled: {
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 break;
             }
                 
             case AVAssetExportSessionStatusWaiting: {
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 break;
             }
                 
             default:
             { NSLog (@"didn't get export status");
                 break;
             }
         }
         
     }];
}


#pragma mark - Actions



- (IBAction)setPlayMode:(UITapGestureRecognizer *)sender {
    if ([self.player isPlaying]&&(self.audioPlot.plotType==EZPlotTypeBuffer)&&(self.audioPlot.shouldFill==YES))
    {
        self.audioPlot.shouldFill=NO;
        self.audioPlot.shouldMirror=NO;
        [self.audioPlot setRollingHistoryLength:512];
        
    }
    else if ([self.player isPlaying]&&(self.audioPlot.plotType==EZPlotTypeBuffer)&&(self.audioPlot.shouldFill==NO))
    {
        self.audioPlot.shouldMirror=YES;
        self.audioPlot.shouldFill=YES;
        [self.audioPlot setRollingHistoryLength:512];
        //self.audioPlot.plotType=EZPlotTypeRolling;
    }
    
}

- (IBAction)PlayController:(UITapGestureRecognizer *)sender {
    if ([self.player isPlaying])
    {
        [self.player pause];
    }
    else
    {
        [self.player play];
    }
}




- (IBAction)DownSwipe:(UISwipeGestureRecognizer *)sender {
    if (self.player.volume>=0.1)
    {
        self.player.volume-=0.1;
    }
}

- (IBAction)UpSwipe:(UISwipeGestureRecognizer *)sender {
    if (self.player.volume<=0.9)
    {
        self.player.volume+=0.1;
    }
}

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

- (IBAction)LeftSwipe:(UISwipeGestureRecognizer *)sender {
    
}

- (IBAction)LongPress:(UILongPressGestureRecognizer *)sender {
}



- (IBAction)changeViews:(UIButton *)sender {
    if ([self.player isPlaying])
    {
        //self.mp3Array=[[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"BGM"];
        [self.player pause];
        [self openFileWithFilePathURL:[NSURL fileURLWithPath:musicPaths[mp3Number]]];
        
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

- (IBAction)ChangeView:(UIBarButtonItem *)sender {
    [self.player pause];
}








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
    });
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
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


@end


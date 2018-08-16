//
//  UIRecorderViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//
#define kAudioFilePath @"test.m4a"


#import "UIRecorderViewController.h"
#import "ViewController.h"

@interface UIRecorderViewController ()

@end

@implementation UIRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTableView) name:@"UpdateTableView" object:nil];
    //------------------------------UI
    self.EZRecordPlot.backgroundColor = [UIColor clearColor];
    self.EZRecordPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.EZRecordPlot.plotType        = EZPlotTypeRolling;
    self.EZRecordPlot.shouldFill      = YES;
    self.EZRecordPlot.shouldMirror    = YES;
    //------------------------------UI
    //------------------------------delegate&&init
    self.microphone=[EZMicrophone microphoneWithDelegate:self];
    self.EZRecorder=[EZRecorder recorderWithURL:[self testFilePathURL] clientFormat:[self.microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
    self.Player=[EZAudioPlayer audioPlayerWithDelegate:self];
    //--------------------------------
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
    //--------------------------------set background image
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"BG_Image_3"ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.view.layer.contents=(id)image.CGImage;
    //------------------------------
    //------------------------------navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent=true;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //-----------------------------
    //-----------------------------
    self.UIRecordTableView.backgroundColor=[UIColor clearColor];
    //-----------------------------
    
    [self UpdateTableView];
    
    // Do any additional setup after loading the view.
}
- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying
{
    self.microphoneStateLabel.text = isPlaying ? @"MicOn" : @"MicOff";
    [self.microphoneStateLabel sizeToFit];
    //self.microphoneSwitch.on = isPlaying;
}
- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{ __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.EZRecordPlot updateBuffer:buffer[0]
                             withBufferSize:bufferSize];
    });
}
- (void)   microphone:(EZMicrophone *)microphone
        hasBufferList:(AudioBufferList *)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    [self.EZRecorder appendDataFromBufferList:bufferList
                               withBufferSize:bufferSize];
    
}
- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder
{
    __weak typeof (self) weakSelf = self;
    NSString *formattedCurrentTime = [recorder formattedCurrentTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.RecordCurrentTimeLabel.text = formattedCurrentTime;
        [weakSelf.RecordCurrentTimeLabel sizeToFit];
    });
}
- (void)recorderDidClose:(EZRecorder *)recorder
{
    recorder.delegate = nil;
}


- (NSURL *)testFilePathURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                   NSTemporaryDirectory(),
                                   kAudioFilePath]];
}
-(NSString*)testFilePath
{
    return [NSString stringWithFormat:@"%@/%@",
            NSTemporaryDirectory(),
            kAudioFilePath];
}
-(NSString*)SaveFilePath:(NSString*)SaveFileName
{
    return [NSString stringWithFormat:@"%@/%@",
            NSTemporaryDirectory(),
            SaveFileName];
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    // Enforce a minimum length of >= 5 characters for secure text alerts.
    self.OKAction.enabled = textField.text.length >= 1;
}
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
- (IBAction)UIRecordStartButtonClick:(UIButton *)sender {
    if (self.EZRecorder.delegate==nil)
    {
        self.EZRecorder=[EZRecorder recorderWithURL:[self testFilePathURL] clientFormat:[self.microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
        [self.EZRecordPlot clear];
        self.RecordCurrentTimeLabel.text=@"00:00";
    }
    
    [self.microphone startFetchingAudio];
    
}
- (IBAction)UIRecordStopButtonClick:(UIButton *)sender {
    [self.microphone stopFetchingAudio];
    if (self.EZRecorder)
    {
        [self.EZRecorder closeAudioFile];
        NSFileManager *fm=[[NSFileManager alloc]init];
        //[fm moveItemAtPath:[self testFilePath] toPath:[self SaveFilePath:@"3333.m4a"] error:nil];
        UIAlertController *Alert=[UIAlertController alertControllerWithTitle:@"Input the file name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [Alert addTextFieldWithConfigurationHandler:^(UITextField*textField)
         {
             textField.placeholder=@"Record file name";
             [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
         }];
        UIAlertAction *saveaction=[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       UITextField *Login=Alert.textFields.firstObject;
                                       NSString *filename=[Login.text stringByAppendingString:@".m4a"];
                                       [self deleteFile:filename];
                                       [fm moveItemAtPath:[self testFilePath] toPath:[self SaveFilePath:filename] error:nil];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTableView" object:nil];
                                       self.EZRecorder=[EZRecorder recorderWithURL:[self testFilePathURL] clientFormat:[self.microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
                                       self.RecordCurrentTimeLabel.text=@"00:00";
                                       [self.EZRecordPlot clear];
                                   }];
        [Alert addAction:saveaction];
        UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                     {
                                         self.EZRecorder=[EZRecorder recorderWithURL:[self testFilePathURL] clientFormat:[self.microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
                                         self.RecordCurrentTimeLabel.text=@"00:00";
                                         [self.EZRecordPlot clear];
                                     }];
        [Alert addAction:cancelaction];
        saveaction.enabled=false;
        self.OKAction=saveaction;
        [self presentViewController:Alert animated:true completion:nil];
    }
    //UIAlertController *Alert=[UIAlertController alertControllerWithTitle:@"Input the file name" message:nil preferredStyle:UIAlertControllerStyleAlert];
}


- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.Player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:self.Player];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshTableView) name:UITAbleViewRefreshNotification object:nil];
}
- (void)playerDidChangePlayState:(NSNotification *)notification
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EZAudioPlayer *player = [notification object];
        BOOL isPlaying = [player isPlaying];
        if (isPlaying)
        {
            weakSelf.EZRecorder.delegate = nil;
        }
        //weakSelf.playingStateLabel.text = isPlaying ? @"Playing" : @"Not Playing";
        //weakSelf.playingAudioPlot.hidden = !isPlaying;
    });
}

//------------------------------------------------------------------------------

- (void)playerDidReachEndOfFile:(NSNotification *)notification
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // [weakSelf.playingAudioPlot clear];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView
-(void)UpdateTableView
{
    
    self.RecordFileNameArray=[[NSMutableArray alloc]init];
    NSFileManager *fm=[[NSFileManager alloc]init];
    self.RecordFileNameArray=[NSMutableArray arrayWithArray:[fm contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil]];
    [self.RecordFileNameArray removeObject:kAudioFilePath];
    [self.UIRecordTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.RecordFileNameArray!=nil)
    {
        return (self.RecordFileNameArray.count);
    }
    else
    {return 0;
        
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=self.RecordFileNameArray[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.text=@">";
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    //NSFileManager *fm=[[NSFileManager alloc]init];
    NSURL *url=[NSURL fileURLWithPath:NSTemporaryDirectory()];
    NSMutableArray *RecordFilePathURLArray=[[NSMutableArray alloc]init];
    if (self.RecordFileNameArray!=nil)
    {
        for (int i=0;i<self.RecordFileNameArray.count;i++)
        {
            NSString *RecordFilePathURL=[NSString stringWithFormat:@"%@%@",url,self.RecordFileNameArray[i]];
            NSURL *uurl=[NSURL URLWithString:RecordFilePathURL];
            [RecordFilePathURLArray insertObject:uurl atIndex:i];
        }
    }
    [DefaultInstance sharedInstance].filenameArray=self.RecordFileNameArray;
    [DefaultInstance sharedInstance].filepathArray=RecordFilePathURLArray;
    [DefaultInstance sharedInstance].audioNumber=indexPath.row;
    ViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"UIRepeatViewController"];
    VC.hidesBottomBarWhenPushed=true;
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
    
    //NSLog(@"%d",[DefaultInstance sharedInstance].audioNumber);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)PushPlayerlistVC:(UIButton *)sender {
    ViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"UIPlayerListViewController"];
   // [self presentViewController:VC animated:YES completion:nil];
}
@end

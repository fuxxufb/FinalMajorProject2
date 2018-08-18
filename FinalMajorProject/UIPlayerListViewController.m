//
//  UIPlayerListViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "UIPlayerListViewController.h"
#import "WiFiConnectController.h"
#import "DefaultInstance.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface UIPlayerListViewController ()<UITableViewDelegate,UITableViewDataSource>



@end
NSString *ipString;
@implementation UIPlayerListViewController

- (void)viewDidLoad {
    
    //--------------load namearray and url(path) array
    self.fileArray=[DefaultInstance sharedInstance].fileArray;
    self.filenameArray=[DefaultInstance sharedInstance].filenameArray;
    //if (self.filenameArray==nil)
    //{
    self.filenameArray=[[NSMutableArray alloc]init];
    //}
    self.filepathArray=[DefaultInstance sharedInstance].filepathArray;
    //if (self.filepathArray==nil)
    //{
    self.filepathArray=[[NSMutableArray alloc]init];
    //}
    //-----------
    [super viewDidLoad];
    //--------------------------------set background image
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"BG_Image_3"ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.view.layer.contents=(id)image.CGImage;
    //------------------------------
    
    //-----------------------------
    self.fileTableView.backgroundColor=[UIColor clearColor];
    //----------------------------
    
    //------------------set navigationbar and tabbar lucency
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent=true;
    // [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
    //[self.tabBarController.tabBar setShadowImage:[UIImage new]];
    //self.tabBarController.tabBar.translucent=true;
    //-------------------------------------------------
    //---------------------------set statusbar white(plist changed)
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //----------------------set notificationcenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFile) name:@"processEpilogueData" object:nil];
    //---------------------
    
    [self showFile];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue destinationViewController].hidesBottomBarWhenPushed=true;
}

- (void)showFile {
    //dispatch_async(dispatch_get_main_queue(), ^{
    NSFileManager *fileManager=[NSFileManager defaultManager];//init Filemanager
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//get Document folder Path
    // NSLog(@"Path：%@", documentsPath);
    NSMutableArray *fArray=[[NSMutableArray alloc]init];//init FileArray
    fArray = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentsPath
                                                                             error:nil]];//Get file name in the Document Path
    // NSLog(@"%@",self.filenameArray[0]);
    for (int i=0;i<fArray.count;i++)//traversal array
    {
        NSString *str=[NSString stringWithString:fArray[i]];
        NSString *doc2=[documentsPath stringByAppendingString:@"/"];
        NSString *str2=[doc2 stringByAppendingString:str];//DocumentPath+'/'+filename=fileabsolutePath
        // NSLog(@"%@",str2);
        if ([str2 isAbsolutePath])
        {
            NSURL *url=[NSURL fileURLWithPath:str2];//To URL
            AVAudioFile *avFile=[[AVAudioFile alloc]initForReading:url error:nil];
            if (avFile!=nil)
            {
                if (![self.filepathArray containsObject:url])
                {
                    [self.filenameArray addObject:fArray[i]];//Add to Core Array
                    [self.filepathArray addObject:url];
                }
            }
            
        }
    }
    //  NSLog(@"%@",str);
    [DefaultInstance sharedInstance].filenameArray=self.filenameArray;
    [DefaultInstance sharedInstance].filepathArray=self.filepathArray;
    [self.fileTableView reloadData];
    [self UpdateInformationLabelColor];
    if (self.filepathArray.count==0)
    {
        self.InformationLabel.hidden=false;
        
    }
    else
    {
        self.InformationLabel.hidden=true;
    }
    //});
    
}


-(UIAlertController*)CreateAlertController
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:ipString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"processEpilogueData" object:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    return alert;
}

-(void)UpdateInformationLabelColor
{
    if ([DefaultInstance sharedInstance].isFirst)
    {
        self.InformationLabel.textColor=[UIColor blueColor];
        
    }
    else
    {
        self.InformationLabel.textColor=[UIColor greenColor];
    }
}

- (IBAction)UITableViewRefresh:(UIBarButtonItem *)sender {
    //[DefaultInstance sharedInstance].isFirst=false;
    [self showFile];
}

- (IBAction)AddAudioButtonClick:(UIButton *)sender {
    [self presentViewController:[self CreateAlertController] animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"processEpilogueData" object:nil];
    
}

- (IBAction)PushRecorderVC:(UIButton *)sender {
    //ViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"UIRecorderViewController"];
    // [self presentViewController:VC animated:YES completion:nil];
}
//[[NSNotificationCenter defaultCenter] postNotificationName:@"processEpilogueData" object:nil];
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filenameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.filenameArray[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    //set UI of the cells
    EZAudioFile *avFile=[[EZAudioFile alloc]initWithURL:self.filepathArray[indexPath.row]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",avFile.formattedDuration];//show the during time in the detail label
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    //int t=indexPath.row;
    [self showFile];
    [DefaultInstance sharedInstance].audioNumber=indexPath.row;
    //NSLog(@"%d",[DefaultInstance sharedInstance].audioNumber);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// define edit style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// define callbacks
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self Deleteitem:indexPath.row];// invoke DeleteItem function
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if ((self.filepathArray.count==0)&&(self.InformationLabel.hidden==true))
        {
            self.InformationLabel.hidden=false;
        }
    }
}
// change edit label content
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}
-(void)Deleteitem:(long)indexRow
{
    
    NSFileManager *fm=[[NSFileManager alloc]init];
    [fm removeItemAtURL:self.filepathArray[indexRow] error:nil];
    [self.filenameArray removeObjectAtIndex:(NSUInteger)indexRow];
    [self.filepathArray removeObjectAtIndex:(NSUInteger)indexRow];
    [DefaultInstance sharedInstance].filepathArray=self.filepathArray;
    [DefaultInstance sharedInstance].filenameArray=self.filenameArray;
    //[self showFile];
}



@end

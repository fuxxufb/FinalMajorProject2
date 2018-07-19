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
@interface UIPlayerListViewController ()<UITableViewDelegate,UITableViewDataSource>



@end
NSString *ipString;
@implementation UIPlayerListViewController

- (void)viewDidLoad {
    self.filenameArray=[DefaultInstance sharedInstance].filenameArray;
    self.fileArray=[DefaultInstance sharedInstance].fileArray;
    self.filepathArray=[DefaultInstance sharedInstance].filepathArray;
    self.filepathArray=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFile) name:@"processEpilogueData" object:nil];
    [self showFile];
    
    //self.tabBarController.tabBar.hidden=false;
    /* HTTPServer *httpServer;
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"filePath : %@", filePath);
    httpServer=[[HTTPServer alloc]init];
    [httpServer setType:@"_http._tcp."];
    NSString *webPath=[[NSBundle mainBundle]resourcePath];
    NSLog(@"webPath:%@",webPath);
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *error;
    if ([httpServer start:&error])
    {
        ipString = [NSString stringWithFormat:@"请在网页输入这个地址  http://%@:%hu/", [SJXCSMIPHelper deviceIPAdress], [httpServer listeningPort]];
        NSLog(@"%@",ipString);
        
    }else
    {
        NSLog(@"%@",error);
    }*/
    
    
    //NSLog([WiFiConnectController OnloadWiFiServer]);
    
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
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"地址：%@", documentsPath);
        
    self.filenameArray = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentsPath error:nil]];
   // NSLog(@"%@",self.filenameArray[0]);
    for (int i=0;i<self.filenameArray.count;i++)
    {
        NSString *str=[NSString stringWithString:self.filenameArray[i]];
        NSString *doc2=[documentsPath stringByAppendingString:@"/"];
        NSString *str2=[doc2 stringByAppendingString:str];
        NSLog(@"%@",str2);
        if ([str2 isAbsolutePath])
        {
            NSURL *url=[NSURL fileURLWithPath:str2];
            [self.filepathArray insertObject:url atIndex:i];
        }
    }
  //  NSLog(@"%@",str);
    [DefaultInstance sharedInstance].filenameArray=self.filenameArray;
    [DefaultInstance sharedInstance].filepathArray=self.filepathArray;
    [self.fileTableView reloadData];
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

- (IBAction)UITableViewRefresh:(UIButton *)sender {
    [self showFile];
}

- (IBAction)AddAudioButtonClick:(UIButton *)sender {
    [self presentViewController:[self CreateAlertController] animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"processEpilogueData" object:nil];
    
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
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [DefaultInstance sharedInstance].audioNumber=indexPath.row;
    //NSLog(@"%d",[DefaultInstance sharedInstance].audioNumber);
}

@end

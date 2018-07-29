//
//  UIAddViewViewController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/11.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "UIAddViewViewController.h"
#import "WiFiConnectController.h"

@interface UIAddViewViewController ()

@end

@implementation UIAddViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ipAddressLabel.text=[WiFiConnectController OnloadWiFiServer];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"BG_transfer"ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.view.layer.contents=(id)image.CGImage;
    //------------------------------navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent=true;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //-----------------------------
    
    [self.ipAddressLabel sizeToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

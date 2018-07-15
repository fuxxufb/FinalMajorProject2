//
//  UIPlayerListViewController.h
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlayerListViewController : UIViewController
@property(nonatomic,strong) NSMutableArray *filenameArray;
@property(nonatomic,strong) NSMutableArray *filepathArray;
@property(nonatomic,strong) NSMutableArray *fileArray;
@property (strong, nonatomic) IBOutlet UITableView *fileTableView;
- (IBAction)UITableViewRefresh:(UIButton *)sender;


- (IBAction)AddAudioButtonClick:(UIButton *)sender;

@end

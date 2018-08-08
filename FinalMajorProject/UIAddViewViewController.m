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
    [self demo1];
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
-(void)demo1{
    //访问百度首页
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:@"http://m.baidu.com"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述                    
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //response ： 响应：服务器的响应
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //error：链接错误的信息
        NSLog(@"网络响应：response：%@",response);
        
        //根据返回的二进制数据，生成字符串！NSUTF8StringEncoding：编码方式
        NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        //在客户端直接打开一个网页！
        //客户端服务器：UIWebView
        
        //将浏览器加载到view上
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //实例化一个客户端浏览器
            UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
            
            //加载html字符串：baseURL：基准的地址：相对路径/绝对路径
            [web loadHTMLString:html baseURL:nil];
           // [self.view addSubview:web];
            //[self.view sendSubviewToBack:web];
        });
        
        //        //在本地保存百度首页
        //        [data writeToFile:@"/Users/Liu/Desktop/baidu.html" atomically:YES];
        
    }
                                    ];
    
    //5.执行任务
    [dataTask resume];
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

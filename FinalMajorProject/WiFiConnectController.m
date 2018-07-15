//
//  WiFiConnectController.m
//  FinalMajorProject
//
//  Created by Xiaohan Yang on 2018/7/9.
//  Copyright © 2018年 xiaohan yang. All rights reserved.
//

#import "WiFiConnectController.h"

@interface WiFiConnectController()
{
    
}
@end

@implementation WiFiConnectController
+(NSString*)OnloadWiFiServer
{
    static HTTPServer *httpServer;
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"filePath : %@", filePath);
    httpServer=[[HTTPServer alloc]init];
    [httpServer setType:@"_http._tcp."];
    NSString *webPath=[[NSBundle mainBundle]resourcePath];
   // NSLog(@"webPath:%@",webPath);
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *error;
    if ([httpServer start:&error])
    {
        NSString *ipString = [NSString stringWithFormat:@"http://%@:%hu/", [SJXCSMIPHelper deviceIPAdress], [httpServer listeningPort]];
        return ipString;
    }
    else
    {
        return (@"Can not start httpserver");
    }
}

@end

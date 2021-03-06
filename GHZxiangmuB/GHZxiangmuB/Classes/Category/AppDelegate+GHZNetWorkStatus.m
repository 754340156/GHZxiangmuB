//
//  AppDelegate+GHZNetWorkStatus.m
//  GHZxiangmuB
//
//  Created by    on 16/7/18.
//  Copyright © 2016年  赵哲. All rights reserved.
//

#import "AppDelegate+GHZNetWorkStatus.h"
#import <AFNetworking.h>
@implementation AppDelegate (GHZNetWorkStatus)

- (void)appNetWorkStatus
{
    //检测网络
    AFNetworkReachabilityManager *magr = [AFNetworkReachabilityManager sharedManager];
    [magr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *newWorkStatus = @"";

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"不清楚");
                break;
            case AFNetworkReachabilityStatusNotReachable:
               newWorkStatus = @"当前没有网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
               newWorkStatus = @"当前网络状态已经变为2G/3G/4G网络,如果继续使用可能产生流量费用(运营商收取),点击取消可以关闭蜂窝网络设置";
                break;
        }
        if (!newWorkStatus.length) {
            return ;
        }
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"流量提醒" message:newWorkStatus preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [controller addAction:cancleAction];
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [controller addAction:doAction];
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }];
    //开启检测
    [magr startMonitoring];
}

@end

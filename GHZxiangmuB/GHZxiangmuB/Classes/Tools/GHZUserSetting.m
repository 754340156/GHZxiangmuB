//
//  GHZUserSetting.m
//  GHZxiangmuB
//
//  Created by    on 16/7/15.
//  Copyright © 2016年  赵哲. All rights reserved.
//

#import "GHZUserSetting.h"

@implementation GHZUserSetting

static GHZUserSetting *setting = nil;
+ (instancetype)shareInstance
{
    if (!setting) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            setting = [[GHZUserSetting alloc] init];
        });
    }
    return setting;
}

@end

//
//  GHZTabBarViewController.m
//  xiangmu
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 lanou3g-22赵哲. All rights reserved.
//

#import "GHZTabBarViewController.h"
#import "GHZNavViewController.h"
#import "GHZCreamViewController.h"
#import "GHZNewViewController.h"
#import "GHZLiveViewController.h"
#import "GHZProfileViewController.h"
#import "GHZLoginViewController.h"
#import "EMSDK.h"
@interface GHZTabBarViewController ()<EMClientDelegate>

@end

@implementation GHZTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarWithViewController:[[GHZCreamViewController alloc]init] image:@"paper" selectImage:@"paperH" title:@"精华"];
    
    [self setTabBarWithViewController:[[GHZNewViewController alloc]init] image:@"video" selectImage:@"videoH" title:@"最新"];
    
    [self setTabBarWithViewController:[[GHZLiveViewController alloc]init] image:@"2image" selectImage:@"2imageH" title:@"直播"];
    //自定登录判定
    [self setTabBarWithViewController:[[GHZProfileViewController alloc]init] image:@"person" selectImage:@"personH" title:@"个人中心"];
}


/**
 *  创建导航控制器的方法
 */
- (void)setTabBarWithViewController:(UIViewController *)viewControler image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title
{
    GHZNavViewController *navc = [[GHZNavViewController alloc] initWithRootViewController:viewControler];
    navc.tabBarItem.title = title;
    [navc.tabBarItem setImage:[UIImage imageNamed:image]];
    [navc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:navc];
}


@end

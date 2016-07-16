//
//  GHZTopicViewController.m
//  GHZxiangmuB
//
//  Created by lanou3g on 16/7/11.
//  Copyright © 2016年 lanou3g-22赵哲. All rights reserved.
//   父类controller
#import "GHZTopicViewController.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "GHZTopicModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GHZNewWordCell.h"
#import "GHZNewVideoView.h"
#import "GHZNewVideoView.h"
#import "UMSocial.h"
@interface GHZTopicViewController ()<UIScrollViewDelegate,GHZNewWordCellDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
/** 段子*/
@property (nonatomic,strong)NSMutableArray *topics;
/** 当前页数*/
@property (nonatomic,assign)NSInteger page;
/** 加载下一页的参数*/
@property (nonatomic,copy)NSString *maxtime;
/** 上一次请求的参数*/
@property (nonatomic,strong)NSDictionary *params;
@property (nonatomic,strong)NSIndexPath *paths;
@property (nonatomic,strong)GHZNewVideoView *v;
@property (nonatomic,strong)GHZTopicModel *mm;
@property (nonatomic,strong)NSIndexPath *indexs;

@end

@implementation GHZTopicViewController
-(NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setupTable];
    
    //添加下拉刷新
    [self addRefresh];
}

-(void)setupTable{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat bottom = self.tabBarController.tabBar.GHZ_height;
    CGFloat top = GHZTitleVH+GHZTitleVY;
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GHZNewWordCell" bundle:nil] forCellReuseIdentifier:@"GHZNewWordCell"];
    
}

-(void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadingData)];
    //自动改变透明
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingAddData)];
    
}

/**
 * 加载数据
 */
-(void)loadingData{
    //结束上拉
    [self.tableView.mj_footer endRefreshing];
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = @"newlist";
    dic[@"c"] = @"data";
    dic[@"type"] = @(self.type);
    self.params = dic;
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params!=dic) {
            return ;
        }
        self.topics = [GHZTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        [self.tableView reloadData];
        self.page = 0;//页码
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (self.params!=dic) {
            return ;
        }
        [self.tableView.mj_header endRefreshing];
    }];
    
}
//先下拉 在上拉
//下拉刷新回来:只有一页数据,page 0
//上拉刷新成功回来:最前面页 加第5页
/**
 * 下拉加载新数据
 */
-(void)loadingAddData{
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = @"newlist";
    dic[@"c"] = @"data";
    dic[@"type"] = @(self.type);
    NSInteger page = self.page +1;
    dic[@"page"] = @(page);
    dic[@"maxtime"] = self.maxtime;
    self.params = dic;
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params!=dic) {
            return ;
        }
        //字典转模型
        NSMutableArray *newtopics = [GHZTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newtopics];
        //获取maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        [self.tableView reloadData];
        self.page = page; //加载成功page
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params!=dic) {
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count==0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak GHZNewWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHZNewWordCell"];
    self.mm = self.topics[indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.model = self.mm;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GHZTopicModel *model = self.topics[indexPath.row];
   
    return model.cellHeight;
}

-(void)getclick:(NSString *)image url:(NSString *)url text:(NSString *)text{
    [[UMSocialData defaultData].urlResource setResourceType:(UMSocialUrlResourceTypeImage) url:image];
    [UMSocialData defaultData].extConfig.title = @"";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57490f1ee0f55a75d5002f3f" shareText:[NSString stringWithFormat:@"%@%@",text,image] shareImage:image shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone] delegate:self];
    
}



@end

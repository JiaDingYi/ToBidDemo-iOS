//
//  WindmillNativeTableViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/9.
//

#import "WindmillNativeTableViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "WindMillFeedAdViewStyle.h"
#import "FeedNormalModel.h"
#import "WindFeedNormalTableViewCell.h"
#import "WindMillFeedAdLeftTableViewCell.h"
#import "WindMillFeedAdLargeTableViewCell.h"
#import "WindMillFeedAdImageGroupTableViewCell.h"
#import "WindMillFeedVideoTableViewCell.h"
#import "WindMillFeedExpressAdTableViewCell.h"
#import <UIView+Toast.h>

@interface WindmillNativeTableViewController ()<WindMillNativeAdsManagerDelegate, WindMillNativeAdViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) WindMillNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NSMutableDictionary *nativeExpressViewHeightDict;
@property (nonatomic, assign) NSUInteger refreshState;

@end

@implementation WindmillNativeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    _nativeExpressViewHeightDict = [NSMutableDictionary new];
    self.dataSource = [NSMutableArray new];
    [self pbud_resetDemoData];
    [self init_tableView];
    [self loadAdData];
}

// 重置测试数据，非广告数据
- (void)pbud_resetDemoData {
    NSString *feedPath = [[NSBundle mainBundle] pathForResource:@"feedInfo" ofType:@"cactus"];
    NSString *feedStr = [NSString stringWithContentsOfFile:feedPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [FeedNormalModel mj_objectArrayWithKeyValuesArray:[feedStr mj_JSONObject]];
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray new];
    }
    [self.dataSource addObjectsFromArray:arr];
    NSInteger datasCount = arr.count;
    if (datasCount > 3) {
        for (int i = 0; i < datasCount; i++) {
            NSUInteger index = rand() % (datasCount - 3) + 2;
            [self.dataSource addObject:[arr objectAtIndex:index]];
        }
    }
}

- (void)pbud_insertIntoDataSourceWithArray:(NSArray *)array {
    if (self.refreshState == 2) {
        [self.dataSource addObjectsFromArray:array];
    }else {
        if (self.dataSource.count > 3) {
            //随机
            for (id item in array) {
                NSUInteger index = rand() % (self.dataSource.count - 3) + 2;
                [self.dataSource insertObject:item atIndex:index];
            }
        }
    }
}

- (void)init_tableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).offset(0);
    }];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[WindFeedNormalTableViewCell class]
           forCellReuseIdentifier:@"WindFeedNormalTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalTitleTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalTitleTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalTitleImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalTitleImgTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalBigImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalBigImgTableViewCell"];
    [self.tableView registerClass:[WindFeedNormalthreeImgTableViewCell class] forCellReuseIdentifier:@"WindFeedNormalthreeImgTableViewCell"];
    [self.tableView registerClass:[WindMillFeedAdLeftTableViewCell class]
           forCellReuseIdentifier:@"WindMillFeedAdLeftTableViewCell"];
    [self.tableView registerClass:[WindMillFeedAdLargeTableViewCell class]
           forCellReuseIdentifier:@"WindMillFeedAdLargeTableViewCell"];
    [self.tableView registerClass:[WindMillFeedAdImageGroupTableViewCell class]
           forCellReuseIdentifier:@"WindMillFeedAdImageGroupTableViewCell"];
    [self.tableView registerClass:[WindMillFeedVideoTableViewCell class]
           forCellReuseIdentifier:@"WindMillFeedVideoTableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.refreshState = 2;
        [strongSelf loadMoreAds];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer = refreshFooter;
}


- (void)loadMoreAds {
    DDLogDebug(@"loadMoreAds---");
    [self loadAdData];
}

- (void)loadAdData {
    if (!self.nativeAdsManager) {
        WindMillAdRequest *request = [WindMillAdRequest request];
        request.placementId = self.placementId;
        request.userId = @"your user id";
        request.options = @{@"test_key_1":@"test_value"};//s2s激励回传自定义参数，可以为nil
        self.nativeAdsManager = [[WindMillNativeAdsManager alloc] initWithRequest:request];
    }
    self.nativeAdsManager.adSize = CGSizeMake(self.width, self.height);
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:3];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[FeedNormalModel class]]) {
        return [(FeedNormalModel *)model cellHeight];
    }
    if ([model isKindOfClass:[WindMillNativeAd class]]) {
        WindMillNativeAd *nativeAd = (WindMillNativeAd *)model;
        if (nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
            NSString *sizeStr = [_nativeExpressViewHeightDict objectForKey:@(nativeAd.hash).stringValue];
            if (sizeStr) {
                CGRect rect = CGRectFromString(sizeStr);
                return rect.size.height + 10;
            }
            return 0;
        }else {
            CGFloat width = CGRectGetWidth(self.tableView.bounds);
            return [WindMillFeedAdViewStyle cellHeightWithModel:nativeAd width:width];
        }
        
    }
    return 0;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSString *)classNameWithCellType:(NSString *)type {
    if ([type isEqualToString: @"title"]) {
        return @"WindFeedNormalTitleTableViewCell";
    }else if ([type isEqualToString: @"titleImg"]){
        return @"WindFeedNormalTitleImgTableViewCell";
    }else if ([type isEqualToString: @"bigImg"]){
        return @"WindFeedNormalBigImgTableViewCell";
    }else if ([type isEqualToString: @"threeImgs"]){
        return @"WindFeedNormalthreeImgTableViewCell";
    }else{
        return @"unkownCell";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[FeedNormalModel class]]) {
        NSString *clazz=[self classNameWithCellType:[(FeedNormalModel *)model type]];
        WindFeedNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
        if (!cell) {
            cell = [(WindFeedNormalTableViewCell *)[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazz];
        }
        if (indexPath.row == 0) {
            cell.separatorLine.hidden = YES;
        }
        [cell refreshUIWithModel:model];
        return cell;
    }
    if ([model isKindOfClass:[WindMillNativeAd class]]) {
        WindMillNativeAd *nativeAd = (WindMillNativeAd *)model;
        NSString *cellIdentifier = [NSString stringWithFormat:@"exp-cell-%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
        WindMillFeedAdBaseTableViewCell<WindMillFeedCellProtocol> *cell;
        DDLogDebug(@"cellIdentifier = %@", cellIdentifier);
        ///cell不能复用
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
            if (cell == nil) {
                cell = [[WindMillFeedExpressAdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }else if (nativeAd.feedADMode == WindMillFeedADModeSmallImage) {
            if (cell == nil) {
                cell = [[WindMillFeedAdLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage || nativeAd.feedADMode == WindMillFeedADModePortraitImage ) {
            if (cell == nil) {
                cell = [[WindMillFeedAdLargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }else if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
            if (cell == nil) {
                cell = [[WindMillFeedAdImageGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
            if (cell == nil) {
                cell = [[WindMillFeedVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }
        [cell refreshUIWithModel:nativeAd rootViewController:self delegate:self];
        return cell;
    }
    return nil;
}


#pragma mark - WindMillNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)adsManager {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    NSArray<WindMillNativeAd *> *nativeAdList = [adsManager getAllNativeAds];
    [self pbud_insertIntoDataSourceWithArray:nativeAdList];
    [self.tableView reloadData];
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
}

#pragma mark - WindMillNativeAdViewDelegate
- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView *)nativeExpressAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [_nativeExpressViewHeightDict setValue:NSStringFromCGRect(nativeExpressAdView.frame) forKey:@(nativeExpressAdView.nativeAd.hash).stringValue];
    [self.tableView reloadData];
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView *)nativeExpressAdView error:(NSError *)error {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

/**
 广告曝光回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}


/**
 广告点击回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindMillNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView playerStatusChanged:(WindMillMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindMillDislikeWords *> *)filterWords {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    //dislike，需要主动移除广告视图，否则有可能出现点击关闭无反应
    [nativeAdView unregisterDataObject];
    NSUInteger index = [self.dataSource indexOfObject:nativeAdView.nativeAd];
    [self.dataSource removeObject:nativeAdView.nativeAd];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end

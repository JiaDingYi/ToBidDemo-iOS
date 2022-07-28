//
//  WindmillNativeAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindmillNativeAdViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <Masonry/Masonry.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "NativeAdCustomView.h"
#import "WindmillDropdownListView.h"
#import "XLFormSliderValueCell.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"
#import "WindmillNativeTableViewController.h"
#import "WindMillFeedAdViewStyle.h"

static NSString *const kSliderWidth = @"slider-W";
static NSString *const kSliderHeight = @"slider-H";

@interface WindmillNativeAdViewController ()<WindMillNativeAdsManagerDelegate, WindMillNativeAdViewDelegate>
@property (nonatomic, strong) WindMillNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NativeAdCustomView *adView;
@property (nonatomic, strong) UIView *contentView;//广告父容器
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@implementation WindmillNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [self dropdownSection:[WindHelper getNativeAdDropdownDatasource]];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSectionWithTitle:@"设置广告位宽高"];
    section.footerTitle = @"高度设置为0，表示根据宽度自适应高度(仅针对模版渲染)";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSliderWidth rowType:XLFormRowDescriptorTypeSliderValue title:@"广告位宽"];
    row.value = @(UIScreen.mainScreen.bounds.size.width);
    [row.cellConfigAtConfigure setObject:@(UIScreen.mainScreen.bounds.size.width) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(0) forKey:@"slider.minimumValue"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSliderHeight rowType:XLFormRowDescriptorTypeSliderValue title:@"广告位高"];
    row.value = @(0);
    [row.cellConfigAtConfigure setObject:@(UIScreen.mainScreen.bounds.size.height) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(0) forKey:@"slider.minimumValue"];
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"简单接入"];
    row.action.formSelector = @selector(showAdNormal:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"复杂接入(针对TableView)"];
    row.action.formSelector = @selector(showAdTableView:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [WindHelper getNativeCallbackRows];
    [form addFormSection:section];

    self.form = form;
}

- (void)showAdNormal:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getNativeCallbackDatasources]];
    if (!self.nativeAdsManager) {
        WindMillAdRequest *request = [WindMillAdRequest request];
        request.placementId = [self getSelectPlacementId];
        request.userId = @"your user id";
        request.options = @{@"test_key_1":@"test_value"};//s2s激励回传自定义参数，可以为nil
        self.nativeAdsManager = [[WindMillNativeAdsManager alloc] initWithRequest:request];
    }
    self.nativeAdsManager.adSize = CGSizeMake(self.width, self.height);
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:1];
}
- (void)showAdTableView:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getNativeCallbackDatasources]];
    WindmillNativeTableViewController *vc = [[WindmillNativeTableViewController alloc] init];
    vc.width = self.width;
    vc.height = self.height;
    vc.placementId = [self getSelectPlacementId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)renderAdView {
    NSArray<WindMillNativeAd *> *nativeAdList = [self.nativeAdsManager getAllNativeAds];
    if (nativeAdList.count == 0) return;
    WindMillNativeAd *nativeAd = nativeAdList.firstObject;
    self.adView = [NativeAdCustomView new];
    self.adView.delegate = self;
    [self.adView refreshData:nativeAd];
    self.adView.viewController = self;
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.adView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.width);
        make.center.equalTo(self.view);
    }];
    [WindMillFeedAdViewStyle layoutWithModel:nativeAd adView:self.adView];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

#pragma mark - WindMillNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)adsManager {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
    [self renderAdView];
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}


#pragma mark - WindMillNativeAdViewDelegate
- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView *)nativeExpressAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderSuccess error:nil];
    //渲染成功后更新约束
    [WindMillFeedAdViewStyle layoutWithModel:nativeExpressAdView.nativeAd adView:self.adView];
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView *)nativeExpressAdView error:(NSError *)error {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderError error:error];
}

/**
 广告曝光回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}


/**
 广告点击回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewClose error:nil];
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewVisible error:nil];
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindMillNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView playerStatusChanged:(WindMillMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayStateChange error:nil];
}


- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindDislikeWords *> *)filterWords {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDislike error:nil];
    //在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    [nativeAdView removeFromSuperview];
    nativeAdView.delegate = nil;
    nativeAdView = nil;
    self.adView = nil;
    [self.contentView removeFromSuperview];
}

#pragma mark - XLFormDescriptorDelegate
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([formRow.tag isEqualToString:kSliderWidth]) {
        self.width = [formRow.value intValue];
        return;
    }
    if ([formRow.tag isEqualToString:kSliderHeight]) {
        self.height = [formRow.value intValue];
        return;
    }
}

@end

//
//  ToBidMentaNativeManager.m
//  ToBidMentaCustomAdapter
//
//  Created by jdy_office on 2025/7/8.
//

#import "ToBidMentaNativeManager.h"
#import <MentaUnifiedSDK/MentaUnifiedNativeAd.h>
#import <MentaUnifiedSDK/MUNativeConfig.h>
#import <MentaUnifiedSDK/MentaNativeAdDataObject.h>
#import <MentaUnifiedSDK/MentaNativeObject.h>
#import "MentaNativeAdData.h"
#import "MentaNativeAdViewCreator.h"

@interface ToBidMentaNativeManager () <MentaUnifiedNativeAdDelegate>
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomNativeAdapter> adapter;
@property (nonatomic, strong) MentaUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) MentaNativeObject *nativeObj;

@end

@implementation ToBidMentaNativeManager

/// 构造方法
/// 通过bridge回传开屏广告状态
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge
                       adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomNativeAdapterBridge>)bridge;
        _adapter = (id<AWMCustomNativeAdapter>)adapter;
    }
    return self;
}

/// 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId
                    parameter:(AWMParameter *)parameter {
    
}

/// 信息流 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId
                       adSize:(CGSize)size
                    parameter:(AWMParameter *)parameter {
    MUNativeConfig *config = [MUNativeConfig new];
    config.slotId = placementId;
//    config.viewController = self;
    config.tolerateTime = 5;
    self.nativeAd = [[MentaUnifiedNativeAd alloc] initWithConfig:config];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
}

- (BOOL)mediatedAdStatus {
    return [self.nativeAd isAdValid];
}

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    return true;
}

- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

#pragma mark - MentaUnifiedNativeAdDelegate
/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedNativeAd *_Nonnull)nativeAd {
    
}

/**
 广告数据回调

 @param unifiedNativeAdDataObjects 广告数据数组
 */
- (void)menta_nativeAdLoaded:(NSArray<MentaNativeObject *> * _Nullable)unifiedNativeAdDataObjects nativeAd:(MentaUnifiedNativeAd *_Nullable)nativeAd {
    self.nativeObj = unifiedNativeAdDataObjects.firstObject;
    NSLog(@"%@", self.nativeObj.nativeAdView);
    NSString *price = [self.nativeObj.dataObject.price stringValue];
    [self.bridge nativeAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
    mNativeAd.data = [[MentaNativeAdData alloc] initWithAd:self.nativeObj];
    mNativeAd.viewCreator = [[MentaNativeAdViewCreator alloc] initWithNativeAd:self.nativeObj adView:self.nativeObj.nativeAdView];
    mNativeAd.view = self.nativeObj.nativeAdView;
    mNativeAd.originMediatedNativeAd = self.nativeObj.nativeAdView;
    [self.bridge nativeAd:self.adapter didLoadWithNativeAds:@[mNativeAd]];
}

/// 信息流自渲染加载失败
- (void)menta_nativeAd:(MentaUnifiedNativeAd *_Nonnull)nativeAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.bridge nativeAd:self.adapter didLoadFailWithError:error];
}


/**
 广告曝光回调,
 @param nativeAd MentaUnifiedNativeAd 实例,
 @param adView 广告View
 */
- (void)menta_nativeAdViewWillExpose:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    [self.bridge nativeAd:self.adapter didVisibleWithMediatedNativeAd:adView];
}


/**
 广告点击回调,

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdViewDidClick:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nullable)adView {
    [self.bridge nativeAd:self.adapter didClickWithMediatedNativeAd:adView];
}

/**
 广告点击关闭回调 UI的移除和数据的解绑 需要在该回调中进行

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDidClose:(MentaUnifiedNativeAd *_Nonnull)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nullable)adView {
    [self.bridge nativeAd:self.adapter didClose:adView closeReasons:nil];
}


/**
 广告详情页面即将展示回调, 当广告位落地页广告时会触发

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDetailViewWillPresentScreen:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    
}


/**
 广告详情页关闭回调,即落地页关闭回调, 当关闭弹出的落地页时 触发

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDetailViewClosed:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    [self.bridge nativeAd:self.adapter didDismissFullScreenModalWithMediatedNativeAd:nativeAd];
}


/**
 信息流自渲染视频播放结束

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDidPlayFinished:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    
}

/**
 信息流自渲染视频播放失败

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDidPlayFailed:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView error:(NSError *_Nullable)error {
    
}

@end

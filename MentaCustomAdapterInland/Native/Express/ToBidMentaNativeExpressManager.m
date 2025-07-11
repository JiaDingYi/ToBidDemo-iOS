//
//  ToBidMentaNativeExpressManager.m
//  ToBidMentaCustomAdapter
//
//  Created by jdy_office on 2025/7/8.
//

#import "ToBidMentaNativeExpressManager.h"
#import <WindFoundation/WindFoundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import <MentaUnifiedSDK/MUNativeExpressConfig.h>
#import <MentaUnifiedSDK/MentaUnifiedNativeExpressAd.h>
#import <MentaUnifiedSDK/MentaUnifiedNativeExpressAdObject.h>
#import "MentaNativeAdViewCreator.h"

@interface ToBidMentaNativeExpressManager () <MentaUnifiedNativeExpressAdDelegate>
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomNativeAdapter> adapter;
@property (nonatomic, strong) MentaUnifiedNativeExpressAd *nativeExpressAd;
@property (nonatomic, strong) MentaUnifiedNativeExpressAdObject *nativeExpressObj;

@end

@implementation ToBidMentaNativeExpressManager
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
    MUNativeExpressConfig *config = [[MUNativeExpressConfig alloc] init];
    config.adSize = size;
    config.slotId = placementId;
    config.materialFillMode = MentaNativeExpressAdMaterialFillMode_ScaleAspectFill;
//    config.viewController = self;
    self.nativeExpressAd = [[MentaUnifiedNativeExpressAd alloc] initWithConfig:config];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd];
}

- (BOOL)mediatedAdStatus {
    return [self.nativeExpressAd isAdValid];
}

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    return YES;
}

- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

#pragma mark - MentaUnifiedNativeExpressAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd {
    
}

/**
 广告数据回调
 @param unifiedNativeAdDataObjects 广告数据数组
 */
- (void)menta_nativeExpressAdLoaded:(NSArray<MentaUnifiedNativeExpressAdObject *> * _Nullable)unifiedNativeAdDataObjects nativeExpressAd:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd {
    
}


/**
信息流广告加载失败
@param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
@param error 错误
*/
- (void)menta_nativeExpressAd:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.bridge nativeAd:self.adapter didLoadFailWithError:error];
}

/**
 信息流渲染成功
 @param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
 */
- (void)menta_nativeExpressAdViewRenderSuccess:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd nativeExpressAdObject:(MentaUnifiedNativeExpressAdObject *_Nonnull)nativeExpressAdObj {
    self.nativeExpressObj = nativeExpressAdObj;
    NSString *price = self.nativeExpressObj.price.stringValue;
    [self.bridge nativeAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    NSMutableArray *adArray = [[NSMutableArray alloc] init];
    AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
    mNativeAd.originMediatedNativeAd = self.nativeExpressObj.expressView;
    mNativeAd.viewCreator = [[MentaNativeAdViewCreator alloc] initWithExpressAdView:self.nativeExpressObj.expressView];
    mNativeAd.view = self.nativeExpressObj.expressView;;
    [adArray addObject:mNativeAd];
    [self.bridge nativeAd:self.adapter didLoadWithNativeAds:adArray];
    [self.bridge nativeAd:self.adapter renderSuccessWithExpressView:self.nativeExpressObj.expressView];
}

/**
 信息流渲染失败
 @param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
 */
- (void)nativeExpressAdViewRenderFail:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd nativeExpressAdObject:(MentaUnifiedNativeExpressAdObject *_Nonnull)nativeExpressAdObj {
    [self.bridge nativeAd:self.adapter didLoadFailWithError:nil];
}

/**
 广告曝光回调
 @param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
 */
- (void)menta_nativeExpressAdViewWillExpose:(MentaUnifiedNativeExpressAd *_Nullable)nativeExpressAd nativeExpressAdObject:(MentaUnifiedNativeExpressAdObject *_Nonnull)nativeExpressAdObj {
    [self.bridge nativeAd:self.adapter didVisibleWithMediatedNativeAd:self.nativeExpressObj.expressView];
}


/**
 广告点击回调,
 @param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
 */
- (void)menta_nativeExpressAdViewDidClick:(MentaUnifiedNativeExpressAd *_Nullable)nativeExpressAd nativeExpressAdObject:(MentaUnifiedNativeExpressAdObject *_Nonnull)nativeExpressAdObj {
    [self.bridge nativeAd:self.adapter didClickWithMediatedNativeAd:self.nativeExpressObj.expressView];
}

/**
 广告点击关闭回调 UI的移除和数据的解绑 需要在该回调中进行
 @param nativeExpressAd MentaUnifiedNativeExpressAd 实例,
 */
- (void)menta_nativeExpressAdDidClose:(MentaUnifiedNativeExpressAd *_Nonnull)nativeExpressAd nativeExpressAdObject:(MentaUnifiedNativeExpressAdObject *_Nonnull)nativeExpressAdObj {
    [self.bridge nativeAd:self.adapter didClose:self.nativeExpressObj.expressView closeReasons:nil];
}

@end

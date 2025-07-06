//
//  ToBidMentaInterstitalCustomAdapter.m
//  Pods
//
//  Created by jdy_office on 2025/7/4.
//

#import "ToBidMentaInterstitalCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaUnifiedInterstitialAd.h>
#import <MentaUnifiedSDK/MUInterstitialConfig.h>

@interface ToBidMentaInterstitalCustomAdapter () <MentaUnifiedInterstitialAdDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, strong) MentaUnifiedInterstitialAd *interstitial;
@property (nonatomic, strong) NSNumber *ecpm;

@end

@implementation ToBidMentaInterstitalCustomAdapter

- (instancetype)initWithBridge:(id<AWMCustomInterstitialAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}

- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    MUInterstitialConfig *config = [[MUInterstitialConfig alloc] init];
    config.adSize = UIScreen.mainScreen.bounds.size;
    config.slotId = placementId;
//    config.viewController = self;
//    config.countDown = countdown.intValue ? : 0;
    self.interstitial = [[MentaUnifiedInterstitialAd alloc] initWithConfig:config];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}
- (BOOL)mediatedAdStatus {
    return [self.interstitial isAdValid];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.interstitial showAdFromViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

- (void)destory {
    
}

- (void)dealloc {
    
}

#pragma mark - MentaUnifiedInterstitialAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingInterstitialADPolicy:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    
}

/// 插屏广告源数据拉取成功
- (void)menta_interstitialAdDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    
}

/// 插屏广告视频下载成功
- (void)menta_interstitialAdMaterialDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    if (self.ecpm) {
        NSString *price = [self.ecpm stringValue];
        [self.bridge interstitialAd:self didAdServerResponseWithExt:@{
            AWMMediaAdLoadingExtECPM: price
        }];
        [self.bridge interstitialAdDidLoad:self];
    }
}

/// 插屏广告加载失败
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.bridge interstitialAd:self didLoadFailWithError:error ext:nil];
}

/// 插屏广告被点击了
- (void)menta_interstitialAdDidClick:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.bridge interstitialAdDidClick:self];
}

/// 插屏广告关闭了
- (void)menta_interstitialAdDidClose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.bridge interstitialAdDidClose:self];
}

/// 插屏将要展现
- (void)menta_interstitialAdWillVisible:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    
}

/// 插屏广告曝光
- (void)menta_interstitialAdDidExpose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.bridge interstitialAdDidVisible:self];
}

/// 插屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm;
}

@end

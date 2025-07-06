//
//  ToBidMentaBannerCustomAdapter.m
//  Pods
//
//  Created by jdy_office on 2025/7/4.
//

#import "ToBidMentaBannerCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaUnifiedBannerAd.h>
#import <MentaUnifiedSDK/MUBannerConfig.h>

@interface ToBidMentaBannerCustomAdapter () <MentaUnifiedBannerAdDelegate>
@property (nonatomic, weak) id<AWMCustomBannerAdapterBridge> bridge;
@property (nonatomic, strong) MentaUnifiedBannerAd *bannerAd;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) NSNumber *ecpm;

@end

@implementation ToBidMentaBannerCustomAdapter

- (instancetype)initWithBridge:(id<AWMCustomBannerAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    // 模版比例
    // 先确定app展示banner广告位区域的 宽高比, 然后再在menta后台设置 相应或相近比例的模版
//    NSString *sizeStr = [parameter.customInfo objectForKey:@"adSize"];
//    CGSize adSize = CGSizeFromString(sizeStr);
//    if (CGSizeEqualToSize(CGSizeZero, adSize)) {
//        NSError *error = [NSError errorWithDomain:@"strategy" code:-60004 userInfo:@{NSLocalizedDescriptionKey:@"adSize设置错误"}];
//        [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
//        return;
//    }
    MUBannerConfig *config = [[MUBannerConfig alloc] init];
    config.adSize = CGSizeMake(320, 50);
    config.slotId = placementId;
    config.materialFillMode = MentaBannerAdMaterialFillMode_ScaleAspectFill;
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    config.viewController = viewController;
    self.bannerAd = [[MentaUnifiedBannerAd alloc] initWithConfig:config];
    self.bannerAd.delegate = self;
    [self.bannerAd loadAd];
}
- (BOOL)mediatedAdStatus {
    return [self.bannerAd isAdValid];
}

- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

- (void)destory {
    
}

#pragma mark - MentaUnifiedBannerAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingBannerADPolicy:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    
}

/// 横幅(banner)广告源数据拉取成功
- (void)menta_bannerAdDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    
}

/// 横幅(banner)广告物料下载成功
- (void)menta_bannerAdMaterialDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    self.bannerView = [bannerAd fetchBannerView];
    if (self.ecpm) {
        NSString *price = [self.ecpm stringValue];
        [self.bridge bannerAd:self didAdServerResponse:self.bannerView ext:@{
            AWMMediaAdLoadingExtECPM: price
        }];
        [self.bridge bannerAd:self didLoad:self.bannerView];
    }
}

/// 横幅(banner)广告加载失败
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
}

/// 横幅(banner)广告被点击了
- (void)menta_bannerAdDidClick:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.bridge bannerAdDidClick:self bannerView:self.bannerView];
}

/// 横幅(banner)广告关闭了
- (void)menta_bannerAdDidClose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.bridge bannerAdDidClosed:self bannerView:self.bannerView];
}

/// 横幅(banner)将要展现
- (void)menta_bannerAdWillVisible:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
}

/// 横幅(banner)广告曝光
- (void)menta_bannerAdDidExpose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.bridge bannerAdDidBecomeVisible:self bannerView:self.bannerView];
}

/// 横幅(banner)广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm;
}

@end

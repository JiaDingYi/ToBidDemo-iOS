//
//  ToBidMentaSplashCustomAdapter.m
//  Pods
//
//  Created by jdy_office on 2025/7/4.
//

#import "ToBidMentaSplashCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaUnifiedSplashAd.h>
#import <MentaUnifiedSDK/MUSplashConfig.h>

@interface ToBidMentaSplashCustomAdapter () <MentaUnifiedSplashAdDelegate>
@property (nonatomic, weak) id<AWMCustomSplashAdapterBridge> bridge;
@property (nonatomic, strong) MentaUnifiedSplashAd *splashAd;

@end

@implementation ToBidMentaSplashCustomAdapter

/// 构造方法
/// 通过bridge回传广告状态
- (instancetype)initWithBridge:(id<AWMCustomSplashAdapterBridge>)bridge {
    self = [super init];
        if (self) {
            _bridge = bridge;
            WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
        }
        return self;
}

/// 当前加载的广告的状态
- (BOOL)mediatedAdStatus {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    return [self.splashAd isAdValid];
}

/// 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    int fetchDelay = [[parameter.extra objectForKey:AWMAdLoadingParamSPTolerateTimeout] intValue];
    NSValue *sizeValue = [parameter.extra objectForKey:AWMAdLoadingParamSPExpectSize];
    CGSize adSize = [sizeValue CGSizeValue];
    if (adSize.width * adSize.height == 0) {
        CGFloat h = CGRectGetHeight(bottomView.frame);
        adSize = CGSizeMake(supView.frame.size.width, supView.frame.size.height - h);
    }
    if (self.splashAd) {
        self.splashAd.delegate = nil;
        self.splashAd = nil;
    }
    MUSplashConfig *config = [[MUSplashConfig alloc] init];
    config.slotId = placementId;
    config.viewController = self;
    config.tolerateTime = fetchDelay ? : 5;
    if (bottomView) {
        config.bottomView = bottomView;
    }
    config.adSize = adSize;
    self.splashAd = [[MentaUnifiedSplashAd alloc] initWithConfig:config];
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}

/// 展示开屏广告
/// @param window 广告展示窗口
/// @param parameter 广告展示参数
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(AWMParameter *)parameter {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    [self.splashAd showInWindow:window];
}

- (void)destory {
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

#pragma mark - MentaUnifiedSplashAdDelegate
/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
}

/// 开屏广告数据拉取成功
- (void)menta_splashAdDidLoad:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidLoad:self];
}

/// 开屏加载失败
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAd:self didLoadFailWithError:error ext:nil];
}

/// 开屏广告被点击了
- (void)menta_splashAdDidClick:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClick:self];
}

/// 开屏广告关闭了
- (void)menta_splashAdDidClose:(MentaUnifiedSplashAd *_Nonnull)splashAd closeMode:(MentaSplashAdCloseMode)mode {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    if (mode == MentaSplashAdCloseMode_ByClickSkip) {
        [self.bridge splashAdDidClickSkip:self];
    }
    if (mode == MentaSplashAdCloseMode_ByClickAd) {
        [self.bridge splashAdDidClose:self];
    }
}

/// 开屏广告曝光
- (void)menta_splashAdDidExpose:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdWillVisible:self];
}

/// 开屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    WindmillLogDebug(@"Menta", @"%@", NSStringFromSelector(_cmd));
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    if (ecpm) {
        NSString *price = [ecpm stringValue];
        [self.bridge splashAd:self didAdServerResponseWithExt:@{
            AWMMediaAdLoadingExtECPM: price
        }];
    }
}

@end

//
//  ToBidMentaRewardedVideoCustomAdapter.m
//  Pods
//
//  Created by jdy_office on 2025/7/4.
//

#import "ToBidMentaRewardedVideoCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaUnifiedRewardVideoAd.h>
#import <MentaUnifiedSDK/MURewardVideoConfig.h>

@interface ToBidMentaRewardedVideoCustomAdapter () <MentaUnifiedRewardVideoDelegate>
@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapterBridge> bridge;
@property (nonatomic, strong) MentaUnifiedRewardVideoAd *rewardedVideo;
@property (nonatomic, strong) NSNumber *ecpm;

@end

@implementation ToBidMentaRewardedVideoCustomAdapter
/// 构造方法
/// 通过bridge回传广告状态
- (instancetype)initWithBridge:(id<AWMCustomRewardedVideoAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomRewardedVideoAdapterBridge>)bridge;
    }
    return self;
}

/// 当前加载的广告的状态
- (BOOL)mediatedAdStatus {
    return [self.rewardedVideo isAdValid];
}

/// 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    MURewardVideoConfig *config = [[MURewardVideoConfig alloc] init];
    config.adSize = UIScreen.mainScreen.bounds.size;
    config.slotId = placementId;
    config.videoGravity = MentaRewardVideoAdViewGravity_ResizeAspect;
//    config.viewController = [self.bridge viewControllerForPresentingModalView];
    self.rewardedVideo = [[MentaUnifiedRewardVideoAd alloc] initWithConfig:config];
    self.rewardedVideo.delegate = self;
    
    [self.rewardedVideo loadAd];
}

/// 展示广告的方法
/// @param viewController 控制器对象
/// @param parameter 展示广告的参数，由ToBid接入媒体配置
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.rewardedVideo showAdFromRootViewController:viewController];
}

#pragma mark - MentaUnifiedRewardVideoDelegate
/// 广告策略服务加载成功
- (void)menta_didFinishLoadingRewardVideoADPolicy:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    
}

/// 激励视频广告源数据拉取成功
- (void)menta_rewardVideoAdDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    
}

/// 激励视频广告视频下载成功
- (void)menta_rewardVideoAdMaterialDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    if (self.ecpm) {
        NSString *price = [self.ecpm stringValue];
        [self.bridge rewardedVideoAd:self didAdServerResponseWithExt:@{
            AWMMediaAdLoadingExtECPM: price
        }];
        [self.bridge rewardedVideoAdDidLoad:self];
    }
}

/// 激励视频加载失败
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.bridge rewardedVideoAd:self didLoadFailWithError:error ext:nil];
}

/// 激励视频广告被点击了
- (void)menta_rewardVideoAdDidClick:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.bridge rewardedVideoAdDidClick:self];
}

/// 激励视频广告关闭了
- (void)menta_rewardVideoAdDidClose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd closeMode:(MentaRewardVideoAdCloseMode)mode {
    if (mode == MentaRewardVideoAdCloseMode_ByClickSkip) {
        [self.bridge rewardedVideoAdDidClickSkip:self];
    } else {
        [self.bridge rewardedVideoAdDidClose:self];
    }
}

/// 激励视频将要展现
- (void)menta_rewardVideoAdWillVisible:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    
}

/// 激励视频广告曝光
- (void)menta_rewardVideoAdDidExpose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.bridge rewardedVideoAdDidVisible:self];
}

/// 激励视频广告播放达到激励条件回调
- (void)menta_rewardVideoAdDidRewardEffective:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    WindMillRewardInfo *info = [[WindMillRewardInfo alloc] init];
    info.isCompeltedView = YES;
    [self.bridge rewardedVideoAd:self didRewardSuccessWithInfo:info];
}

/// 激励视频广告播放完成回调
- (void)menta_rewardVideoAdDidPlayFinish:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:nil];
}

/// 激励视频广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm;
}

@end

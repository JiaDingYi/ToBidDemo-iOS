//
//  XXCSJFullscreenVideoAd.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/24.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJFullscreenVideoAd.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface XXCSJFullscreenVideoAd ()<BUFullscreenVideoAdDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomInterstitialAdapter> adapter;
@property (nonatomic, strong) BUFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJFullscreenVideoAd
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomInterstitialAdapterBridge>)bridge;
        _adapter = (id<AWMCustomInterstitialAdapter>)adapter;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId
                    parameter:(AWMParameter *)parameter {
    self.fullscreenVideoAd = [[BUFullscreenVideoAd alloc] initWithSlotID:placementId];
    self.fullscreenVideoAd.delegate = self;
    [self.fullscreenVideoAd loadAdData];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.fullscreenVideoAd showAdFromRootViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.fullscreenVideoAd setPrice:@(result.winnerPrice)];
        [self.fullscreenVideoAd win:@(result.winnerPrice)];
        return;
    }
    [self.fullscreenVideoAd loss:nil lossReason:@"102" winBidder:nil];
}
#pragma mark - BUFullscreenVideoAdDelegate
- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [[fullscreenVideoAd.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge interstitialAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = YES;
    [self.bridge interstitialAdDidLoad:self.adapter];
}
- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAdDidVisible:self.adapter];
}
- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClick:self.adapter];
}
- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClose:self.adapter];
}
- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAd:self.adapter didPlayFinishWithError:error];
}
- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClickSkip:self.adapter];
}
@end

//
//  XXCSJExpressInterstitialAd.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/24.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJExpressInterstitialAd.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface XXCSJExpressInterstitialAd ()<BUNativeExpresInterstitialAdDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomInterstitialAdapter> adapter;
@property (nonatomic, strong) BUNativeExpressInterstitialAd *expressInterstitialAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJExpressInterstitialAd
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
    NSString *ratio = [parameter.customInfo objectForKey:@"ratio"];
    NSArray *ratioArray = [ratio componentsSeparatedByString:@":"];
    if (ratioArray.count != 2) {
        NSError *error = [NSError errorWithDomain:@"CSJ" code:-60004 userInfo:@{NSLocalizedDescriptionKey:@"插屏比例设置错误"}];
        [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
        return;
    }
    NSString *x = ratioArray.firstObject;
    NSString *y = ratioArray.lastObject;
    if (x.integerValue <=0 || y.integerValue <= 0) {
        NSError *error = [NSError errorWithDomain:@"CSJ" code:-60004 userInfo:@{NSLocalizedDescriptionKey:@"插屏比例设置错误"}];
        [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
        return;
    }
    CGFloat w = MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) - 40;
    CGFloat h = 1.0 * w * y.integerValue / x.integerValue;
    CGSize adSize = CGSizeMake(w, h);
    self.expressInterstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:placementId adSize:adSize];
    self.expressInterstitialAd.delegate = self;
    [self.expressInterstitialAd loadAdData];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.expressInterstitialAd showAdFromRootViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.expressInterstitialAd setPrice:@(result.winnerPrice)];
        [self.expressInterstitialAd win:@(result.winnerPrice)];
        return;
    }
    [self.expressInterstitialAd loss:nil lossReason:@"102" winBidder:nil];
}
#pragma mark - BUNativeExpresInterstitialAdDelegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [[interstitialAd.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge interstitialAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError * __nullable)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = YES;
    [self.bridge interstitialAdDidLoad:self.adapter];
}
- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError * __nullable)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAdDidVisible:self.adapter];
}
- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClick:self.adapter];
}
- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClose:self.adapter];
}
@end

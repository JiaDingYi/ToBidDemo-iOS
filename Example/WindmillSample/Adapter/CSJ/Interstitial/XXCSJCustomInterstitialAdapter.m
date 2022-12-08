//
//  XXCSJCustomInterstitialAdapter.m
//  WindMillSDK
//
//  Created by Codi on 2022/10/24.

#import "XXCSJCustomInterstitialAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import "XXCSJExpressFullscreenVideoAd.h"
#import "XXCSJExpressInterstitialAd.h"
#import "XXCSJFullscreenVideoAd.h"

@interface XXCSJCustomInterstitialAdapter()
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, strong) id<XXCSJAdProtocol> ad;
@end

@implementation XXCSJCustomInterstitialAdapter
- (instancetype)initWithBridge:(id<AWMCustomInterstitialAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter { 
    self.ad = [self adWithParameter:parameter];
    [self.ad loadAdWithPlacementId:placementId parameter:parameter];
}
- (BOOL)mediatedAdStatus { 
    return [self.ad mediatedAdStatus];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    return [self.ad showAdFromRootViewController:viewController parameter:parameter];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    [self.ad didReceiveBidResult:result];
}
- (id<XXCSJAdProtocol>)adWithParameter:(AWMParameter *)parameter {
    int subType = [[parameter.customInfo objectForKey:@"subType"] intValue];
    if (subType == 2) {
        return [[XXCSJExpressFullscreenVideoAd alloc] initWithBridge:self.bridge adapter:self];
    }else if (subType == 0) {
        return [[XXCSJExpressInterstitialAd alloc] initWithBridge:self.bridge adapter:self];
    }else if (subType == 1) {
        int templateType = [[parameter.customInfo objectForKey:@"templateType"] intValue];
        if (templateType == 1) {
            return [[XXCSJFullscreenVideoAd alloc] initWithBridge:self.bridge adapter:self];
        }else {
            return [[XXCSJExpressFullscreenVideoAd alloc] initWithBridge:self.bridge adapter:self];
        }
    }
    return nil;
}
- (void)destory {
    self.ad = nil;
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

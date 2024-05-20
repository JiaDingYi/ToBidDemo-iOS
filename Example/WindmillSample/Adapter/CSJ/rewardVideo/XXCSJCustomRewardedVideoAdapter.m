//
//  XXCSJCustomRewardedVideoAdapter.m
//  WindMillSDK
//
//  Created by Codi on 2022/10/24.
//

#import "XXCSJCustomRewardedVideoAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import "XXCSJExpressRewardVideoAd.h"

@interface XXCSJCustomRewardedVideoAdapter ()
@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapterBridge> bridge;
@property (nonatomic, strong) id<XXCSJAdProtocol> ad;
@end

@implementation XXCSJCustomRewardedVideoAdapter
- (instancetype)initWithBridge:(id<AWMCustomRewardedVideoAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return [self.ad mediatedAdStatus];
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    int templateType = [[parameter.customInfo objectForKey:@"templateType"] intValue];
    self.ad = [[XXCSJExpressRewardVideoAd alloc] initWithBridge:self.bridge adapter:self];
    [self.ad loadAdWithPlacementId:placementId parameter:parameter];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    return [self.ad showAdFromRootViewController:viewController parameter:parameter];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    [self.ad didReceiveBidResult:result];
}
- (void)destory {
    self.ad = nil;
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

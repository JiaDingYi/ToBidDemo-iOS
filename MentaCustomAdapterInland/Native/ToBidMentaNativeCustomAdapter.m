//
//  ToBidMentaNativeCustomAdapter.m
//  Pods
//
//  Created by jdy_office on 2025/7/4.
//

#import "ToBidMentaNativeCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import "ToBidMentaNativeManager.h"
#import "ToBidMentaNativeExpressManager.h"
#import "ToBidMentaAdProtocol.h"

@interface ToBidMentaNativeCustomAdapter () 
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, strong) id<ToBidMentaAdProtocol> nativeAdManager;

@end

@implementation ToBidMentaNativeCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomNativeAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}

- (void)loadAdWithPlacementId:(NSString *)placementId adSize:(CGSize)size parameter:(AWMParameter *)parameter {
    int templateType = [[parameter.customInfo objectForKey:@"isExpress"] intValue];
    if (templateType == 1) {
        self.nativeAdManager = [[ToBidMentaNativeExpressManager alloc] initWithBridge:self.bridge adapter:self];
    }else {
        self.nativeAdManager = [[ToBidMentaNativeManager alloc] initWithBridge:self.bridge adapter:self];
    }
    [self.nativeAdManager loadAdWithPlacementId:placementId adSize:size parameter:parameter];
}

- (BOOL)mediatedAdStatus {
    return [self.nativeAdManager mediatedAdStatus];
}

- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
}

- (void)dealloc {
}

@end

//
//  XXCSJNativeAdData.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "MentaNativeAdData.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaNativeAdMaterialObject.h>

@interface MentaNativeAdData ()
@property (nonatomic, weak) MentaNativeObject *ad;
@end

@implementation MentaNativeAdData

@synthesize adMode = _adMode;
@synthesize callToAction = _callToAction;
@synthesize desc = _desc;
@synthesize iconUrl = _iconUrl;
@synthesize rating = _rating;
@synthesize title = _title;

- (instancetype)initWithAd:(MentaNativeObject *)ad {
    self = [super init];
    if (self) {
        _ad = ad;
    }
    return self;
}

- (NSString *)title {
    return self.ad.dataObject.title;
}

- (NSString *)desc {
    return self.ad.dataObject.desc;
}

- (NSString *)iconUrl {
    return self.ad.dataObject.iconUrl;
}

- (NSString *)callToAction {
    return @"查看详情";
}

- (double)rating {
    return 0;
}

- (AWMMediatedNativeAdMode)adMode {
    if (_adMode > 0) return _adMode;
    if (self.ad.dataObject.isVideo) {
        _adMode = AWMMediatedNativeAdModeVideo;
    } else {
        _adMode = AWMMediatedNativeAdModeLargeImage;
    }
    return _adMode;
}

- (NSArray *)imageUrlList {
    NSString *url = self.ad.dataObject.materialList.firstObject.materialUrl;
    if (url) {
        return @[url];
    }
    return @[];
}

- (AWMNativeAdSlotAdType)adType {
    return AWMNativeAdSlotAdTypeFeed;
}

- (void)dealloc {
    
}
@end

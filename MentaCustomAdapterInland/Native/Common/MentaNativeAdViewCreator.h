//
//  XXCSJNativeAdViewCreator.h
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import <MentaUnifiedSDK/MentaNativeAdDataObject.h>
#import <MentaUnifiedSDK/MentaNativeObject.h>

@interface MentaNativeAdViewCreator : NSObject <AWMMediatedNativeAdViewCreator>

- (instancetype)initWithNativeAd:(MentaNativeObject *)nativeAd
                          adView:(UIView<MentaNativeAdViewProtocol> *)adView;

- (instancetype)initWithExpressAdView:(UIView *)adView;

@end

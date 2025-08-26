//
//  XXCSJNativeAdData.h
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import <MentaUnifiedSDK/MentaNativeAdDataObject.h>
#import <MentaUnifiedSDK/MentaNativeObject.h>

@interface MentaNativeAdData : NSObject <AWMMediatedNativeAdData>

@property (nonatomic, assign) NSInteger networkId;

- (instancetype)initWithAd:(MentaNativeObject *)ad;

@end

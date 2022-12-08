//
//  CustomCSJInitAdapter.m
//  WindMillDemo
//
//  Created by Codi on 2022/11/10.
//

#import "XXCustomConfigAdapter.h"
#import <BUAdSDK/BUAdSDK.h>

@interface XXCustomConfigAdapter ()
@property (nonatomic, weak) id<AWMCustomConfigAdapterBridge> bridge;
@end

@implementation XXCustomConfigAdapter
- (instancetype)initWithBridge:(id<AWMCustomConfigAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (AWMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return AWMCustomAdapterVersion1_0;
}
- (NSString *)adapterVersion {
    return @"1.0.0";
}
- (NSString *)networkSdkVersion {
    return [BUAdSDKManager SDKVersion];
}
- (void)initializeAdapterWithConfiguration:(AWMSdkInitConfig *)initConfig {
    NSString *appId = [initConfig.extra objectForKey:@"appID"];
    [BUAdSDKManager setTerritory:BUAdSDKTerritory_CN];
    [BUAdSDKManager setAppID:appId];
    [self.bridge initializeAdapterSuccess:self];
}
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    WindMillConsentStatus consentStatus = [WindMillAds getUserGDPRConsentStatus];
    if (consentStatus == WindMillConsentDenied) {
        [BUAdSDKManager setGDPR:1];
    }else if (consentStatus == WindMillConsentAccepted) {
        [BUAdSDKManager setGDPR:0];
    }
    WindMillAgeRestrictedStatus ageRestrictedStatus = [WindMillAds getAgeRestrictedStatus];
    if (ageRestrictedStatus == WindMillAgeRestrictedStatusYES) {
        [BUAdSDKManager setCoppa:1];
    }else {
        [BUAdSDKManager setCoppa:0];
    }
    WindMillPersonalizedAdvertisingState personalizedAdvertisingState = [WindMillAds getPersonalizedAdvertisingState];
    if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOn) {
        [BUAdSDKManager setUserExtData:@"[{\"name\":\"personal_ads_type\",\"value\":\"1\"}]"];
    }else if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOff) {
        [BUAdSDKManager setUserExtData:@"[{\"name\":\"personal_ads_type\",\"value\":\"0\"}]"];
    }
}
@end

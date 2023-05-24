//
//  WindmillChannelVersionViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindmillChannelVersionViewController.h"
#import <WindSDK/WindSDK.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UnityAds/UnityAds.h>
#import <VungleSDK/VungleSDK.h>
#import <MTGSDK/MTGSDK.h>
#import "GDTSDKConfig.h"
#import <KSAdSDK/KSAdSDK.h>
#import <KlevinAdSDK/KlevinAdSDK.h>
#import <BeiZiSDK/BeiZiSDK.h>
#import <BaiduMobAdSDK/BaiduMobAdCommonConfig.h>


@interface WindmillChannelVersionViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation WindmillChannelVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeData];
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    section.title = @"SDK Version";
    for (NSDictionary *dict in self.dataArray) {
        NSString *title = dict[@"title"];
        NSString *version = dict[@"version"];
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"info" rowType:XLFormRowDescriptorTypeInfo title:title];
        row.value = version;
        [section addFormRow:row];
    }

    self.form = form;
}

- (void)initializeData {
    _dataArray = @[
        @{@"title": @"Sigmob", @"version": [WindAds sdkVersion]},
        @{@"title": @"穿山甲", @"version": [BUAdSDKManager SDKVersion]},
        @{@"title": @"腾讯优量汇", @"version": [GDTSDKConfig sdkVersion]},
        @{@"title": @"快手", @"version": [KSAdSDKManager SDKVersion]},
        @{@"title": @"Admob", @"version": [[GADMobileAds sharedInstance] sdkVersion]},
        @{@"title": @"Mintegral", @"version": MTGSDKVersion},
        @{@"title": @"UnityAds", @"version": [UnityAds getVersion]},
        @{@"title": @"Vungle", @"version": VungleSDKVersion},
        @{@"title": @"百度联盟", @"version": SDK_VERSION_IN_MSSP},
        @{@"title": @"游可赢", @"version": [KlevinAdSDK sdkVersion]},
        @{@"title": @"AdScope", @"version": [BeiZiSDKManager sdkVersion]},
    ];
}


- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    
}

@end

//
//  ViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "ViewController.h"
#import "XLFormRowLeftIconAndTitleCell.h"
#import <WindMillSDK/WindMillSDK.h>
#import "WindmillRewardVideoAdViewController.h"
#import "WindmillIntersititialAdViewController.h"
#import "WindmillNativeAdViewController.h"
#import "WindmillSplashAdViewController.h"
#import "WindmillBannerAdViewController.h"
#import "WindmillChannelVersionViewController.h"
#import "WindmillToolViewController.h"
#import "AWMNativeListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Windmill Demo";
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@"HomePage"];

    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"SplashAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"开屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.formSelector = @selector(splashAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"BannerAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"横幅广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.formSelector = @selector(bannerAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"RewardVideoAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"激励视频"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.formSelector = @selector(rewardVideoAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"InterstitialAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"插屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.formSelector = @selector(interstitialAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"原生广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.formSelector = @selector(nativeAdAction:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Channels" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"渠道版本"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_setting"] forKey:@"image"];
    row.action.formSelector = @selector(channelsAction:);
    [section addFormRow:row];
    
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Tools" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"工具"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_setting"] forKey:@"image"];
    row.action.formSelector = @selector(toolsAction:);
    [section addFormRow:row];
    
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"info" rowType:XLFormRowDescriptorTypeInfo title:@"Version"];
    row.value = [WindMillAds sdkVersion];
    [section addFormRow:row];
    
    self.form = form;
}


#pragma mark -Actions
- (void)splashAdAction:(XLFormRowDescriptor *)sender {
    WindmillSplashAdViewController *vc = [WindmillSplashAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)bannerAdAction:(XLFormRowDescriptor *)sender {
    WindmillBannerAdViewController *vc = [WindmillBannerAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rewardVideoAdAction:(XLFormRowDescriptor *)sender {
    WindmillRewardVideoAdViewController *vc = [WindmillRewardVideoAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)interstitialAdAction:(XLFormRowDescriptor *)sender {
    WindmillIntersititialAdViewController *vc = [WindmillIntersititialAdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)nativeAdAction:(XLFormRowDescriptor *)sender {
    AWMNativeListViewController *vc = [AWMNativeListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toolsAction:(XLFormRowDescriptor *)sender {
    WindmillToolViewController *vc = [WindmillToolViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)channelsAction:(XLFormRowDescriptor *)sender {
    WindmillChannelVersionViewController *vc = [WindmillChannelVersionViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

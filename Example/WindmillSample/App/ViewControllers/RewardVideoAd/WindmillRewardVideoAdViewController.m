//
//  WindmillRewardVideoAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindmillRewardVideoAdViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"

@interface WindmillRewardVideoAdViewController ()<WindMillRewardVideoAdDelegate>
@property (nonatomic, strong) WindMillRewardVideoAd *rewardVideoAd;
@end

@implementation WindmillRewardVideoAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
}


- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getRewardVideoCallbackDatasources]];
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.userId = @"your user id";
    request.placementId = [self getSelectPlacementId];
    request.options = @{@"test_key":@"test_value"};
    if (!self.rewardVideoAd) {
        self.rewardVideoAd = [[WindMillRewardVideoAd alloc] initWithRequest:request];
    }
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAdData];
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.rewardVideoAd.isAdReady) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionBottom];
        return;
    }
    //当多场景使用同一个广告位是，可以通过WindMillAdSceneId来区分某个场景的广告播放数据
    //不需要统计可以设置为options=nil
    [self.rewardVideoAd showAdFromRootViewController:self options:@{
        WindMillAdSceneDesc: @"测试场景",
        WindMillAdSceneId: @"1"
    }];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [self dropdownSection:[WindHelper getRewardAdDropdownDatasource]];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"load广告"];
    row.action.formSelector = @selector(loadAd:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"观看广告"];
    row.action.formSelector = @selector(showAd:);
    [section addFormRow:row];
    
    // Section
    section = [WindHelper getRewardVideoCallbackRows];
    [form addFormSection:section];

    self.form = form;
}


#pragma mark - WindMillRewardVideoAdDelegate

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}

- (void)rewardVideoAdWillVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}

- (void)rewardVideoAdDidVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)rewardVideoAdDidClick:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)rewardVideoAdDidClickSkip:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd reward:(WindMillRewardInfo *)reward {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidReward error:nil];
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), rewardVideoAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayFinish error:error];
}



- (void)dealloc {
    self.rewardVideoAd.delegate = nil;
    self.rewardVideoAd = nil;
}

@end


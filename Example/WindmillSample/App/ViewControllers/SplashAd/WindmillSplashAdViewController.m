//
//  WindmillSplashAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindmillSplashAdViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <MJExtension/MJExtension.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"
#import <UIView+Toast.h>

@interface WindmillSplashAdViewController ()<WindMillSplashAdDelegate>
@property (nonatomic, strong) WindMillSplashAd *splashAd;

@end

@implementation WindmillSplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [self dropdownSection:[WindHelper getSplashAdDropdownDatasource]];
    [form addFormSection:section];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"klogo" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"是否展示品牌区域"];
    row.selectorOptions = @[@"展示", @"不展示"];
    row.value = @"展示";
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"加载自动展示模式";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAdAndShow" rowType:XLFormRowDescriptorTypeButton title:@"loadAdAndShow"];
    row.action.formSelector = @selector(loadAdAndShow:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    section.title = @"预加载模式";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"loadAdData"];
    row.action.formSelector = @selector(loadAd:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"showAd"];
    row.action.formSelector = @selector(showAd:);
    [section addFormRow:row];
    
    //********************************************************************************
    section = [WindHelper getSplashCallbackRows];
    [form addFormSection:section];

    self.form = form;
}


- (BOOL)hasLogo {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"klogo"];
    return [row.value isEqualToString:@"展示"];
}

#pragma mark -Actions
- (void)loadAdAndShow:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getSplashCallbackDatasources]];
    if (!self.splashAd) {
        WindMillAdRequest *request = [WindMillAdRequest request];
        request.placementId = [self getSelectPlacementId];
        request.userId = @"your user id";
        self.splashAd = [[WindMillSplashAd alloc] initWithRequest:request extra:nil];
        self.splashAd.delegate = self;
        self.splashAd.rootViewController = self;
    }
    if ([self hasLogo]) {
        [self.splashAd loadADAndShowWithTitle:@"对应的标题" description:@"对应的描述信息"];
    }else {
        [self.splashAd loadAdAndShow];
    }
}
- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getSplashCallbackDatasources]];
    CGFloat logoHeight = 0;
    if ([self hasLogo]) {
        logoHeight = 150;
    }
    CGSize adSize = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height-logoHeight);
    NSDictionary *extra = @{kWindMillSplashExtraAdSize: NSStringFromCGSize(adSize)};
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = [self getSelectPlacementId];
    request.userId = @"your user id";
    self.splashAd = [[WindMillSplashAd alloc] initWithRequest:request extra:extra];
    self.splashAd.delegate = self;
    self.splashAd.rootViewController = self;
    [self.splashAd loadAd];
    
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.splashAd.isAdReady) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionBottom];
        return;
    }
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        [self.splashAd showAdInWindow:self.view.window withBottomView:logoView];
    }else {
        [self.splashAd showAdInWindow:self.view.window withBottomView:nil];
    }
}


- (UIView *)getLogoView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat w = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    bottomView.frame = CGRectMake(0, 0, w, 150);
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = bottomView.bounds;
    imgView.image = [UIImage imageNamed:icon];
    [bottomView addSubview:imgView];
    return bottomView;
}


#pragma mark - WindMillSplashAdDelegate
- (void)onSplashAdDidLoad:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)onSplashAdLoadFail:(WindMillSplashAd *)splashAd error:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    DDLogError(@"%@", error);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
    self.splashAd.delegate = nil;
    self.splashAd = nil;
    
}

- (void)onSplashAdSuccessPresentScreen:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)onSplashAdFailToPresent:(WindMillSplashAd *)splashAd withError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    DDLogError(@"%@", error);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderError error:nil];
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

- (void)onSplashAdClicked:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)onSplashAdSkiped:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)onSplashAdWillClosed:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillClose error:nil];
}

- (void)onSplashAdClosed:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
    //如果配置了开屏点睛时，在close时释放WindMillSplashAd，
    //则onSplashZoomOutViewAdDidClick和onSplashZoomOutViewAdDidClose回调无法正常回调
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

- (void)onSplashZoomOutViewAdDidClick:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self updateFromRowDisableWithTag:kZoomOutViewDidClick error:nil];
}

- (void)onSplashZoomOutViewAdDidClose:(WindMillSplashAd *)splashAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), splashAd.placementId);
    [self updateFromRowDisableWithTag:kZoomOutViewDidClose error:nil];
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

@end

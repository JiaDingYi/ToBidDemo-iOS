//
//  XXCSJNativeAdViewCreator.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "MentaNativeAdViewCreator.h"
#import <WindFoundation/WindFoundation.h>
#import <MentaUnifiedSDK/MentaNativeAdMaterialObject.h>

@interface MentaNativeAdViewCreator()
@property (nonatomic, strong) MentaNativeObject *nativeAd;
@property (nonatomic, strong) UIView<MentaNativeAdViewProtocol> *nativeView;
@property (nonatomic, strong) UIView *expressAdView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation MentaNativeAdViewCreator

@synthesize adLogoView = _adLogoView;
@synthesize dislikeBtn = _dislikeBtn;
@synthesize imageView = _imageView;
@synthesize imageViewArray = _imageViewArray;
@synthesize mediaView = _mediaView;


- (instancetype)initWithNativeAd:(MentaNativeObject *)nativeAd
                          adView:(UIView<MentaNativeAdViewProtocol> *)adView {
    self = [super init];
    if (self) {
        _nativeView = adView;
        _nativeAd = nativeAd;
    }
    return self;
}

- (instancetype)initWithExpressAdView:(UIView *)adView {
    self = [super init];
    if (self) {
        _expressAdView = adView;
    }
    return self;
}

- (void)setRootViewController:(UIViewController *)viewController {
}

- (void)registerContainer:(UIView *)containerView withClickableViews:(NSArray<UIView *> *)clickableViews {
    [self.nativeAd registerClickableViews:clickableViews closeableViews:nil];
}

- (void)refreshData {
    
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _image = placeholderImage;
}

#pragma mark - Getter
- (UIView *)adLogoView {
    if (!_adLogoView) {
        UIImage *logo = _nativeAd.dataObject.adIcon;
        _adLogoView = [[UIImageView alloc] initWithImage:logo];
        _adLogoView.frame = CGRectMake(0, 0, logo.size.width, logo.size.height);
    }
    return _adLogoView;
}
- (UIButton *)dislikeBtn {
    return nil;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        NSArray<MentaNativeAdMaterialObject *>* imageAry = self.nativeAd.dataObject.materialList;
        _imageView = [[UIImageView alloc] init];
        if(imageAry.count > 0) {
            NSURL *imgURL = [NSURL URLWithString:imageAry.firstObject.materialUrl];
            [_imageView sm_setImageWithURL:imgURL placeholderImage:self.image];
        }
    }
    return _imageView;
}

- (NSArray<UIImageView *> *)imageViewArray {
    return nil;
}

- (UIView *)mediaView {
    return self.nativeView.mentaMediaView;
}

- (void)setMediaViewMute:(BOOL)isMute {
    [self.nativeView.mentaMediaView muteEnable:isMute];
}

/// 开始播放原生自渲染视频广告,目前支持gdt,baidu,csj
- (void)play {
    [self.nativeView.mentaMediaView play];
}

/// 继续播放原生自渲染视频广告,目前支持gdt,baidu
- (void)resume {
    
}

/// 暂停播放原生自渲染视频广告,目前支持gdt,baidu,csj
- (void)pause {
    [self.nativeView.mentaMediaView pause];
}

/// 销毁播放器原生自渲染视频广告,目前支持gdt,baidu
- (void)stop {
    [self.nativeView.mentaMediaView stop];
}

- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

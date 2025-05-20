//
//  XXCSJNativeAdViewCreator.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJNativeAdViewCreator.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface XXCSJNativeAdViewCreator()
@property (nonatomic, strong) BUNativeAdRelatedView *adView;
@property (nonatomic, strong) BUNativeExpressAdView *expressAdView;
@property (nonatomic, strong) BUNativeAd *nativeAd;
@property (nonatomic, strong) UIImage *image;
@end

@implementation XXCSJNativeAdViewCreator

@synthesize adLogoView = _adLogoView;
@synthesize dislikeBtn = _dislikeBtn;
@synthesize imageView = _imageView;
@synthesize imageViewArray = _imageViewArray;
@synthesize mediaView = _mediaView;


- (instancetype)initWithNativeAd:(BUNativeAd *)nativeAd
                          adView:(BUNativeAdRelatedView *)adView {
    self = [super init];
    if (self) {
        _adView = adView;
        _nativeAd = nativeAd;
    }
    return self;
}
- (instancetype)initWithExpressAdView:(BUNativeExpressAdView *)adView {
    self = [super init];
    if (self) {
        _expressAdView = adView;
    }
    return self;
}
- (void)setRootViewController:(UIViewController *)viewController {
    self.nativeAd.rootViewController = viewController;
    self.expressAdView.rootViewController = viewController;
}
- (void)registerContainer:(UIView *)containerView withClickableViews:(NSArray<UIView *> *)clickableViews {
    [self.nativeAd registerContainer:containerView withClickableViews:clickableViews];
}
- (void)refreshData {
    if (self.expressAdView) {
        [self.expressAdView render];
    }else if (self.adView) {
        [self.adView refreshData:self.nativeAd];
    }
}
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _image = placeholderImage;
}
#pragma mark - Getter
- (UIView *)adLogoView {
    return self.adView.logoADImageView;
}
- (UIButton *)dislikeBtn {
    return self.adView.dislikeButton;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        NSArray *imageAry = self.nativeAd.data.imageAry;
        _imageView = [[UIImageView alloc] init];
        if(imageAry.count > 0) {
            BUImage *image = imageAry.firstObject;
            NSURL *imgURL = [NSURL URLWithString:image.imageURL];
            [_imageView sm_setImageWithURL:imgURL placeholderImage:self.image];
        }
    }
    return _imageView;
}
- (NSArray<UIImageView *> *)imageViewArray {
    if (self.nativeAd.data.imageMode != BUFeedADModeGroupImage) return nil;
    if (!_imageViewArray) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [self.nativeAd.data.imageAry enumerateObjectsUsingBlock:^(BUImage *image, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSURL *imgURL = [NSURL URLWithString:image.imageURL];
            [imageView sm_setImageWithURL:imgURL placeholderImage:self.image];
            [arr addObject:imageView];
        }];
        _imageViewArray = arr;
    }
    return _imageViewArray;
}
- (UIView *)mediaView {
    return self.adView.mediaAdView;
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

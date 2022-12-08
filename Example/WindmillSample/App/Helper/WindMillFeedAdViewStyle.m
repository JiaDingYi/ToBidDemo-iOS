//
//  FeedAdViewStyle.m
//  WindDemo
//
//  Created by Codi on 2021/8/23.
//

#import "WindMillFeedAdViewStyle.h"
#import "FeedStyleHelper.h"
#import <Masonry.h>
#import <SDWebImage.h>
#import "NativeAdCustomView.h"
#import <WindMillSDK/WindMillSDK.h>

static CGFloat const margin = 15;
//static CGSize const logoSize = {15, 15};
static UIEdgeInsets const padding = {10, 15, 10, 15};

@implementation WindMillFeedAdViewStyle

+ (void)layoutWithModel:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
        [self renderAdWithGroupImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
        [self renderAdWithLargeImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
        [self renderAdWithVideo:nativeAd adView:adView];
    }else if(nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        [self renderAdWithNativeExpressAd:nativeAd adView:adView];
    }
}

+ (CGFloat)cellHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
        return [self cellGroupImageHeightWithModel:nativeAd width:width];
    }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
        return [self cellLargeImageHeightWithModel:nativeAd width:width];
    }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
        return [self cellVideoHeightWithModel:nativeAd width:width];
    }else if(nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        return [self cellNativeExpressHeightWithModel:nativeAd width:width];
    }
    return 0;
}

+ (CGFloat)cellGroupImageHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat contentWidth = (width - 2 * margin);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    return titleSize.height + descSize.height + 200;
}
+ (CGFloat)cellLargeImageHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    CGSize iconSize = CGSizeMake(60, 60);
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    return imageHeight + descSize.height + iconSize.height + 80;
}
+ (CGFloat)cellVideoHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindMillFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat contentWidth = (width - 2 * margin);
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    return contentWidth + descSize.height + 140;
}

+ (CGFloat)cellNativeExpressHeightWithModel:(WindMillNativeAd *)model width:(CGFloat)width {
    return 0;
}

+ (void)renderAdWithLargeImg:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    [adView.mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.mainImageView.superview).offset(padding.top);
        make.left.equalTo(adView.mainImageView.superview).offset(padding.left);
        make.right.equalTo(adView.mainImageView.superview).offset(-padding.right);
        make.height.mas_equalTo(imageHeight);
    }];
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    
    [adView.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
        make.top.equalTo(adView.mainImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.iconImageView.superview).offset(padding.left);
    }];

    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@30);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIView *logoView = (UIView *)adView.logoView;
    [logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logoView.superview).offset(-10);
        make.left.equalTo(logoView.superview).offset(10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(imageHeight + descSize.height + iconSize.height + 80);
    }];
    
    [adView setClickableViews:@[adView.CTAButton, adView.mainImageView, adView.iconImageView]];
}

+ (void)renderAdWithVideo:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{

    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindMillFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    adView.iconImageView.frame = CGRectMake(padding.left, y, iconSize.width, iconSize.height);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@30);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.left.equalTo(adView.mediaView.superview).offset(padding.left);
        make.right.equalTo(adView.mediaView.superview).offset(-padding.right);
        make.height.equalTo(adView.mediaView.mas_width).multipliedBy(videoRate);
    }];
    
    UIView *logogView = (UIView *)adView.logoView;
    [logogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logogView.superview).offset(-10);
        make.left.equalTo(logogView.superview).offset(10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [adView setClickableViews:@[adView.CTAButton, adView.mediaView]];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(adView.mediaView.mas_height).offset(descSize.height + 140);
    }];
}

+ (void)renderAdWithGroupImg:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    adView.CTAButton.frame = CGRectMake(width-100-padding.right, y, 100, 30);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    adView.titleLabel.frame = CGRectMake(padding.left, y , contentWidth - 110, titleSize.height);
    
    y += titleSize.height;
    y += 10;
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    adView.descLabel.frame = CGRectMake(padding.left, y, contentWidth, descSize.height);
    
    NSArray *arr = adView.imageViewList;
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:padding.left tailSpacing:padding.right];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [adView.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView.logoView.superview).offset(-10);
        make.left.equalTo(adView.logoView.superview).offset(10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(20));
    }];
    
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(titleSize.height + descSize.height + 200);
    }];
    
    [adView setClickableViews:@[adView.CTAButton]];
}

+ (void)renderAdWithNativeExpressAd:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(adView.frame.size.width);
        make.height.mas_equalTo(adView.frame.size.height);
    }];
}




@end

//
//  WindHelper.m
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import "WindHelper.h"
#import <MJExtension/MJExtension.h>
#import <XLForm/XLForm.h>
#import "WindmillDropdownListView.h"

static NSString * const Reward_Video_Ad = @"reward_ad";
static NSString * const Intersititial_fullscreen_Ad = @"intersititial_fullscreen_ad";
static NSString * const Intersititial_Ad = @"intersititial_ad";
static NSString * const Splash_Ad = @"splash_ad";
static NSString * const Native_Ad = @"native_ad";

@implementation WindHelper

+ (NSArray *)getRewardAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Reward_Video_Ad];
}

+ (NSArray *)getIntersititialAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Intersititial_fullscreen_Ad];
}

+ (NSArray *)getIntersititialAdHalfDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Intersititial_Ad];
}

+ (NSArray *)getSplashAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Splash_Ad];
}

+ (NSArray *)getNativeAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Native_Ad];
}

+ (XLFormSectionDescriptor *)getCallbackRows:(NSArray *)datasource {
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"Dropdown"];
    section.title = @"广告回调信息";
    for (NSDictionary *item in datasource) {
        NSString *rowType = [item objectForKey:@"rowType"];
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:item[@"tag"] rowType:rowType?rowType:XLFormRowDescriptorTypeInfo];
        row.title = [item objectForKey:@"title"];
        row.disabled = @YES;
        [section addFormRow:row];
    }
    return section;
}


////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSDictionary *)getChannelItems {
    static NSDictionary *item;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *channelPath = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"json"];
        NSString *channelStr = [NSString stringWithContentsOfFile:channelPath encoding:NSUTF8StringEncoding error:nil];
        item = [channelStr mj_JSONObject];
    });
    return item;
}

+ (NSArray<ChannelItem *> *)getDropdownItemWithKey:(NSString *)key {
    NSDictionary *dict = [self getChannelItems];
    NSDictionary *item = [dict objectForKey:key];
    return [ChannelItem mj_objectArrayWithKeyValuesArray:item];
}

+ (NSArray *)getDropdownDatasourceWithKey:(NSString *)key {
    NSArray *arr = [WindHelper getDropdownItemWithKey:key];
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:arr.count];
    for (ChannelItem *channel in arr) {
        DropdownListItem *item = [[DropdownListItem alloc] initWithItem:channel.placementId itemName:channel.name];
        [dataSource addObject:item];
    }
    return dataSource;
}



@end

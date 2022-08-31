//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FYBPluginFramework) {
    FYBPluginFrameworkUnity,
    FYBPluginFrameworkFlutter
};

NS_ASSUME_NONNULL_BEGIN

@interface FYBPluginOptions : NSObject

@property (nonatomic, assign) FYBPluginFramework pluginFramework;
@property (nonatomic, copy, nullable) NSString *pluginFrameworkVersion;
@property (nonatomic, copy) NSString *pluginSdkVersion;

@end

NS_ASSUME_NONNULL_END

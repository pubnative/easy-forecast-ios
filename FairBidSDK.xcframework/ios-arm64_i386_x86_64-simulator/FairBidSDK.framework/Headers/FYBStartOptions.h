//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FYBPluginOptions.h>

typedef NS_ENUM(NSUInteger, FYBLoggingLevel) {
    FYBLoggingLevelSilent,
    FYBLoggingLevelError,
    FYBLoggingLevelInfo,
    FYBLoggingLevelVerbose
};

/**
 * Options used when starting the FairBid SDK in order to change the default behaviour.
 */
@interface FYBStartOptions : NSObject

/**
 * Defines the log level of FairBid SDK
 */
@property(nonatomic, assign) FYBLoggingLevel logLevel;

/**
 * Enables or disables network specific logging mechanisms
 */
@property(nonatomic, assign) BOOL thirdPartyLoggingEnabled;

/**
 * Set auto–requesting default value for all placements.
 * @discussion Change below configuration for specific placements by calling
 * @code
 * // FYBInterstitial
 * + (void)disableAutoRequesting:(nonnull NSString *)placementId;
 * + (void)enableAutoRequesting:(nonnull NSString *)placementId;
 *
 * // FYBRewarded
 * + (void)disableAutoRequesting:(nonnull NSString *)placementId;
 * + (void)enableAutoRequesting:(nonnull NSString *)placementId;
 * @endcode
 */
@property(nonatomic, assign) BOOL autoRequestingEnabled;

@property(nonatomic, strong, nullable) FYBPluginOptions *pluginOptions;

@end

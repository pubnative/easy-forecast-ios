//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FairBidDelegate.h>
#import <FairBidSDK/FYBSettings.h>
#import <FairBidSDK/FYBStartOptions.h>
#import <FairBidSDK/FYBUserInfo.h>

#define SDK_VERSION @"3.30.0"


#if __has_feature(objc_modules)
@import AdSupport;
@import CoreGraphics;
@import CoreTelephony;
@import MediaPlayer;
@import QuartzCore;
@import StoreKit;
@import MobileCoreServices;
@import Security;
@import SystemConfiguration;
@import MessageUI;
@import CoreLocation;
#endif

/**
 * Class that holds the configurations for the Fyber FairBid SDK.
 * Provides convenience methods to configure and start the SDK.
 *
 * Calling the startWithAppId method on will start the FairBid SDK making all Fyber products available.
 *
 * After starting the SDK, all parameters used to configure the FairBid SDK will remain immutable.
 */
@interface FairBid : NSObject

/**
 * Starts FairBid SDK.
 * This needs to be called as early as possible in the application lifecycle.
 *
 * @param appId The publisher app id.
 */
+ (void)startWithAppId:(nonnull NSString *)appId;

/**
 * Starts FairBid SDK.
 * This needs to be called as early as possible in the application lifecycle.
 *
 * @param appId The publisher app id.
 * @param options Options to change the default behaviour of the FairBid SDK
 */
+ (void)startWithAppId:(nonnull NSString *)appId options:(nonnull FYBStartOptions *)options;

/**
 * Checks if FairBid has been started.
 *
 * @return true if FairBid has been started.
 */
+ (BOOL)isStarted;

/**
 *  Returns a FYBUserInfo object that you can use to pass demographic information to third party SDKs.
 *
 *  @return An FYBUserInfo object. Guaranteed to be non-nil after starting the SDK.
 */
+ (nonnull FYBUserInfo *)user;

/**
 *  Returns a FYBSettings object that you can use to modify settings of the SDK.
 *
 *  @return An FYBSettings object.
 */
+ (nonnull FYBSettings *)settings;

/**
 * Shows the Mediation Test Suite presenting you with all the mediation configuration for this specific appId
 * Note - FairBid SDK must be started first in order to show meaningful information
 */
+ (void)presentTestSuite;

/**
 * Returns the FairBid SDK version
 * 
 * @return the FairBid SDK version
 */
+ (nonnull NSString *)version;

/**
 * The delegate to receive the messages listed in the `FairBidDelegate` protocol.
 */
@property (class, nonatomic, nullable) id <FairBidDelegate> delegate;

@end

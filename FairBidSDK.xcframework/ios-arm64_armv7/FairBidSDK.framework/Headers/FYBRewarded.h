//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FYBLossNotificationReason.h>
#import <FairBidSDK/FYBRewardedDelegate.h>
#import <FairBidSDK/FYBShowOptions.h>

/**
 * Rewarded is used to show a fullscreen rewarded ad where a user must complete some task
 * (e.g. watch a video until the end, perform some action, ...) to get a reward.
 */
@interface FYBRewarded : NSObject

/**
 * The delegate to receive the messages listed in the `FYBRewardedDelegate` protocol.
 */
@property (class, nonatomic, nullable) id <FYBRewardedDelegate> delegate;

/**
 *  The amount of Rewarded impressions for this session.
 */
@property (class, nonatomic, readonly) NSUInteger impressionDepth;

/**
 * Requests a Rewarded ad for the given placement.
 *
 * @param placementId the identifier of the placement to be requested.
 */
+ (void)request:(nonnull NSString *)placementId;

/**
 * Whether or not an ad is available to show for the given placement.
 *
 * @param placementId the identifier of the placement to be shown.
 *
 * @return YES if Rewarded ad is available to be shown, NO otherwise
 */
+ (BOOL)isAvailable:(nonnull NSString *)placementId;

/**
 * Returns revenue and demand source information associated to the ad, if one is available.
 *
 * @param placementId the identifier of the placement.
 *
 * @return An instance of FYBImpressionData if an ad is available, otherwise nil
 */
+ (nullable FYBImpressionData *)impressionData:(nonnull NSString *)placementId;

/**
 * Shows a Rewarded ad for a given placement, if available.
 *
 * @param placementId the identifier of the placement to be shown.
 */
+ (void)show:(nonnull NSString *)placementId;

/**
 * Shows a Rewarded ad with the given options.
 *
 * @param placementId the identifier of the placement to be shown.
 *
 * @param options FYBShowOptions object containing properties for configuring how the ad is shown.
 */
+ (void)show:(nonnull NSString *)placementId options:(nonnull FYBShowOptions *)options;

/**
 * Disables auto–requesting for the given placement.
 *
 * @param placementId The placement id for which the auto–requesting should be disabled.
 */
+ (void)disableAutoRequesting:(nonnull NSString *)placementId;

/**
 * Enables the auto–requesting behaviour for a given placement.
 *
 * @param placementId The placement id for which the auto–requesting should be enabled.
 */
+ (void)enableAutoRequesting:(nonnull NSString *)placementId;

/**
 * Communicates the reason why an ad has lost the opportunity to be displayed
 *
 * @param placementId The placement id for the ad that wasn't shown
 *
 * @param reason The reason why the ad wasn't shown
 */
+ (void)notifyLoss:(nonnull NSString *)placementId reason:(FYBLossNotificationReason)reason;

@end

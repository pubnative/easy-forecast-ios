//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FYBImpressionData.h>

/**
 * Contains the events triggered by a Rewarded
 */
@protocol FYBRewardedDelegate <NSObject>

@optional

/**
 * Called when an ad has been successfully requested and is available to show.
 *
 * @param placementId the identifier of the placement that became available.
 */
- (void)rewardedIsAvailable:(nonnull NSString *)placementId;

/**
 * Called when a placement is not available.
 *
 * @param placementId the identifier of the placement that became unavailable.
 */
- (void)rewardedIsUnavailable:(nonnull NSString *)placementId;

/**
 * Called when an ad is shown to the user.
 *
 * @param placementId the identifier of the placement that was shown.
 * @param impressionData revenue and demand source information associated to the ad
 */
- (void)rewardedDidShow:(nonnull NSString *)placementId impressionData:(nonnull FYBImpressionData *)impressionData;

/**
 * Called when an ad failed to be shown. This can be due to a variety of reasons, such as
 * an internal error in FairBid SDK or no internet connection.
 *
 * @param placementId the identifier of the placement that failed to show.
 * @param error internal error object
 * @param impressionData revenue and demand source information associated to the ad
 */
- (void)rewardedDidFailToShow:(nonnull NSString *)placementId withError:(nonnull NSError *)error impressionData:(nonnull FYBImpressionData *)impressionData;

/**
 * Call when an ad is clicked on by the user. Expect the application to
 * go into the background shortly after this callback is fired.
 *
 * @param placementId the identifier of the placement that was clicked.
 */
- (void)rewardedDidClick:(nonnull NSString *)placementId;

/**
 * Called when an ad has been dismissed.
 *
 * @param placementId the identifier of the placement that was dismissed.
 */
- (void)rewardedDidDismiss:(nonnull NSString *)placementId;

/**
 * Called to notify about the user's completion of a rewarded ad.
 *
 * @param placementId the identifier of the placement that completed.
 * @param userRewarded true if the user completed the ad, false otherwise
 */
- (void)rewardedDidComplete:(nonnull NSString *)placementId userRewarded:(BOOL)userRewarded;

/**
 * Called when an ad is going to be requested
 *
 * @param placementId the identifier of the placement that was requested.
 */
- (void)rewardedWillRequest:(nonnull NSString *)placementId;

@end

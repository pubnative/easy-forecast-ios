//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FYBImpressionData.h>

/**
 * Contains the events triggered by a Interstitial
 */
@protocol FYBInterstitialDelegate <NSObject>

@optional

/**
 * Called when an ad has been successfully requested and is available to show.
 *
 * @param placementId the identifier of the placement that became available.
 */
- (void)interstitialIsAvailable:(nonnull NSString *)placementId;

/**
 * Called when a placement is not available.
 *
 * @param placementId the identifier of the placement that became unavailable.
 */
- (void)interstitialIsUnavailable:(nonnull NSString *)placementId;

/**
 * Called when an ad is shown to the user.
 *
 * @param placementId the identifier of the placement that was shown.
 * @param impressionData revenue and demand source information associated to the ad
 */
- (void)interstitialDidShow:(nonnull NSString *)placementId impressionData:(nonnull FYBImpressionData *)impressionData;

/**
 * Called when an ad failed to be shown. This can be due to a variety of reasons, such as
 * an internal error in FairBid or no internet connection.
 *
 * @param placementId the identifier of the placement that failed to show.
 * @param error internal error object
 * @param impressionData revenue and demand source information associated to the ad
 */
- (void)interstitialDidFailToShow:(nonnull NSString *)placementId withError:(nonnull NSError *)error impressionData:(nonnull FYBImpressionData *)impressionData;

/**
 * Call when an ad is clicked on by the user. Expect the application to
 * go into the background shortly after this callback is fired.
 *
 * @param placementId the identifier of the placement that was clicked.
 */
- (void)interstitialDidClick:(nonnull NSString *)placementId;

/**
 * Called when an ad has been dismissed.
 *
 * @param placementId the identifier of the placement that was dismissed.
 */
- (void)interstitialDidDismiss:(nonnull NSString *)placementId;

/**
 * Called when an ad is going to be requested
 *
 * @param placementId the identifier of the placement that was requested.
 */
- (void)interstitialWillRequest:(nonnull NSString *)placementId;

@end

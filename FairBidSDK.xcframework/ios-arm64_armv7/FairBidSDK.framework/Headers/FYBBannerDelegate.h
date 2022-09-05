//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <FairBidSDK/FYBImpressionData.h>

@class FYBBannerAdView;

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains the events triggered by a Banner
 */
@protocol FYBBannerDelegate <NSObject>

@optional

/**
 * Called when the banner is loaded.
 *
 * @param banner the banner view that was loaded
 */
- (void)bannerDidLoad:(FYBBannerAdView *)banner;

/**
 * Called when the banner failed to load.
 *
 * @param placementId the identifier of the placement that failed
 * @param error a detail of the error triggered when the failure arose
 */
- (void)bannerDidFailToLoad:(NSString *)placementId withError:(NSError *)error;

/**
 * Called when the banner is shown.
 *
 * @param banner the banner view that was shown
 * @param impressionData revenue and demand source information associated to the ad
 */
- (void)bannerDidShow:(FYBBannerAdView *)banner impressionData:(FYBImpressionData *)impressionData;

/**
 * Called when the banner is clicked.
 *
 * @param banner the banner view that was clicked
 */
- (void)bannerDidClick:(FYBBannerAdView *)banner;

/**
 * Called when the banner will present a modal view.
 *
 * @param banner the banner view that presents the modal view
 */
- (void)bannerWillPresentModalView:(FYBBannerAdView *)banner;

/**
 * Called when the banner dismissed the modal view.
 *
 * @param banner the banner view that dismissed the modal view
 */
- (void)bannerDidDismissModalView:(FYBBannerAdView *)banner;

/**
 * Called when a banner view user interaction will make the user leave the application.
 *
 * @param banner the banner view that was being displayed
 */
- (void)bannerWillLeaveApplication:(FYBBannerAdView *)banner;

/**
 * Called when the banner was resized to a new frame.
 *
 * @param banner the banner view that was resized
 * @param frame the frame to which the banner was resized to
 */
- (void)banner:(FYBBannerAdView *)banner didResizeToFrame:(CGRect)frame;

/**
 * Called when the banner is going to be requested.
 *
 * @param placementId the identifier of the placement that is requested
 */
- (void)bannerWillRequest:(NSString *)placementId;

@end

NS_ASSUME_NONNULL_END

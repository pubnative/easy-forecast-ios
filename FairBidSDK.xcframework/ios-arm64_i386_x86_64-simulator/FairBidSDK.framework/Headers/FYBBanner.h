//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FairBidSDK/FYBBannerDelegate.h>
#import <FairBidSDK/FYBBannerOptions.h>

/**
 *  Locations where FairBid SDK can automatically place the banner.
 *
 *  See `showBannerInView:position:options:` for details on how this interacts with top/bottom layout guides in iOS 8+.
 */
typedef NS_ENUM(NSUInteger, FYBBannerAdViewPosition) {
    /**
     *  Option for placing the banner at the top of the view.
     */
    FYBBannerAdViewPositionTop,
    /**
     *  Option for placing the banner at the bottom of the view.
     */
    FYBBannerAdViewPositionBottom
};

/**
 *  @brief Class responsible for managing Banner ads.
 */
@interface FYBBanner : NSObject

/**
 *  The delegate to receive the messages listed in the `FYBBannerDelegate` protocol.
 */
@property (class, nonatomic, nullable) id <FYBBannerDelegate> delegate;

/**
 *  The amount of Banner impressions for this session.
 */
@property (class, nonatomic, readonly) NSUInteger impressionDepth;

/**
 *  @brief Displays a banner within the provided view.
 *
 *  @param view the view in which the banner will be displayed.
 *  @param position the FYBBannerAdViewPosition object used to place the banner either at the top or the bottom.
 *  @param options the banner options to use.
 */
+ (void)showBannerInView:(nullable UIView *)view
                position:(FYBBannerAdViewPosition)position
                 options:(nonnull FYBBannerOptions *)options;

/**
 *  @brief Requests a banner with the provided options.
 *
 *  @param options the banner options to use in the request.
 */
+ (void)requestWithOptions:(nonnull FYBBannerOptions *)options;

/**
 *  @brief Destroys the banner.
 *
 *  @discussion The banner is removed from its superview. This method does no free memory by itself, please make sure
 *  to release all strong references to the banner view to prevent memory issues. If this method is called during an
 *  ongoing banner request, the banner will not be shown and no callbacks will be triggered.
 *  
 *  @param placementId The identifier of the placement to be destroyed.
 */
+ (void)destroy:(nonnull NSString *)placementId;

@end

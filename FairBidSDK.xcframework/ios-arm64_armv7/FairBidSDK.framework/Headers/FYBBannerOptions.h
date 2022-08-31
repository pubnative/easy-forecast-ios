//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#ifndef FYBBannerOptions_h
#define FYBBannerOptions_h

#import <UIKit/UIKit.h>
/**
 *  Options to present banners for a placement in a view controller.
 */
@interface FYBBannerOptions : NSObject

/**
 *  The view controller to present the ad from. 
 *
 *  This property is optional. If not set, it defaults to the root view controller of the application.
 *
 *  @note Setting this property doesn't change where the actual banner (a `UIView`) is placed. For Fyber banners, the width of this property will determine the width of a flexible-width banner.
 */
@property (nonatomic, weak, nullable) UIViewController *presentingViewController;

/**
 *  The identifier of the placement to be shown.
 */
@property (nonatomic, copy, nonnull) NSString *placementId;

@end

#endif

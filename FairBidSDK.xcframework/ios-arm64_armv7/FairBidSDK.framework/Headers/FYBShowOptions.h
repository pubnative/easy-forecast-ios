//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * FYBShowOptions allows you to pass options to configure how ads are shown
 */
@interface FYBShowOptions : NSObject

/**
 *  @discussion A UIViewController that should present the ad being shown. If not specified the application's key window's root view controller is used.
 */
@property (nonatomic, weak, null_resettable) UIViewController *viewController;

/**
 *  Sets a Dictionary of custom parameters to be passed to Server Side Rewarding upon video completion.
 *  You need to pass this object through the <Show> API every time you want to pass these parameters to Server Side Rewarding.
 *
 *  @discussion Dictionary of custom parameters to be passed to Server Side Rewarding upon video completion.
 *  Length of keys and values of custom parameters combined MUST NOT exceed 4096 characters. If the limit is exceeded, the SDK considers it null and no parameters will be passed to Server Side Rewarding upon video completion.
*/
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *customParameters;

@end

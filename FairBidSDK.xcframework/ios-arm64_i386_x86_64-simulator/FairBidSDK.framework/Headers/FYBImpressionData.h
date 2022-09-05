//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FYBImpressionDataPriceAccuracy) {
    /// When the netPayout is ‘0’.
    FYBImpressionDataPriceAccuracyUndisclosed = 0,

    /// When Fyber’s estimation of the impression value is based on historical data from non-programmatic mediated network’s reporting APIs.
    FYBImpressionDataPriceAccuracyPredicted = 1,

    /// When netPayout is the exact and committed value of the impression, available when impressions are won by programmatic buyers.
    FYBImpressionDataPriceAccuracyProgrammatic = 2
};

typedef NS_ENUM(NSInteger, FYBPlacementType) {
    FYBPlacementTypeBanner = 0,
    FYBPlacementTypeInterstitial = 1,
    FYBPlacementTypeRewarded = 2
};

/**
 *  Impression data contains detailed information for each impression. That includes which demand source served the ad,
 *  the expected or exact revenue associated with it as well as granular details that will allow you to analyse and,
 *  ultimately, optimize both your ad monetization and user acquisition strategies.
 */
@interface FYBImpressionData : NSObject

/**
 *  Advertiser’s domain when available. Used as an identifier for a set of campaigns for the same advertiser.
 */
@property (nonatomic, copy, nullable, readonly) NSString *advertiserDomain;

/**
 *  Campaign ID when available used as an identifier for a specific campaign of a certain advertiser.
 */
@property (nonatomic, copy, nullable, readonly) NSString *campaignId;

/**
 *  Country location of the ad impression (in ISO country code).
 */
@property (nonatomic, copy, nullable, readonly) NSString *countryCode;

/**
 *  Creative ID when available. Used as an identifier for a specific creative of a certain campaign.
 *  This is particularly useful information when a certain creative is found to cause user experience issues.
 */
@property (nonatomic, copy, nullable, readonly) NSString *creativeId;

/**
 *  Currency of the payout.
 */
@property (nonatomic, copy, nullable, readonly) NSString *currency;

/**
 *  Demand Source name is the name of the buy-side / demand-side entity that purchased the impression.
 *  When mediated networks win an impression, you’ll see the mediated network’s name. When a DSP buying
 *  through the programmatic marketplace wins the impression, you’ll see the DSP’s name.
 */
@property (nonatomic, copy, nullable, readonly) NSString *demandSource;

/**
 *  A unique identifier for a specific impression.
 */
@property (nonatomic, copy, nonnull, readonly) NSString *impressionId;

/**
 *  The amount of impressions in current session for the given Placement Type
 */
@property (nonatomic, readonly) NSUInteger impressionDepth;

/**
 *  String representation of json dictionnary.
 */
@property (nonatomic, copy, nullable, readonly) NSString *jsonString;

/**
 *  Net payout for an impression. The value accuracy is returned in the priceAccuracy field.
 *  The value is provided in units returned in the currency field.
 */
@property (nonatomic, copy, nullable, readonly) NSNumber *netPayout;

/**
 *  The mediated ad network’s original Placement/Zone/Location/Ad Unit ID that you created in their dashboard.
 *  For ads shown by the Fyber Marketplace the networkInstanceId is 'nil'.
 */
@property (nonatomic, copy, nullable, readonly) NSString *networkInstanceId;

/**
 *  Accuracy of the netPayout value. May return one of the following:
 *  - UNDISCLOSED - When the netPayout is ‘0’.
 *  - PREDICTED - When Fyber’s estimation of the impression value is based on historical data from non-programmatic mediated network’s reporting APIs.
 *  - PROGRAMMATIC - When netPayout is the exact and committed value of the impression, available when impressions are won by programmatic buyers.
 */
@property (nonatomic, assign, readonly) FYBImpressionDataPriceAccuracy priceAccuracy;

/**
 *  Type of the impression’s placement.
 */
@property (nonatomic, assign, readonly) FYBPlacementType placementType;

/**
 *  Name of the SDK rendering the ad.
 */
@property (nonatomic, copy, nullable, readonly) NSString *renderingSDK;

/**
 *  Version of the SDK rendering the ad.
 */
@property (nonatomic, copy, nullable, readonly) NSString *renderingSDKVersion;

/**
 *  The variant id can represent a group in a Multi-Testing experiment.
 */
@property (nonatomic, copy, nullable, readonly) NSString *variantId;

@end

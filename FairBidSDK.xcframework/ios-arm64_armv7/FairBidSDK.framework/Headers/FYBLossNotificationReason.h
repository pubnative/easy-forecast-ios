//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FYBLossNotificationReason) {
    FYBLossNotificationReasonUnknown = 0,
    FYBLossNotificationReasonLostOnPrice,
    FYBLossNotificationReasonImpressionOpportunityExpired,
    FYBLossNotificationReasonFilteredAdvertiser,
    FYBLossNotificationReasonFilteredNetwork
};

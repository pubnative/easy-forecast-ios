//
//
// Copyright (c) 2021 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <FairBidSDK/FYBMediatedNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FairBidDelegate <NSObject>

- (void)networkStarted:(FYBMediatedNetwork)network;

- (void)network:(FYBMediatedNetwork)network failedToStartWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END

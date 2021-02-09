//
//  HyBidSessionManager.h
//  HyBid
//
//  Created by Eros Garcia Ponte on 26.08.20.
//  Copyright © 2020 Can Soykarafakili. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HyBidUserLocation;

@interface HyBidSessionManager : NSObject

- (void) openSession;
- (void) recordLocation:(HyBidUserLocation*)location;

- (void) processSessions;

@end

NS_ASSUME_NONNULL_END

//
//  HyBidUserSession.h
//  HyBid
//
//  Created by Eros Garcia Ponte on 29.07.20.
//  Copyright © 2020 Can Soykarafakili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyBidUserLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyBidUserSession : NSObject {
    NSInteger _sessionId;
    NSInteger _numberOfSignals;
    double _averageLatitude;
    double _averageLongitude;
    double _averageHorizontalAccuracy;
    float _wifiPercentage;
    NSInteger _firstTimestamp;
    NSInteger _lastTimestamp;
    double _duration;
    NSString* _date;
}

@property(nonatomic, assign) NSInteger sessionId;
@property(nonatomic, assign) NSInteger numberOfSignals;
@property(nonatomic, assign) double averageLatitude;
@property(nonatomic, assign) double averageLongitude;
@property(nonatomic, assign) double averageHorizontalAccuracy;
@property(nonatomic, assign) float wifiPercentage;
@property(nonatomic, assign) NSInteger firstTimestamp;
@property(nonatomic, assign) NSInteger lastTimestamp;
@property(nonatomic, assign) double duration;
@property(nonatomic, copy) NSString* date;

- (NSString*) description;

@end

NS_ASSUME_NONNULL_END

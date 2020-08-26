//
//  HyBidUserLocation.h
//  HyBid
//
//  Created by Eros Garcia Ponte on 24.07.20.
//  Copyright © 2020 Can Soykarafakili. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyBidUserLocation : NSObject {
    NSInteger _locationNumber;
    NSInteger _sessionId;
    double _latitude;
    double _longitude;
    double _horizontalAccuracy;
    NSDate* _date;
    NSInteger _connectionType;
}

@property(nonatomic, assign) NSInteger locationNumber;
@property(nonatomic, assign) NSInteger sessionId;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double horizontalAccuracy;
@property(nonatomic, copy) NSDate* date;
@property(nonatomic, assign) NSInteger connectionType;

-(id) initWithId: (NSInteger) locationId latitude: (double) latitude longitude: (double) longitude accuracy:(double) accuracy date: (NSDate*) date connectionType: (NSInteger) connectionType;
-(id) initWithLatitude: (double) latitude longitude: (double) longitude accuracy:(double) accuracy date: (NSDate*) date connectionType: (NSInteger) connectionType;

-(NSString*) stringForLogging;

@end

NS_ASSUME_NONNULL_END

//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface FYBSettings : NSObject

/**
 * Configures the Ad Networks that support sound configuration to serve ads with or without sound according the boolean value
 */
@property (nonatomic, getter=isMuted) BOOL muted;

@end

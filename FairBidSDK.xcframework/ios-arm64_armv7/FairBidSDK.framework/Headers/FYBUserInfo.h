//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@class CLLocation;

/**
 * Defines different genders an user can have.
 */
typedef NS_ENUM(NSUInteger, FYBGender) {
    /** Unknown */
    FYBGenderUnknown = 0,
    /** Male */
    FYBGenderMale,
    /** Female */
    FYBGenderFemale,
    /** Other */
    FYBGenderOther
};


/**
 *  Set the properties on this class to pass information about the user to each of the mediated ad networks.
 * 
 *  Setting any/all of these values is optional. Many ad networks will use this information to serve better-targeted ads.
 */
@interface FYBUserInfo : NSObject

/**
 *  Sets User’s ID to be used by the SDK in Server Side Rewarding upon video completion for the remainder of the session.
 *
 *  @discussion A string  representing the User’s ID. This ID is used to identify the user being rewarded in Server Side Rewarding every time a video is completed.
 *  If the total number of chars in this ID surpasses 256, a null value will be passed to Server Side Rewarding upon video completion.
 *  @note Not including mentions to generated user ID as of yet! It would change to:
 *
 *  If the total number of chars in this ID surpasses 256 or if a null value or empty string is passed, the SDK will consider it invalid and generate a new random Id.

 */
@property (nonatomic, copy, nullable) NSString *userId;

/**
 *  The user's current location.
 *
 *  Networks who use this information: AdColony, AdMob
 */
@property (nonatomic, strong, nullable) CLLocation *location;

/**
 *  The user's birthdate.
 *
 *  Some networks will only use the age / birth year / age range of the user, and some will use the full birthdate, so you can set this as accurately as possible and we'll give what we can to each network that asks for it. For instance, if you only know that a user is 25, you can set the birthdate to 25 years from today and that will be sufficient.
 *
 *  Networks who use this information: AdColony, AdMob
 */
@property (nonatomic, strong, nullable) NSDate *birthDate;

/*
 *  The user's gender.
 *
 *  Networks who use this information: AdColony, AdMob, Fyber
 */
@property (nonatomic) FYBGender gender;

/**
 *  The user's postal code.
 *
 *  Networks who use this information: AdColony, Fyber
 */
@property (nonatomic, strong, nullable) NSString *postalCode;

/**
 * Sets User's consent under GDPR. FairBid SDK will only be able to show targeted advertising if the user consented.
 * Only set this property if the user explicitly gave or denied consent.
 */
@property(nonatomic, assign) BOOL GDPRConsent;

/**
 * Sets User's consent under LGPD. FairBid SDK will only be able to show targeted advertising if the user consented.
 * Only set this property if the user explicitly gave or denied consent.
 */
@property(nonatomic, assign) BOOL LGPDConsent;

/**
 * Sets User's consent string under GDPR. FairBid SDK will use this information to provide optimal targeted advertising without infringing GDPR.
 */
@property(nonatomic, copy, nullable) NSString *GDPRConsentString;

/**
 * Deprecated in v3.14.0, use GDPRConsentString property
 */
- (void)clearGDPRConsent __attribute__((deprecated("Deprecated in v3.14.0, use GDPRConsentString property")));

/**
 * Sets User's IAB US privacy string under CCPA. FairBid SDK will use this information to provide optimal targeted advertising without infringing CCPA.
 */
@property(nonatomic, copy, nullable) NSString *IABUSPrivacyString;

/**
 * Clears all IAB US privacy related information.
 * @deprecated Deprecated in v3.16.0
 */
- (void)clearIABUSPrivacyString __attribute__((deprecated("Deprecated in v3.16.0")));

/**
 * Set value to @c YES if  the user is a child subject to COPPA, and @c NO otherwise.  FairBid SDK will pass this flag to mediated network SDKs, to provide optimal targeted advertising.
 * Default value is @c NO.
 */
@property (nonatomic, assign) BOOL isChild;

@end

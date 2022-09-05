//
//  Copyright © 2019 EasyNaps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

let BANNER_PLACEMENT = "banner_placement"
let MRECT_PLACEMENT = "mrect_placement"
let INTERSTITIAL_PLACEMENT = "interstitial_placement"
let REWARDED_VIDEO_PLACEMENT = "rewarded_video_placement"

//PubNative
#if DEBUG
let PUBNATIVE_APP_TOKEN = "543027b8e954474cbcd9a98481622a3b"
let PUBNATIVE_BANNER_ZONE_ID = "2"
let PUBNATIVE_MRECT_ZONE_ID = "3"
let PUBNATIVE_INTERSTITIAL_ZONE_ID = "4"
let PUBNATIVE_REWARDED_AD_ZONE_ID = "6"
#else
let PUBNATIVE_APP_TOKEN = "3e98d63843d8437c8d35a05edab557dd"
let PUBNATIVE_BANNER_ZONE_ID = "2"
let PUBNATIVE_MRECT_ZONE_ID = "3"
let PUBNATIVE_INTERSTITIAL_ZONE_ID = "1"
let PUBNATIVE_REWARDED_AD_ZONE_ID = ""
#endif

//AppLovin

//IronSouce
let IRONSOURCE_APPKEY = "868565b5"
let IRONSOURCE_BANNER_AD_UNIT_ID = "ForecastBanner"
let IRONSOURCE_MRECT_AD_UNIT_ID = ""
let IRONSOURCE_INTERSTITIAL_AD_UNIT_ID = "ForecastInterstitial"
let IRONSOURCE_REWARDED_VIDEO_AD_UNIT_ID = "ForecastRewardedVideo"

//Fyber
let FYBER_PUBLISHER_ID = "5cc49eb119c0330e30cad321071bbee5"

//Facebook
let FACEBOOK_BANNER_AD_UNIT_ID = "287353418611453_287354918611303"
let FACEBOOK_MRECT_AD_UNIT_ID = "287353418611453_289774281702700"
let FACEBOOK_INTERSTITIAL_AD_UNIT_ID = "287353418611453_289773931702735"
let FACEBOOK_REWARDED_VIDEO_AD_UNIT_ID = ""

//Google Ad Manager
#if DEBUG
let GOOGLE_ADS_MANAGER_BANNER_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
let GOOGLE_ADS_MANAGER_MRECT_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
let GOOGLE_ADS_MANAGER_INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-3940256099942544/4411468910"
let GOOGLE_ADS_MANAGER_REWARDED_VIDEO_AD_UNIT_ID = "ca-app-pub-3940256099942544/1712485313"
#else
let GOOGLE_ADS_MANAGER_BANNER_AD_UNIT_ID = "/219576711/EasyForecast_Banner"
let GOOGLE_ADS_MANAGER_MRECT_AD_UNIT_ID = "/219576711/EasyForecast_MRect"
let GOOGLE_ADS_MANAGER_INTERSTITIAL_AD_UNIT_ID = "/219576711/EasyForecast_Interstitial"
let GOOGLE_ADS_MANAGER_REWARDED_VIDEO_AD_UNIT_ID = "/219576711/EasyForecast_Video"
#endif

//Google AdMob
#if DEBUG
let ADMOB_APP_ID = "ca-app-pub-9176690371168943~2007446977"
let ADMOB_BANNER_AD_UNIT_ID = "ca-app-pub-9176690371168943/6273995040"
let ADMOB_MRECT_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
let ADMOB_INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-9176690371168943/8078031300"
let ADMOB_REWARDED_VIDEO_AD_UNIT_ID = "ca-app-pub-3940256099942544/1712485313"
#else
let ADMOB_APP_ID = "ca-app-pub-9176690371168943~2007446977"
let ADMOB_BANNER_AD_UNIT_ID = "ca-app-pub-9176690371168943/6273995040"
let ADMOB_MRECT_AD_UNIT_ID = ""
let ADMOB_INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-9176690371168943/8078031300"
let ADMOB_REWARDED_VIDEO_AD_UNIT_ID = "ca-app-pub-9176690371168943/6840083202"
#endif

//StartApp
let STARTAPP_APP_ID = "201194932"

//Unity
let UNITY_GAME_ID = "3031363"
let UNITY_BANNER_AD_UNIT_ID = "banner"
let UNITY_MRECT_AD_UNIT_ID = ""
let UNITY_INTERSTITIAL_AD_UNIT_ID = "interstitial"
let UNITY_REWARDED_VIDEO_AD_UNIT_ID = "rewardedVideo"

// TODO: These credentials are public ones, which means NEVER used for a release, just for testing purposes.

//Fyber
#if DEBUG
let FYBER_APP_ID = "109613"
let FYBER_BANNER_AD_UNIT_ID = "197407"
let FYBER_MRECT_AD_UNIT_ID = "197407"
let FYBER_INTERSTITIAL_AD_UNIT_ID = "197405"
let FYBER_REWARDED_VIDEO_AD_UNIT_ID = "197406"

// TODO: For a release is a must to create the app on Fyber dashboard and add official credentials.

#else
let ADMOB_APP_ID = ""
let ADMOB_BANNER_AD_UNIT_ID = ""
let ADMOB_MRECT_AD_UNIT_ID = ""
let ADMOB_INTERSTITIAL_AD_UNIT_ID = ""
let ADMOB_REWARDED_VIDEO_AD_UNIT_ID = ""
#endif


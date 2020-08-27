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
import HyBid
import GoogleMobileAds
import FBAudienceNetwork
import AppLovinSDK

class BannerPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withAdPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withAdPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withAdPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = HyBidBannerAdView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        return PubNativeBannerController(withAdView: adView, withZoneID: PUBNATIVE_BANNER_ZONE_ID, adPlacementDelegate: delegate)
    }
    
    fileprivate func createAppLovinPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        guard let sharedInstance = ALSdk.shared() else { return nil }
        let adView = ALAdView(frame: CGRect(x: 0, y: 0, width: 320, height: 50), size: ALAdSize.sizeBanner(), sdk: sharedInstance)
        return AppLovinBannerController(withAdView: adView, adPlacementDelegate: delegate)
    }
    
    fileprivate func createIronSourcePlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return IronSourceBannerController(withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createFacebookPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = FBAdView(placementID: FACEBOOK_BANNER_AD_UNIT_ID, adSize: kFBAdSizeHeight50Banner, rootViewController: viewController)
        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        return FacebookBannerController(withAdView: adView, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = DFPBannerView(adSize: kGADAdSizeBanner)
        return GoogleAdsManagerBannerController(withAdView: adView, withAdUnitID: GOOGLE_ADS_MANAGER_BANNER_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createAdmobPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        return AdMobBannerController(withAdView: adView, withAdUnitID: ADMOB_BANNER_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createStartAppPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return StartAppBannerController(withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createUnityPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return UnityBannerController(withAdPlacementDelegate: delegate)
    }
    
}

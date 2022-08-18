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
//import MoPubSDK
import GoogleMobileAds
import FBAudienceNetwork
import AppLovinSDK

/*class MRectPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withAdPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withAdPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .fyber:
            return createFyberPlacement(withAdPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .moPub:
            return createMoPubPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
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
        let adView = HyBidAdView(size: HyBidAdSize.size_300x250)!
        return PubNativeMRectController(withAdView: adView, withZoneID: PUBNATIVE_MRECT_ZONE_ID, adPlacementDelegate: delegate)
    }
    
    fileprivate func createAppLovinPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        guard let sharedInstance = ALSdk.shared() else { return nil }
        let adView = ALAdView(frame: CGRect(x: 0, y: 0, width: 300, height: 250), size: ALAdSize.mrec, sdk: sharedInstance)
        return AppLovinMRectController(withAdView: adView, adPlacementDelegate: delegate)
    }
    
    fileprivate func createIronSourcePlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return IronSourceMRectController(withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createFyberPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createFacebookPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = FBAdView(placementID: FACEBOOK_MRECT_AD_UNIT_ID, adSize: kFBAdSizeHeight250Rectangle, rootViewController: viewController)
        adView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        return FacebookMRectController(withAdView: adView, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createMoPubPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        guard let adView = MPAdView(adUnitId: MOPUB_MRECT_AD_UNIT_ID, size: MOPUB_MEDIUM_RECT_SIZE) else { return nil }
        return MoPubMRectController(withAdView: adView, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        return GoogleAdsManagerMRectController(withAdView: adView, withAdUnitID: GOOGLE_ADS_MANAGER_MRECT_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createAdmobPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        return AdMobMRectController(withAdView: adView, withAdUnitID: ADMOB_MRECT_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createStartAppPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return StartAppMRectController(withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createUnityPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
}

 */

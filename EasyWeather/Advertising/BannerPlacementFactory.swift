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
import MoPub
import GoogleMobileAds

class BannerPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withAdPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withAdPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withAdPlacementDelegate: delegate)
        case .fyber:
            return createFyberPlacement(withAdPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withAdPlacementDelegate: delegate)
        case .moPub:
            return createMoPubPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withViewController: viewController, withAdPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withAdPlacementDelegate: delegate)
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
    
    fileprivate func createAppLovinPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createIronSourcePlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createFyberPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createFacebookPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createMoPubPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
        guard let adView = MPAdView(adUnitId: MOPUB_BANNER_AD_UNIT_ID, size: MOPUB_BANNER_SIZE) else { return nil }
        return MoPubBannerController(withAdView: adView, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = DFPBannerView(adSize: kGADAdSizeBanner)
        return GoogleAdsManagerBannerController(withAdView: adView, withAdUnitID: GOOGLE_ADS_MANAGER_BANNER_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createAdmobPlacement(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        return AdMobBannerController(withAdView: adView, withAdUnitID: ADMOB_BANNER_AD_UNIT_ID, withViewController: viewController, withAdPlacementDelegate: delegate)
    }
    
    fileprivate func createStartAppPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createUnityPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
}

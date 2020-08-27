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
import GoogleMobileAds
import FBAudienceNetwork
import UnityAds

class InterstitialPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withInterstitialPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withInterstitialPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withInterstitialPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return PubNativeInterstitialController.init(withZoneID: PUBNATIVE_INTERSTITIAL_ZONE_ID, withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createAppLovinPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return AppLovinInterstitialController(withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createIronSourcePlacement(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return IronSourceInterstitialController(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createFacebookPlacement(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        let interstitial = FBInterstitialAd(placementID: FACEBOOK_INTERSTITIAL_AD_UNIT_ID)
        return FacebookInterstitialController(withInterstitial: interstitial, withViewController: viewController, withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        let interstitial = DFPInterstitial(adUnitID: GOOGLE_ADS_MANAGER_INTERSTITIAL_AD_UNIT_ID)
        return GoogleAdsManagerInterstitialController(withInterstitial: interstitial, withViewController: viewController, withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createAdmobPlacement(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        let interstitial = GADInterstitial(adUnitID: ADMOB_INTERSTITIAL_AD_UNIT_ID)
        return AdMobInterstitialController(withInterstitial: interstitial, withViewController: viewController, withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createStartAppPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return StartAppInterstitialController(withInterstitialPlacementDelegate: delegate)
    }
    
    fileprivate func createUnityPlacement(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return UnityInterstitialController(withViewController: viewController, withInterstitialPlacementDelegate: delegate)
    }
    
}

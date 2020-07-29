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
import MoPub
import AppLovinSDK
import FBAudienceNetwork

class RewardedVideoPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withRewardedVideoPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        case .moPub:
            return createMoPubPlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createAppLovinPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return AppLovinRewardedVideoController(withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createIronSourcePlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return IronSourceRewardedVideoController(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createFacebookPlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        let rewardedVideo = FBRewardedVideoAd(placementID: FACEBOOK_REWARDED_VIDEO_AD_UNIT_ID)
        return FacebookRewardedVideoController(withRewardedVideo: rewardedVideo, withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createMoPubPlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return MoPubRewardedVideoController(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return GoogleAdsManagerRewardedVideoController(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createAdmobPlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return AdMobRewardedVideoController(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createStartAppPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return StartAppRewardedVideoController(withRewardedVideoPlacementDelegate: delegate)
    }
    
    fileprivate func createUnityPlacement(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return UnityRewardedVideoController(withViewController: viewController, withRewardedVideoPlacementDelegate: delegate)
    }
    
}


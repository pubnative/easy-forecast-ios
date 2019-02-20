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

class RewardedVideoPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withRewardedVideoPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withRewardedVideoPlacementDelegate: delegate)
        case .fyber:
            return createFyberPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .moPub:
            return createMoPubPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withRewardedVideoPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withRewardedVideoPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createAppLovinPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createIronSourcePlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createFyberPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createFacebookPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createMoPubPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createAdmobPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createStartAppPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
    fileprivate func createUnityPlacement(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) -> RewardedVideoPlacement {
        return RewardedVideoPlacement()
    }
    
}


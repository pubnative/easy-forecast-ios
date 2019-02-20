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

class InterstitialPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement? {
        switch adNetwork {
        case .pubnative:
            return createPubNativePlacement(withInterstitialPlacementDelegate: delegate)
        case .appLovin:
            return createAppLovinPlacement(withInterstitialPlacementDelegate: delegate)
        case .ironSource:
            return createIronSourcePlacement(withInterstitialPlacementDelegate: delegate)
        case .fyber:
            return createFyberPlacement(withInterstitialPlacementDelegate: delegate)
        case .facebook:
            return createFacebookPlacement(withInterstitialPlacementDelegate: delegate)
        case .moPub:
            return createMoPubPlacement(withInterstitialPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withInterstitialPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withInterstitialPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withInterstitialPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withInterstitialPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createAppLovinPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createIronSourcePlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createFyberPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createFacebookPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createMoPubPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createAdmobPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createStartAppPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
    fileprivate func createUnityPlacement(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) -> InterstitialPlacement {
        return InterstitialPlacement()
    }
    
}

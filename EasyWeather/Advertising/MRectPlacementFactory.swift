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

class MRectPlacementFactory {
    
    func createAdPlacement(withAdNetwork adNetwork: AdNetwork, withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement? {
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
            return createMoPubPlacement(withAdPlacementDelegate: delegate)
        case .googleAdsManager:
            return createGoogleAdsManagerPlacement(withAdPlacementDelegate: delegate)
        case .admob:
            return createAdmobPlacement(withAdPlacementDelegate: delegate)
        case .startApp:
            return createStartAppPlacement(withAdPlacementDelegate: delegate)
        case .unity:
            return createUnityPlacement(withAdPlacementDelegate: delegate)
        default:
            return nil
        }
    }
    
    fileprivate func createPubNativePlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
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
    
    fileprivate func createMoPubPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createGoogleAdsManagerPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createAdmobPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createStartAppPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
    fileprivate func createUnityPlacement(withAdPlacementDelegate delegate: AdPlacementDelegate) -> AdPlacement {
        return AdPlacement()
    }
    
}


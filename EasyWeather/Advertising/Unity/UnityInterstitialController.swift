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


import UIKit
import UnityAds

class UnityInterstitialController: InterstitialPlacement {
    
    var placementContent: UMONPlacementContent!
    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    
    init(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
    }
    
    override func loadAd() {
        UnityMonetization.initialize(UNITY_GAME_ID, delegate: self, testMode: true)
    }
    
    override func show() {
        if (placementContent.type == "SHOW_AD") {
            let showAdPlacementContent = placementContent as! UMONShowAdPlacementContent
            showAdPlacementContent.show(viewController, with: self)
        }
    }
    
    override func isReady() -> Bool {
        return placementContent.isReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}

extension UnityInterstitialController: UnityMonetizationDelegate {
    
    func placementContentReady(_ placementId: String, placementContent decision: UMONPlacementContent) {
        guard let delegate = self.delegate else { return }
        if (placementId == UNITY_INTERSTITIAL_AD_UNIT_ID) {
            placementContent = decision
            delegate.interstitialPlacementDidLoad()
        }
    }
    
    func placementContentStateDidChange(_ placementId: String, placementContent: UMONPlacementContent, previousState: UnityMonetizationPlacementContentState, newState: UnityMonetizationPlacementContentState) {
        if (newState != .placementContentStateReady) {
            // Disable showing ads because content isn’t ready anymore
        }
    }
    
    func unityServicesDidError(_ error: UnityServicesError, withMessage message: String) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
}

extension UnityInterstitialController: UMONShowAdDelegate {
    
    func unityAdsDidStart(_ placementId: String!) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func unityAdsDidFinish(_ placementId: String!, with finishState: UnityAdsFinishState) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
}

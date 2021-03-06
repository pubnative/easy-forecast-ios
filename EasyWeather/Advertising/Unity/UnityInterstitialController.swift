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
    
    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    var isShown = false

    init(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        UnityAds.setDelegate(self)
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .unity)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        if (UnityAds.isReady(UNITY_INTERSTITIAL_AD_UNIT_ID)) {
            unityAdsReady(UNITY_INTERSTITIAL_AD_UNIT_ID)
        } else {
            unityAdsDidError(UnityAdsError(rawValue: 0)!, withMessage: "Error when loading the ad")
        }
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        UnityAds.show(viewController, placementId: UNITY_INTERSTITIAL_AD_UNIT_ID)
    }
    
    override func isReady() -> Bool {
        return UnityAds.isReady(UNITY_INTERSTITIAL_AD_UNIT_ID)
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}

extension UnityInterstitialController: UnityAdsDelegate {
    
    func unityAdsReady(_ placementId: String) {
        if !isShown {
            isShown = true
            guard let delegate = self.delegate else { return }
            if (placementId == UNITY_INTERSTITIAL_AD_UNIT_ID) {
                adAnalyticsSession.confirmLoaded()
                delegate.interstitialPlacementDidLoad()
            }
        }
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func unityAdsDidStart(_ placementId: String) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
}

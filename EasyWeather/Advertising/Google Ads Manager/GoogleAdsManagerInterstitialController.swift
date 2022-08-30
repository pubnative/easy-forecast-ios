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
import GoogleMobileAds

class GoogleAdsManagerInterstitialController: InterstitialPlacement {
    
    var interstitial: GADInterstitialAd!
    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    
    init(withInterstitial interstitial: GADInterstitialAd, withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.interstitial = interstitial
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .googleAdsManager)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        GADInterstitialAd.load(withAdUnitID: GOOGLE_ADS_MANAGER_INTERSTITIAL_AD_UNIT_ID, request: GADRequest()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            guard let ad = ad else { return }
            
            self?.interstitial = ad
            self?.interstitial.fullScreenContentDelegate = self
            
            self?.interstitialDidReceiveAd(ad)
        }
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        interstitial.present(fromRootViewController: viewController)
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension GoogleAdsManagerInterstitialController: GADFullScreenContentDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitialAd) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillDismissFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        adAnalyticsSession.confirmClick()
        adAnalyticsSession.confirmLeftApplication()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
}

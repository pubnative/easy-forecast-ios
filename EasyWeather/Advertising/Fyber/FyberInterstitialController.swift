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

class FyberInterstitialController: InterstitialPlacement {

    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .fyber)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        HZInterstitialAd.fetch { (success, error) in
            if success {
                HZInterstitialAd.setDelegate(self)
                self.adAnalyticsSession.confirmLoaded()
                guard let delegate = self.delegate else { return }
                delegate.interstitialPlacementDidLoad()
            } else {
                self.adAnalyticsSession.confirmError()
                guard let delegate = self.delegate else { return }
                let defaultError = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "Fyber Interstitial did fail to load"])
                delegate.interstitialPlacementDidFail(withError: error ?? defaultError)
            }
        }
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        let showOptions = HZShowOptions()
        showOptions.viewController = viewController
        HZInterstitialAd.show(with: showOptions)
    }
    
    override func isReady() -> Bool {
        return HZInterstitialAd.isAvailable()
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension FyberInterstitialController: HZAdsDelegate {
    
    func didShowAd(withTag tag: String!) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func didFailToReceiveAd(withTag tag: String!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "Fyber Interstitial did fail to load"])
        delegate.interstitialPlacementDidFail(withError: error)

    }
    
    func didFailToShowAd(withTag tag: String!, andError error: Error!) {
        adAnalyticsSession.confirmInterstitialShowError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)

    }
    
    func didClickAd(withTag tag: String!) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
    
    func didHideAd(withTag tag: String!) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
}

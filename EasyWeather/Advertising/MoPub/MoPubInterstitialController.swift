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
import MoPubSDK

class MoPubInterstitialController: InterstitialPlacement {
    
    var interstitial: MPInterstitialAdController!
    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withInterstitial interstitial: MPInterstitialAdController, withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.interstitial = interstitial
        self.interstitial.delegate = self
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .moPub)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        interstitial.loadAd()
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        interstitial.show(from: viewController)
    }
    
    override func isReady() -> Bool {
        return interstitial.ready
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension MoPubInterstitialController: MPInterstitialAdControllerDelegate {
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)

    }
    
    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()

    }
    
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
}

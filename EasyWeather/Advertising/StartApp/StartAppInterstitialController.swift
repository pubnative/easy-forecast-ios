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

class StartAppInterstitialController: InterstitialPlacement {

    var interstitial: STAStartAppAd!
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        interstitial = STAStartAppAd()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .startApp)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        interstitial.load(withDelegate: self)
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        interstitial.show()
    }
    
    override func isReady() -> Bool {
        return interstitial.isReady()
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}

extension StartAppInterstitialController: STADelegateProtocol {
    
    func didLoad(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func failedLoad(_ ad: STAAbstractAd!, withError error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func didShow(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func failedShow(_ ad: STAAbstractAd!, withError error: Error!) {
        adAnalyticsSession.confirmInterstitialShowError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func didClose(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
    
    func didClick(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
    
    func didClose(inAppStore ad: STAAbstractAd!) {
        
    }
    
    func didCompleteVideo(_ ad: STAAbstractAd!) {
        
    }
}

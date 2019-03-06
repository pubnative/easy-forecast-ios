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
import AppLovinSDK

class AppLovinInterstitialController: InterstitialPlacement {

    var ad: ALAd?
    var delegate: InterstitialPlacementDelegate?

    init(withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    override func loadAd() {
        ad = nil
        guard let sharedInstance = ALSdk.shared() else { return }
        sharedInstance.adService.loadNextAd(ALAdSize.sizeInterstitial(), andNotify: self)
    }
    
    override func show() {
        guard let ad = ad else { return }
        ALInterstitialAd.shared().adDisplayDelegate = self
        ALInterstitialAd.shared().adVideoPlaybackDelegate = self
        ALInterstitialAd.shared().showOver(UIApplication.shared.keyWindow!, andRender: ad)
    }
    
    override func isReady() -> Bool {
        guard ad != nil else { return false}
        return true
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension AppLovinInterstitialController: ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate {
    
    func videoPlaybackBegan(in ad: ALAd) {
        
    }
    
    func videoPlaybackEnded(in ad: ALAd, atPlaybackPercent percentPlayed: NSNumber, fullyWatched wasFullyWatched: Bool) {
        
    }
    
    
    func adService(_ adService: ALAdService, didLoad ad: ALAd) {
        self.ad = ad
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func adService(_ adService: ALAdService, didFailToLoadAdWithError code: Int32) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "AppLovin Interstitial did fail to load"])
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func ad(_ ad: ALAd, wasDisplayedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidShow()
        delegate.interstitialPlacementDidTrackImpression()
    }
    
    func ad(_ ad: ALAd, wasHiddenIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
    
    func ad(_ ad: ALAd, wasClickedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
    
}

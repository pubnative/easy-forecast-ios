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

class AppLovinRewardedVideoController: RewardedVideoPlacement {

    var delegate: RewardedVideoPlacementDelegate?
    
    init(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    override func loadAd() {
        ALIncentivizedInterstitialAd.preloadAndNotify(self)
    }
    
    override func show() {
        ALIncentivizedInterstitialAd.shared().adDisplayDelegate = self
        ALIncentivizedInterstitialAd.shared().adVideoPlaybackDelegate = self
        ALIncentivizedInterstitialAd.showAndNotify(self)
    }
    
    override func isReady() -> Bool {
        return ALIncentivizedInterstitialAd.shared().isReadyForDisplay
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension AppLovinRewardedVideoController: ALAdLoadDelegate, ALAdDisplayDelegate, ALAdRewardDelegate, ALAdVideoPlaybackDelegate {
    
    func adService(_ adService: ALAdService, didLoad ad: ALAd) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func adService(_ adService: ALAdService, didFailToLoadAdWithError code: Int32) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "AppLovin Rewarded Video did fail to load"])
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func ad(_ ad: ALAd, wasDisplayedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidOpen()
        delegate.rewardedVideoPlacementDidTrackImpression()
    }
    
    func ad(_ ad: ALAd, wasHiddenIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func ad(_ ad: ALAd, wasClickedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func rewardValidationRequest(for ad: ALAd, didSucceedWithResponse response: [AnyHashable : Any]) {
        guard let delegate = self.delegate else { return }
        let currencyName = response["currency"] as! String
        let amountGiven = response["amount"] as! String
        delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: currencyName, withAmount: 0))
    }
    
    func rewardValidationRequest(for ad: ALAd, didExceedQuotaWithResponse response: [AnyHashable : Any]) {
        
    }
    
    func rewardValidationRequest(for ad: ALAd, wasRejectedWithResponse response: [AnyHashable : Any]) {
        
    }
    
    func rewardValidationRequest(for ad: ALAd, didFailWithError responseCode: Int) {
        
    }
    
    func videoPlaybackBegan(in ad: ALAd) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidStart()
    }
    
    func videoPlaybackEnded(in ad: ALAd, atPlaybackPercent percentPlayed: NSNumber, fullyWatched wasFullyWatched: Bool) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
        if wasFullyWatched {
            
        }
    }
}

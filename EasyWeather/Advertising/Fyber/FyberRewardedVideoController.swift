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

class FyberRewardedVideoController: RewardedVideoPlacement {

    var viewController: UIViewController!
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .fyber)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        HZIncentivizedAd.fetch { (success, error) in
            if success {
                HZIncentivizedAd.setDelegate(self)
                guard let delegate = self.delegate else { return }
                delegate.rewardedVideoPlacementDidLoad()
            } else {
                guard let delegate = self.delegate else { return }
                let defaultError = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "Fyber Rewarded Video did fail to load"])
                delegate.rewardedVideoPlacementDidFail(withError: error ?? defaultError)
            }
        }
    }
    
    override func show() {
        let showOptions = HZShowOptions()
        showOptions.viewController = viewController
        HZIncentivizedAd.show(with: showOptions)
    }
    
    override func isReady() -> Bool {
        return HZIncentivizedAd.isAvailable()
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension FyberRewardedVideoController: HZIncentivizedAdDelegate {
    
    func didShowAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
    
    }
    
    func didFailToReceiveAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "Fyber Rewarded Video did fail to load"])
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func didFailToShowAd(withTag tag: String!, andError error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func didClickAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func didHideAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func didCompleteAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
        delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: "", withAmount: 0))
    }
    
    func didFailToCompleteAd(withTag tag: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
    }
}

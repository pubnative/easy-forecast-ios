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
import MoPub

class MoPubRewardedVideoController: RewardedVideoPlacement {

    var viewController: UIViewController!
    var delegate: RewardedVideoPlacementDelegate?

    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        MPRewardedVideo.setDelegate(self, forAdUnitId: MOPUB_REWARDED_VIDEO_AD_UNIT_ID)
        self.viewController = viewController
        self.delegate = delegate
    }
    
    override func loadAd() {
        MPRewardedVideo.loadAd(withAdUnitID: MOPUB_REWARDED_VIDEO_AD_UNIT_ID, withMediationSettings: nil)
    }
    
    override func show() {
        MPRewardedVideo.presentAd(forAdUnitID: MOPUB_REWARDED_VIDEO_AD_UNIT_ID, from: viewController, with:MPRewardedVideo.selectedReward(forAdUnitID: MOPUB_REWARDED_VIDEO_AD_UNIT_ID))
    }
    
    override func isReady() -> Bool {
        return MPRewardedVideo.hasAdAvailable(forAdUnitID: MOPUB_REWARDED_VIDEO_AD_UNIT_ID)
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}

extension MoPubRewardedVideoController: MPRewardedVideoDelegate {
    
    func rewardedVideoAdDidLoad(forAdUnitID adUnitID: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func rewardedVideoAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func rewardedVideoAdDidFailToPlay(forAdUnitID adUnitID: String!, error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func rewardedVideoAdWillAppear(forAdUnitID adUnitID: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidStart()
    }
    
    func rewardedVideoAdDidDisappear(forAdUnitID adUnitID: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func rewardedVideoAdDidReceiveTapEvent(forAdUnitID adUnitID: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func rewardedVideoAdShouldReward(forAdUnitID adUnitID: String!, reward: MPRewardedVideoReward!) {
        guard let delegate = self.delegate else { return }
        guard let reward = reward else { return }
        delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: reward.currencyType, withAmount: reward.amount as! Int))
    }
    
}

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

class UnityRewardedVideoController: RewardedVideoPlacement {

    var placementContent: UMONPlacementContent!
    var viewController: UIViewController!
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .unity)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
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

extension UnityRewardedVideoController: UnityMonetizationDelegate {
    
    func placementContentReady(_ placementId: String, placementContent decision: UMONPlacementContent) {
        guard let delegate = self.delegate else { return }
        if (placementId == UNITY_REWARDED_VIDEO_AD_UNIT_ID) {
            placementContent = decision
            delegate.rewardedVideoPlacementDidLoad()
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
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
}

extension UnityRewardedVideoController: UMONShowAdDelegate {
    
    func unityAdsDidStart(_ placementId: String!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackImpression()
        delegate.rewardedVideoPlacementDidStart()
    }
    
    func unityAdsDidFinish(_ placementId: String!, with finishState: UnityAdsFinishState) {
        guard let delegate = self.delegate else { return }
        if (finishState != .skipped && placementId == UNITY_REWARDED_VIDEO_AD_UNIT_ID) {
            delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: "", withAmount: 0))
        }
        delegate.rewardedVideoPlacementDidFinish()
    }
}

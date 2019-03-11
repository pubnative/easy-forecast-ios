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

    var viewController: UIViewController!
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    var isShown = false

    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        UnityAds.setDelegate(self)
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .unity)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        if (UnityAds.isReady(UNITY_REWARDED_VIDEO_AD_UNIT_ID)) {
            unityAdsReady(UNITY_REWARDED_VIDEO_AD_UNIT_ID)
        } else {
            unityAdsDidError(UnityAdsError(rawValue: 0)!, withMessage: "Error when loading the ad")
        }
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        UnityAds.show(viewController, placementId: UNITY_REWARDED_VIDEO_AD_UNIT_ID)
    }
    
    override func isReady() -> Bool {
        return UnityAds.isReady(UNITY_REWARDED_VIDEO_AD_UNIT_ID)
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension UnityRewardedVideoController: UnityAdsDelegate {
    
    func unityAdsReady(_ placementId: String) {
        if !isShown {
            isShown = true
            guard let delegate = self.delegate else { return }
            if (placementId == UNITY_REWARDED_VIDEO_AD_UNIT_ID) {
                adAnalyticsSession.confirmLoaded()
                delegate.rewardedVideoPlacementDidLoad()
            }
        }
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func unityAdsDidStart(_ placementId: String) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        adAnalyticsSession.confirmVideoStarted()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackImpression()
        delegate.rewardedVideoPlacementDidStart()

    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        adAnalyticsSession.confirmVideoFinished()
        guard let delegate = self.delegate else { return }
        if (state != .skipped && placementId == UNITY_REWARDED_VIDEO_AD_UNIT_ID) {
            adAnalyticsSession.confirmReward()
            delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: "", withAmount: 0))
        }
        delegate.rewardedVideoPlacementDidFinish()
    }
}

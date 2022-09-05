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
    private var isUnityAdReady = false
    
    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .unity)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        UnityAds.load(UNITY_REWARDED_VIDEO_AD_UNIT_ID, loadDelegate: self)
        if isUnityAdReady {
            unityAdsReady(UNITY_REWARDED_VIDEO_AD_UNIT_ID)
        } else {
            unityAdsDidError(UnityAdsInitializationError(rawValue: 0)!, withMessage: "Error when loading the ad")
        }
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        UnityAds.show(viewController, placementId: UNITY_REWARDED_VIDEO_AD_UNIT_ID, showDelegate: self)
    }
    
    override func isReady() -> Bool {
        return isUnityAdReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension UnityRewardedVideoController: UnityAdsInitializationDelegate, UnityAdsShowDelegate, UnityAdsLoadDelegate {
    
    func unityAdsAdLoaded(_ placementId: String) {
        isUnityAdReady = true
        unityAdsReady(placementId)
    }
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func initializationComplete() {
        isUnityAdReady = true
        unityAdsReady(UNITY_REWARDED_VIDEO_AD_UNIT_ID)
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        unityAdsDidError(error, withMessage: message)
    }
    
    func unityAdsShowStart(_ placementId: String) {
        unityAdsDidStart(placementId)
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        unityAdsDidFinish(placementId, with: state)
    }
    
    func unityAdsShowClick(_ placementId: String) {
        print("unityAdsShowClick - placementId \(placementId)")
    }
    
    // MARK: Custom methods
    
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
    
    func unityAdsDidError(_ error: UnityAdsInitializationError, withMessage message: String) {
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
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsShowCompletionState) {
        adAnalyticsSession.confirmVideoFinished()
        guard let delegate = self.delegate else { return }
        if (state != .showCompletionStateSkipped && placementId == UNITY_REWARDED_VIDEO_AD_UNIT_ID) {
            adAnalyticsSession.confirmReward()
            delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: "", withAmount: 0))
        }
        delegate.rewardedVideoPlacementDidFinish()
    }
}

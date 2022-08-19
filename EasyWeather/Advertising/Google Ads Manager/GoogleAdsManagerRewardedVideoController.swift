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
import GoogleMobileAds

class GoogleAdsManagerRewardedVideoController: RewardedVideoPlacement, UIViewController {
    
    var viewController: UIViewController!
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    private var rewardedAd: GADRewardedAd?

    init(withViewController viewController: UIViewController, withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        //GADRewardBasedVideoAd.sharedInstance().delegate = self
        self.viewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .googleAdsManager)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        //GADRewardBasedVideoAd.sharedInstance().load(DFPRequest(), withAdUnitID: GOOGLE_ADS_MANAGER_REWARDED_VIDEO_AD_UNIT_ID)
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: GOOGLE_ADS_MANAGER_REWARDED_VIDEO_AD_UNIT_ID,
                           request: request,
                           completionHandler: { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded.")
        }
        )
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        //GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: viewController)
        
        if let ad = rewardedAd {
            
            guard let vc = self as? UIViewController else {
                return
            }
            
            ad.present(fromRootViewController: vc) {
              let reward = ad.adReward
              print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
              // TODO: Reward the user.
            }
          } else {
            print("Ad wasn't ready")
          }
    }
    
    override func isReady() -> Bool {
        return GADRewardBasedVideoAd.sharedInstance().isReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}

extension GoogleAdsManagerRewardedVideoController: GADFullScreenContentDelegate {
    
    
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        adAnalyticsSession.confirmReward()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: reward.type, withAmount: reward.amount as! Int))
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidOpen()
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmVideoStarted()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidStart()
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmVideoFinished()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adAnalyticsSession.confirmClick()
        adAnalyticsSession.confirmLeftApplication()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
}


//
//  FyberRewardedVideoController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 31.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import FairBidSDK

class FyberRewardedVideoController: RewardedVideoPlacement {
    
    private var delegate: RewardedVideoPlacementDelegate?
    private var adAnalyticsSession: AdAnalyticsSession!
    private var placementId = FYBER_REWARDED_VIDEO_AD_UNIT_ID
    private var rewardedVideoIsReady = false
    
    init(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .fyber)
        FYBRewarded.delegate = self
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        FYBRewarded.request(placementId)
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        if (FYBRewarded.isAvailable(placementId)) {
            FYBRewarded.show(placementId)
        }
    }
    
    override func isReady() -> Bool {
        return rewardedVideoIsReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension FyberRewardedVideoController: FYBRewardedDelegate {
    
    func rewardedIsAvailable(_ placementName: String) {
        rewardedVideoIsReady = true
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func rewardedIsUnavailable(_ placementName: String) {
        rewardedVideoIsReady = false
    }
    
    func rewardedDidShow(_ placementName: String, impressionData: FYBImpressionData) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidOpen()
        delegate.rewardedVideoPlacementDidTrackImpression()
    }
    
    func rewardedDidFail(toShow placementName: String, withError error: Error, impressionData: FYBImpressionData) {
        adAnalyticsSession.confirmVideoError()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func rewardedDidClick(_ placementName: String) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func rewardedDidComplete(_ placementName: String, userRewarded: Bool) {
        adAnalyticsSession.confirmVideoIncomplete()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFinish()
    }
    
    func rewardedDidDismiss(_ placementName: String) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func rewardedWillRequest(_ placementId: String) {
        
    }
}

//
//  PubNativeRewardedVideoController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 25.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import HyBid

class PubNativeRewardedVideoController: RewardedVideoPlacement {
    
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    private var rewardedAd : HyBidRewardedAd!
    
    init(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate, zoneID: String) {
        super.init()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .pubnative)
        self.rewardedAd = HyBidRewardedAd(zoneID: zoneID, andWith: self)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        rewardedAd.load()
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        rewardedAd.show()
    }
    
    override func isReady() -> Bool {
        return rewardedAd.isReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension PubNativeRewardedVideoController: HyBidRewardedAdDelegate {
    
    func rewardedDidLoad() {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func rewardedDidFailWithError(_ error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func rewardedDidTrackImpression() {
        adAnalyticsSession.confirmImpression()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidOpen()
        delegate.rewardedVideoPlacementDidTrackImpression()
    }
    
    func rewardedDidTrackClick() {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func rewardedDidDismiss() {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func onReward() {
        adAnalyticsSession.confirmReward()
    }
}

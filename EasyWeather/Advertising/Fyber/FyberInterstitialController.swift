//
//  FyberInterstitialController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 31.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import FairBidSDK

class FyberInterstitialController: InterstitialPlacement {
    
    var delegate: InterstitialPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    private let placementId = FYBER_INTERSTITIAL_AD_UNIT_ID
    private var interstitalIsReady = false
    
    init(withAdPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        self.delegate = delegate
        FYBInterstitial.delegate = self
        adAnalyticsSession = AdAnalyticsSession(withAdType: .interstitial, withAdNetwork: .fyber)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        FYBInterstitial.request(placementId)
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        if (FYBInterstitial.isAvailable(placementId)) {
            FYBInterstitial.show(placementId)
        }
    }
    
    override func isReady() -> Bool {
        return interstitalIsReady
    }
    
    override func cleanUp() {
        delegate = nil
    }
}

extension FyberInterstitialController: FYBInterstitialDelegate {
    
    func interstitialIsAvailable(_ placementId: String) {
        interstitalIsReady = true
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func interstitialIsUnavailable(_ placementId: String) {
        interstitalIsReady = false
    }
    
    func interstitialDidShow(_ placementId: String, impressionData: FYBImpressionData) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func interstitialDidFail(toShow placementId: String, withError error: Error, impressionData: FYBImpressionData) {
        interstitalIsReady = false
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func interstitialDidClick(_ placementId: String) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
    
    func interstitialDidDismiss(_ placementId: String) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
    
    func interstitialWillRequest(_ placementId: String) {
    }
}

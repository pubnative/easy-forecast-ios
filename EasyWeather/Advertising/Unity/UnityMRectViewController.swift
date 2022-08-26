//
//  UnityMRectViewController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 26.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import UnityAds

class UnityMRectViewController: AdPlacement {

    private var unityMRectAdView = UADSBannerView(placementId: UNITY_BANNER_AD_UNIT_ID, size: CGSizeMake(320, 50))
    private var delegate: AdPlacementDelegate?
    private var adAnalyticsSession: AdAnalyticsSession!
    private var isShown = false

    init(withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        unityMRectAdView.removeFromSuperview()
        self.delegate = delegate
        unityMRectAdView.delegate = self
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .unity)
    }
    
    override func adView() -> UIView? {
        return unityMRectAdView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        unityMRectAdView.load()
    }
}

extension UnityMRectViewController: UADSBannerViewDelegate {
    
    func bannerViewDidLoad(_ bannerView: UADSBannerView!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
    }
    
    func unityAdsBannerDidError(_ message: String) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.adPlacementDidFail(withError: error)
    }
    
    func unityAdsBannerDidUnload(_ placementId: String) {
    
    }
    
    func unityAdsBannerDidShow(_ placementId: String) {
        if !isShown {
            isShown = true
            adAnalyticsSession.confirmImpression()
            guard let delegate = self.delegate else { return }
            delegate.adPlacementDidTrackImpression()
        }
    }
    
    func unityAdsBannerDidHide(_ placementId: String) {
        
    }
    
    func unityAdsBannerDidClick(_ placementId: String) {
        adAnalyticsSession.confirmClick()
        unityMRectAdView.removeFromSuperview()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
}

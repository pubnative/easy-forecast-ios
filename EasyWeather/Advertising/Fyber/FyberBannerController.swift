//
//  FyberBannerController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 30.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import FairBidSDK

class FyberBannerViewController: AdPlacement {

    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    private var fyberBannerView: FYBBannerAdView!
    private var bannerOptions = FYBBannerOptions()
    private var viewController: UIViewController!
    private let placementId = FYBER_BANNER_AD_UNIT_ID
    
    init(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .fyber)
        FYBBanner.delegate = self
        FYBBanner.destroy(placementId)
        bannerOptions.placementId = placementId
        bannerOptions.presentingViewController = viewController
        self.viewController = viewController
    }
    
    override func adView() -> UIView? {
        return fyberBannerView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        FYBBanner.show(in: viewController.view, position: .bottom, options: bannerOptions)
    }
}

extension FyberBannerViewController: FYBBannerDelegate {
    
    func bannerDidLoad(_ banner: FYBBannerAdView) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        fyberBannerView = banner
        delegate.adPlacementDidLoad()
    }
    
    func bannerDidFail(toLoad placementId: String, withError error: Error) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }
    
    func bannerDidShow(_ banner: FYBBannerAdView, impressionData: FYBImpressionData) {
        adAnalyticsSession.confirmImpression()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackImpression()
    }
    
    func bannerDidClick(_ banner: FYBBannerAdView){
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    func bannerWillPresentModalView(_ banner: FYBBannerAdView) {
        adAnalyticsSession.confirmOpened()
    }
    
    func bannerDidDismissModalView(_ banner: FYBBannerAdView) {
        adAnalyticsSession.confirmClosed()
    }
    
    func bannerWillLeaveApplication(_ banner: FYBBannerAdView) {
        adAnalyticsSession.confirmLeftApplication()
    }
    
    func banner(_ banner: FYBBannerAdView, didResizeToFrame frame: CGRect) {
        
    }
    
    func bannerWillRequest(_ placementId: String) {

    }
}

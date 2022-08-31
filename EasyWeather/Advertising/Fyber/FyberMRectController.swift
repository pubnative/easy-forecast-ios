//
//  FyberMRectController.swift
//  EasyWeather
//
//  Created by José Jacobo Contreras Trejo on 31.08.22.
//  Copyright © 2022 EasyNaps. All rights reserved.
//

import UIKit
import FairBidSDK


class FyberMRectController: AdPlacement {
    
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    private var fyberMRectView: FYBBannerAdView!
    private var mRectOptions = FYBBannerOptions()
    private var viewController: UIViewController!
    private let placementId = FYBER_MRECT_AD_UNIT_ID
    
    init(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .mRect, withAdNetwork: .fyber)
        FYBBanner.delegate = self
        FYBBanner.destroy(placementId)
        mRectOptions.placementId = placementId
        mRectOptions.presentingViewController = viewController
        self.viewController = viewController
        
    }
    
    override func adView() -> UIView? {
        return fyberMRectView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        FYBBanner.show(in: viewController.view, position: .top, options: mRectOptions)
    }

}

extension FyberMRectController: FYBBannerDelegate {
    
    func bannerDidLoad(_ banner: FYBBannerAdView) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        fyberMRectView = banner
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

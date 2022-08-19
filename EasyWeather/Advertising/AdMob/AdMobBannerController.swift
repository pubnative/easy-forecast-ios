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

class AdMobBannerController: AdPlacement {

    var bannerAdView: GADBannerView!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withAdView adView: GADBannerView, withAdUnitID adUnitID: String, withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        bannerAdView = adView
        bannerAdView.adUnitID = adUnitID
        bannerAdView.delegate = self
        bannerAdView.rootViewController = viewController
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .admob)
    }
    
    override func adView() -> UIView? {
        return bannerAdView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        bannerAdView.load(GADRequest())
    }
}

extension AdMobBannerController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        adAnalyticsSession.confirmOpened()
        print("adViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        adAnalyticsSession.confirmClosed()
        print("adViewDidDismissScreen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        adAnalyticsSession.confirmClick()
        adAnalyticsSession.confirmLeftApplication()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
}

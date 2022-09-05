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

class IronSourceBannerController: AdPlacement {
    
    var bannerAdView: ISBannerView!
    var viewController: UIViewController!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    
    init(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
        IronSource.setBannerDelegate(self)
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .ironSource)
    }
    
    override func adView() -> UIView? {
        return bannerAdView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        IronSource.loadBanner(with: viewController, size: ISBannerSize(width: 320, andHeight: 50), placement: IRONSOURCE_BANNER_AD_UNIT_ID)
    }
    
}

extension IronSourceBannerController: ISBannerDelegate {
    
    func bannerDidLoad(_ bannerView: ISBannerView!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        bannerAdView = bannerView
        delegate.adPlacementDidLoad()
    }
    
    func bannerDidFailToLoadWithError(_ error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }
    
    func didClickBanner() {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    func bannerWillPresentScreen() {
        adAnalyticsSession.confirmOpened()
    }
    
    func bannerDidDismissScreen() {
        adAnalyticsSession.confirmClosed()
    }
    
    func bannerWillLeaveApplication() {
        adAnalyticsSession.confirmLeftApplication()
    }
    
    func bannerDidShow() {
    }
    
}

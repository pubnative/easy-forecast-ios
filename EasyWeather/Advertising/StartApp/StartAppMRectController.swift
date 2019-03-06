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

class StartAppMRectController: AdPlacement {

    var mRectAdView: STABannerView!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.delegate = delegate
        let summaryViewController = viewController as! SearchCityViewController
        mRectAdView = STABannerView(size: STA_MRecAdSize_300x250, autoOrigin: STAAdOrigin_Top, with: summaryViewController.mRectContainerView, withDelegate: self)
        adAnalyticsSession = AdAnalyticsSession(withAdType: .mRect, withAdNetwork: .startApp)
    }
    
    override func adView() -> UIView? {
        return mRectAdView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        
    }
}

extension StartAppMRectController: STABannerDelegateProtocol {
    
    func didDisplayBannerAd(_ banner: STABannerView!) {
        // Loads new ad when user clicks every time
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
        delegate.adPlacementDidTrackImpression()
    }
    
    func failedLoadBannerAd(_ banner: STABannerView!, withError error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }
    
    func didClickBannerAd(_ banner: STABannerView!) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    func didCloseBanner(inAppStore banner: STABannerView!) {
        
    }
    
}

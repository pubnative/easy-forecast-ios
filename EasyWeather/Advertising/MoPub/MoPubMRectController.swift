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
import MoPubSDK

class MoPubMRectController: AdPlacement {

    var mRectAdView: MPAdView!
    var viewController: UIViewController!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withAdView adView: MPAdView, withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.viewController = viewController
        mRectAdView = adView
        mRectAdView.delegate = self
        mRectAdView.stopAutomaticallyRefreshingContents()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .mRect, withAdNetwork: .moPub)
    }
    
    override func adView() -> UIView? {
        return mRectAdView
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        mRectAdView.loadAd()
    }
}

extension MoPubMRectController: MPAdViewDelegate {
    
    func adViewDidLoadAd(_ view: MPAdView!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "MoPub MRect did fail to load"])
        delegate.adPlacementDidFail(withError: error)
    }
    
    func willPresentModalView(forAd view: MPAdView!) {
        adAnalyticsSession.confirmClick()
        adAnalyticsSession.confirmOpened()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    func didDismissModalView(forAd view: MPAdView!) {
        adAnalyticsSession.confirmClosed()
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return viewController
    }
    
}

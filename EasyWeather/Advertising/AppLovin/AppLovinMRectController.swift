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
import AppLovinSDK

class AppLovinMRectController: AdPlacement {

    var mRectAdView: ALAdView!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withAdView adView: ALAdView, adPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        mRectAdView = adView
        mRectAdView.adLoadDelegate = self
        mRectAdView.adDisplayDelegate = self
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .mRect, withAdNetwork: .appLovin)
    }
    
    override func adView() -> UIView? {
        return mRectAdView
    }
    
    override func loadAd() {
        mRectAdView.loadNextAd()
    }
}

extension AppLovinMRectController: ALAdLoadDelegate, ALAdDisplayDelegate {
    
    func ad(_ ad: ALAd, wasDisplayedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackImpression()
    }
    
    func ad(_ ad: ALAd, wasHiddenIn view: UIView) {
        
    }
    
    func ad(_ ad: ALAd, wasClickedIn view: UIView) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    
    func adService(_ adService: ALAdService, didLoad ad: ALAd) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
    }
    
    func adService(_ adService: ALAdService, didFailToLoadAdWithError code: Int32) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "AppLovin MRect did fail to load"])
        delegate.adPlacementDidFail(withError: error)
    }
    
}

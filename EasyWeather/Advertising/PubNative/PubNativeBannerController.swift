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
import HyBid
import Audiences

class PubNativeBannerController: AdPlacement {
    
    var bannerAdView: HyBidAdView!
    var zoneID: String!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    
    init(withAdView adView: HyBidAdView, withZoneID zoneID: String, adPlacementDelegate delegate: AdPlacementDelegate) {
        self.bannerAdView = adView
        self.zoneID = zoneID
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .pubnative)
    }
    
    override func adView() -> UIView? {
        return bannerAdView
    }
    
    override func loadAd() {
        let hyBidTargeting = HyBidTargetingModel()
        let interests = [String]()
        hyBidTargeting.interests = interests
        hyBidTargeting.interests.append("easyforecast:2.12")

        let audiences = Audiences.currentMemberships
        hyBidTargeting.interests.append(audiences.joined(separator: ","))
        
        HyBid.setTargeting(hyBidTargeting)
        
        adAnalyticsSession.start()
        bannerAdView.load(withZoneID: zoneID, andWith: self)
    }

}

extension PubNativeBannerController: HyBidAdViewDelegate {
    
    func adViewDidLoad(_ adView: HyBidAdView!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidLoad()
    }
    
    func adView(_ adView: HyBidAdView!, didFailWithError error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }
    
    func adViewDidTrackImpression(_ adView: HyBidAdView!) {
        adAnalyticsSession.confirmImpression()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackImpression()
    }
    
    func adViewDidTrackClick(_ adView: HyBidAdView!) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
}

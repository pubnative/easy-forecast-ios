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
import UnityAds

class UnityBannerController: AdPlacement {

    var bannerAdView: UIView!
    var delegate: AdPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!

    init(withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        UnityAdsBanner.destroy()
        UnityAdsBanner.setDelegate(self)
        UnityAdsBanner.setBannerPosition(.center)
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .banner, withAdNetwork: .unity)
    }
    
    override func adView() -> UIView? {
        return bannerAdView
    }
    
    override func loadAd() {
        if (UnityAds.isReady(UNITY_BANNER_AD_UNIT_ID)) {
            UnityAdsBanner.load(UNITY_BANNER_AD_UNIT_ID)
        }
    }
}

extension UnityBannerController: UnityAdsBannerDelegate {
    
    func unityAdsBannerDidLoad(_ placementId: String, view: UIView) {
        guard let delegate = self.delegate else { return }
        bannerAdView = view
        delegate.adPlacementDidLoad()
    }
    
    func unityAdsBannerDidError(_ message: String) {
        guard let delegate = self.delegate else { return }
        let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
        delegate.adPlacementDidFail(withError: error)
    }
    
    func unityAdsBannerDidUnload(_ placementId: String) {
        
    }
    
    func unityAdsBannerDidShow(_ placementId: String) {
        //Called everytime?
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackImpression()
    }
    
    func unityAdsBannerDidHide(_ placementId: String) {
    }
    
    func unityAdsBannerDidClick(_ placementId: String) {
        UnityAdsBanner.destroy()
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    
    
}

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

class FyberBannerController: AdPlacement {
    
    var bannerAdView: HZBannerAd!
    var viewController: UIViewController!
    var delegate: AdPlacementDelegate?
    
    init(withViewController viewController: UIViewController, withAdPlacementDelegate delegate: AdPlacementDelegate) {
        super.init()
        self.viewController = viewController
        self.delegate = delegate
    }
    
    override func adView() -> UIView? {
        return bannerAdView
    }
    
    override func loadAd() {
        let bannerOptions = HZBannerAdOptions()
        bannerOptions.presentingViewController = viewController
        HZBannerAd.requestBanner(with: bannerOptions, success: { (bannerAdView) in
            self.bannerAdView = bannerAdView
            self.bannerAdView.delegate = self
            guard let delegate = self.delegate else { return }
            delegate.adPlacementDidLoad()
        }) { (error) in
            guard let delegate = self.delegate else { return }
            let defaultError = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "Fyber Banner did fail to load"])
            delegate.adPlacementDidFail(withError: error ?? defaultError)
        }
    }

}

extension FyberBannerController: HZBannerAdDelegate {
    
    func bannerDidReceive(_ banner: HZBannerAd!) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackImpression()
    }
    
    func bannerDidFail(toReceive banner: HZBannerAd!, error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidFail(withError: error)
    }
    
    func bannerWasClicked(_ banner: HZBannerAd!) {
        guard let delegate = self.delegate else { return }
        delegate.adPlacementDidTrackClick()
    }
    
    func bannerWillPresentModalView(_ banner: HZBannerAd!) {
        
    }
    
    func bannerDidDismissModalView(_ banner: HZBannerAd!) {
        
    }
    
    func bannerWillLeaveApplication(_ banner: HZBannerAd!) {
        
    }
}

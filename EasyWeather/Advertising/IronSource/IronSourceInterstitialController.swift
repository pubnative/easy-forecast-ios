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

class IronSourceInterstitialController: InterstitialPlacement {

    var viewController: UIViewController!
    var delegate: InterstitialPlacementDelegate?
    
    init(withViewController viewController: UIViewController, withInterstitialPlacementDelegate delegate: InterstitialPlacementDelegate) {
        super.init()
        IronSource.setInterstitialDelegate(self)
        self.viewController = viewController
        self.delegate = delegate
    }

    override func loadAd() {
        IronSource.loadInterstitial()
    }
    
    override func show() {
        IronSource.showInterstitial(with: viewController, placement: IRONSOURCE_INTERSTITIAL_AD_UNIT_ID)
    }
    
    override func isReady() -> Bool {
        return IronSource.hasInterstitial()
    }
}

extension IronSourceInterstitialController: ISInterstitialDelegate {
    
    func interstitialDidLoad() {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidLoad()
    }
    
    func interstitialDidFailToLoadWithError(_ error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func interstitialDidOpen() {
        
    }
    
    func interstitialDidClose() {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidDismissed()
    }
    
    func interstitialDidShow() {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackImpression()
        delegate.interstitialPlacementDidShow()
    }
    
    func interstitialDidFailToShowWithError(_ error: Error!) {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidFail(withError: error)
    }
    
    func didClickInterstitial() {
        guard let delegate = self.delegate else { return }
        delegate.interstitialPlacementDidTrackClick()
    }
    
    
}

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

     var mRectAdView: MAAdView!
     var delegate: AdPlacementDelegate?
     var adAnalyticsSession: AdAnalyticsSession!

     init(withAdView adView: ALAdView, adPlacementDelegate delegate: AdPlacementDelegate) {
         super.init()
         mRectAdView = MAAdView(adUnitIdentifier: MRECT_PLACEMENT, adFormat: .mrec)
         mRectAdView.delegate = self
         
         let height: CGFloat = adView.frame.height
         let width: CGFloat = adView.frame.width
         
         mRectAdView.frame = CGRect(x: adView.frame.origin.x, y: adView.frame.origin.y, width: width, height: height)
         mRectAdView.center.x = adView.center.x
         adView.addSubview(mRectAdView)
         
         self.delegate = delegate
         adAnalyticsSession = AdAnalyticsSession(withAdType: .mRect, withAdNetwork: .appLovin)
     }
     
     override func adView() -> UIView? {
         return mRectAdView
     }
     
     override func loadAd() {
         adAnalyticsSession.start()
         mRectAdView.loadAd()
     }
 }

 extension AppLovinMRectController: MAAdViewAdDelegate {
     
     func didExpand(_ ad: MAAd) {
         
     }
     
     func didCollapse(_ ad: MAAd) {
         
     }
     
     func didLoad(_ ad: MAAd) {
         adAnalyticsSession.confirmLoaded()
         guard let delegate = self.delegate else { return }
         delegate.adPlacementDidLoad()
     }
     
     func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
         adAnalyticsSession.confirmError()
         guard let delegate = self.delegate else { return }
         let error = NSError(domain: "EasyForecast", code: 0, userInfo: [NSLocalizedDescriptionKey : "AppLovin MRect did fail to load"])
         delegate.adPlacementDidFail(withError: error)
     }
     
     func didDisplay(_ ad: MAAd) {
         adAnalyticsSession.confirmImpression()
         guard let delegate = self.delegate else { return }
         delegate.adPlacementDidTrackImpression()
     }
     
     func didHide(_ ad: MAAd) {
         
     }
     
     func didClick(_ ad: MAAd) {
         adAnalyticsSession.confirmClick()
         guard let delegate = self.delegate else { return }
         delegate.adPlacementDidTrackClick()
     }
     
     func didFail(toDisplay ad: MAAd, withError error: MAError) {

     }
     
     
 }


 

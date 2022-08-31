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

class StartAppRewardedVideoController: RewardedVideoPlacement {
    
    var rewardedVideo: STAStartAppAd!
    var delegate: RewardedVideoPlacementDelegate?
    var adAnalyticsSession: AdAnalyticsSession!
    
    init(withRewardedVideoPlacementDelegate delegate: RewardedVideoPlacementDelegate) {
        super.init()
        rewardedVideo = STAStartAppAd()
        self.delegate = delegate
        adAnalyticsSession = AdAnalyticsSession(withAdType: .rewardedVideo, withAdNetwork: .startApp)
    }
    
    override func loadAd() {
        adAnalyticsSession.start()
        rewardedVideo.loadRewardedVideoAd(withDelegate: self)
    }
    
    override func show() {
        adAnalyticsSession.confirmInterstitialShow()
        rewardedVideo.show()
    }
    
    override func isReady() -> Bool {
        return rewardedVideo.isReady()
    }
    
    override func cleanUp() {
        delegate = nil
    }
    
}


extension StartAppRewardedVideoController: STADelegateProtocol {
    
    func didLoad(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmLoaded()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidLoad()
    }
    
    func failedLoad(_ ad: STAAbstractAd!, withError error: Error!) {
        adAnalyticsSession.confirmError()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func didShow(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmImpression()
        adAnalyticsSession.confirmInterstitialShown()
    }
    
    func failedShow(_ ad: STAAbstractAd!, withError error: Error!) {
        adAnalyticsSession.confirmInterstitialShowError()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidFail(withError: error)
    }
    
    func didClose(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmInterstitialDismissed()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func didClick(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmClick()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidTrackClick()
    }
    
    func didClose(inAppStore ad: STAAbstractAd!) {
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidClose()
    }
    
    func didCompleteVideo(_ ad: STAAbstractAd!) {
        adAnalyticsSession.confirmVideoFinished()
        adAnalyticsSession.confirmReward()
        guard let delegate = self.delegate else { return }
        delegate.rewardedVideoPlacementDidReward(withReward: AdReward(withName: "", withAmount: 0))
    }
}

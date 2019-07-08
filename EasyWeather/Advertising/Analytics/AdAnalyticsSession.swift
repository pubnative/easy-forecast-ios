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

import Foundation

class AdAnalyticsSession {
    public private (set) var adAnalytics: AdAnalytics
    public private (set) var adType: AdType
    public private (set) var adNetwork: AdNetwork
    public private (set) var initialTime : Int = 0
    
    init(withAdType adType: AdType, withAdNetwork adNetwork: AdNetwork) {
        adAnalytics = AdAnalytics.sharedInstance
        self.adType = adType
        self.adNetwork = adNetwork
    }
    
    func start() {
        initialTime = Int(Date().timeIntervalSince1970 * 1000)
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_START_LOADING, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: 0))
    }

    func confirmLoaded() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_LOADED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmError() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_LOAD_ERROR, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmImpression() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_IMPRESSION, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmClick() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_CLICK, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmOpened() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_OPENED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmClosed() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_CLOSED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmLeftApplication() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_LEFT_APP, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmInterstitialShow() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_INTERSTITIAL_SHOW, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmInterstitialShown() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_INTERSTITIAL_SHOWN, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmInterstitialShowError() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_INTERSTITIAL_SHOW_ERROR, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmInterstitialDismissed() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_INTERSTITIAL_DISMISSED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmAudioStarted() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_AUDIO_STARTED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmAudioFinished() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_AUDIO_FINISHED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmVideoStarted() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_VIDEO_STARTED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmVideoIncomplete() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_VIDEO_INCOMPLETE, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmVideoFinished() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_VIDEO_FINISHED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmVideoError() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_VIDEO_ERROR, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmReward() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_REWARD, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmRewardRejected() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_REWARD_REJECTED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmUserOverQuota() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_USER_OVER_QUOTA, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmDeclinedToViewAd() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_DECLINED_TO_VIEW_AD, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func confirmValidationRequestFailed() {
        adAnalytics.sendEvent(event: AdEvent(withName: EVENT_VALIDATION_REQUEST_FAILED, withType: adType, withAdNetworkName: adNetwork, withElapsedTimeInMilliseconds: getElapsedTime()))
    }
    
    func getElapsedTime() -> Int {
        return Int(Date().timeIntervalSince1970 * 1000) - initialTime
    }

}

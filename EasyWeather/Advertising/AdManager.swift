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

class AdManager {
    
    private var networkDictionary : [String : Queue<AdNetwork>]!
    static let sharedInstance = AdManager()
    
    init() {
        networkDictionary = [String : Queue<AdNetwork>]()
        setupQueues()
    }
    
    func getNextNetwork(withPlacement placement: String) -> AdNetwork? {
        if placement.isEmpty || networkDictionary[placement] == nil {
            return nil
        } else {
            guard var queue = networkDictionary[placement] else { return nil }
            guard let nextAdNetwork = queue.dequeue() else { return nil }
            queue.enqueue(nextAdNetwork)
            networkDictionary.updateValue(queue, forKey: placement)
            return nextAdNetwork
        }
    }
    
    fileprivate func setupQueues() {
        setupBannerQueue()
        setupMRectQueue()
        setupInterstitialQueue()
        setupRewardedVideoQueue()
    }
    
    fileprivate func setupBannerQueue() {
        var queue = Queue<AdNetwork>()
        queue.enqueue(.pubnative)
        queue.enqueue(.appLovin)
        queue.enqueue(.ironSource)
        queue.enqueue(.fyber)
        queue.enqueue(.facebook)
        queue.enqueue(.moPub)
        queue.enqueue(.googleAdsManager)
        queue.enqueue(.admob)
        queue.enqueue(.startApp)
        queue.enqueue(.unity)
        
        networkDictionary.updateValue(queue, forKey: BANNER_PLACEMENT)
    }
    
    fileprivate func setupMRectQueue() {
        var queue = Queue<AdNetwork>()
        queue.enqueue(.pubnative)
        queue.enqueue(.appLovin)
        queue.enqueue(.ironSource)
//        queue.enqueue(.fyber)
        queue.enqueue(.facebook)
        queue.enqueue(.moPub)
        queue.enqueue(.googleAdsManager)
        queue.enqueue(.admob)
        queue.enqueue(.startApp)
//        queue.enqueue(.unity)
        
        networkDictionary.updateValue(queue, forKey: MRECT_PLACEMENT)
    }
    
    fileprivate func setupInterstitialQueue() {
        var queue = Queue<AdNetwork>()
        queue.enqueue(.pubnative)
        queue.enqueue(.appLovin)
        queue.enqueue(.ironSource)
        queue.enqueue(.fyber)
        queue.enqueue(.facebook)
        queue.enqueue(.moPub)
        queue.enqueue(.googleAdsManager)
        queue.enqueue(.admob)
        queue.enqueue(.startApp)
        queue.enqueue(.unity)
        
        networkDictionary.updateValue(queue, forKey: INTERSTITIAL_PLACEMENT)
    }
    
    fileprivate func setupRewardedVideoQueue() {
        var queue = Queue<AdNetwork>()
//        queue.enqueue(.pubnative)
        queue.enqueue(.appLovin)
        queue.enqueue(.ironSource)
        queue.enqueue(.fyber)
        queue.enqueue(.facebook)
        queue.enqueue(.moPub)
        queue.enqueue(.googleAdsManager)
        queue.enqueue(.admob)
        queue.enqueue(.startApp)
        queue.enqueue(.unity)
        
        networkDictionary.updateValue(queue, forKey: REWARDED_VIDEO_PLACEMENT)
    }
    
}

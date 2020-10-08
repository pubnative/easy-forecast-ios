//
//  Copyright © 2018 EasyNaps. All rights reserved.
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
import CoreData
import Firebase
import HyBid
import MoPub
import GoogleMobileAds
import AdSupport.ASIdentifierManager
import UnityAds
import AppLovinSDK
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 11.3, *) {
            SKAdNetwork.registerAppForAdNetworkAttribution()
        }
        
        saveCityListToUserDefaults()
        
        FirebaseApp.configure()
        
        HyBid.initWithAppToken(PUBNATIVE_APP_TOKEN) { (success) in
            if (success) {
                HyBidLogger.setLogLevel(HyBidLogLevelDebug)
                print("HyBid Successfully Initialized")
                self.askForConsent()
            }
        }
        HyBid.setCoppa(false)
        HyBid.setTestMode(false)
        HyBid.setAppStoreAppID("1382171002")
        
        let hyBidTargeting = HyBidTargetingModel()
        let interests = [String]()
        hyBidTargeting.interests = interests
        hyBidTargeting.interests.append("easyforecast:2.11")
        HyBid.setTargeting(hyBidTargeting)
        
        let moPubSDKConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUB_BANNER_AD_UNIT_ID)
        MoPub.sharedInstance().initializeSdk(with: moPubSDKConfig, completion: nil)
        
        GADMobileAds.configure(withApplicationID: ADMOB_APP_ID)

        UnityAds.initialize(UNITY_GAME_ID, delegate: nil, testMode: false)
        
        IronSource.initWithAppKey(IRONSOURCE_APPKEY)
        
        if let startAppSDK = STAStartAppSDK.sharedInstance() {
            startAppSDK.appID = STARTAPP_APP_ID
        }
        
        ALSdk.initializeSdk()
        
        return true
    }
    
    func askForConsent()
    {
        if !HyBidUserDataManager.sharedInstance().canCollectData() {
            if(UserDefaults.standard.object(forKey: "ConsentCheckDate") == nil) {
                showConsentAndSaveParameters()
            } else {
                if(UserDefaults.standard.object(forKey: "IDFA") != nil) {
                    let idfa = UserDefaults.standard.object(forKey: "IDFA") as! String
                    if (idfa == HyBidSettings.sharedInstance()?.advertisingId){
                        let consentCheckDate = UserDefaults.standard.object(forKey: "ConsentCheckDate") as? Date
                        let components = Calendar.current.dateComponents([.day], from: consentCheckDate!, to: Date())
                        if (components.day! >= 31) {
                            showConsentAndSaveParameters()
                        }
                    } else {
                        showConsentAndSaveParameters()
                    }
                }
            }
        }
    }
    
    
    func showConsentAndSaveParameters()
    {
        HyBidUserDataManager.sharedInstance()?.loadConsentPage(completion: { (loadError) in
            if (loadError == nil) {
                HyBidUserDataManager.sharedInstance()?.showConsentPage({
          
                }, didDismiss: {
                    UserDefaults.standard.set(Date(), forKey: "ConsentCheckDate")
                    UserDefaults.standard.set(self.identifierForAdvertising(), forKey: "IDFA")
                })
            }
        })
    }
    
    func identifierForAdvertising() -> String?
    {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let sessionManager = HyBidSessionManager()
        sessionManager.openSession()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}


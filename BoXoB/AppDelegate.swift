//
//  AppDelegate.swift
//  BoXoB
//
//  Created by apple on 19/10/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import FBSDKCoreKit
import AppsFlyerLib

typealias productsLoaded = ( ) -> Void
typealias imageDownloadSuccess = (UIImage)->Void


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var productFor100Coins : SKProduct?
    var productFor200Coins : SKProduct?
    var productFor500Coins : SKProduct?
    var productFor800Coins : SKProduct?
    var productFor1000Coins : SKProduct?
    var productFor2000Coins : SKProduct?
    var productPro : SKProduct?
    var productsLoaded : productsLoaded?
    var imageDownloadSuccess : imageDownloadSuccess?

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        AppsFlyerLib.shared().appsFlyerDevKey = "MMPGQmyEvzT2CdxqkkNGjg"
                AppsFlyerLib.shared().appleAppID = "id255155515"
                AppsFlyerLib.shared().delegate = self
                AppsFlyerLib.shared().isDebug = true
                // iOS 10 or later
                if #available(iOS 10, *) {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
                    application.registerForRemoteNotifications()
                }
                // iOS 9 support - Given for reference. This demo app supports iOS 13 and above
                else {
                    application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                    application.registerForRemoteNotifications()
                }
                return true
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        SwiftyStoreKit.setupIAP()
        loadProducts()
        
        let defaultHintsAvailable = UserDefaults.standard.bool(forKey: "defaultHintsAvailable")
        
        if defaultHintsAvailable != true{
            UserDefaults.standard.set(true, forKey: "defaultHintsAvailable")
            UserDefaults.standard.set(50, forKey: "coins")

            UserDefaults.standard.synchronize()
        }
            
        registerForPushNotifications()
//        UserDefaults.standard.set(true, forKey: InAppPurchaseIds.proVersionId)
//        UserDefaults.standard.synchronize()
                
        // Override point for customization after application launch.
        return true
    }
    
    override init() {
       super.init()
        FirebaseApp.configure()
       // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func loadProducts(){
        SwiftyStoreKit.retrieveProductsInfo([InAppPurchaseIds.points100,InAppPurchaseIds.points200,InAppPurchaseIds.points500,InAppPurchaseIds.points800,InAppPurchaseIds.points1000,InAppPurchaseIds.points2000,InAppPurchaseIds.proVersionId]) { result in
            DispatchQueue.main.async {
                if result.retrievedProducts.count > 0{
                    for product in result.retrievedProducts{
                        switch product.productIdentifier {
                        case InAppPurchaseIds.points100:
                            self.productFor100Coins = product
                        case InAppPurchaseIds.points200:
                            self.productFor200Coins = product
                        case InAppPurchaseIds.points500:
                            self.productFor500Coins = product
                        case InAppPurchaseIds.points800:
                            self.productFor800Coins = product
                        case InAppPurchaseIds.points1000:
                            self.productFor1000Coins = product
                        case InAppPurchaseIds.points2000:
                            self.productFor2000Coins = product
                        case InAppPurchaseIds.proVersionId:
                            self.productPro = product
                        default:
                            print("default")
                        }
                    }
                    
                    if let productsLoaded = self.productsLoaded{
                        productsLoaded()
                    }
                }
            }
        }
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
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        AppsFlyerLib.shared().start()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
         print(" user info \(userInfo)")
         AppsFlyerLib.shared().handlePushNotification(userInfo)
     }
     // Open Deeplinks
     // Open URI-scheme for iOS 8 and below
     private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
         AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
         return true
     }
     // Open URI-scheme for iOS 9 and above
     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
         return true
     }
     // Report Push Notification attribution data for re-engagements
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         AppsFlyerLib.shared().handlePushNotification(userInfo)
     }
     // Reports app open from deep link for iOS 10 or later
     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
         AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
         return true
     }

    @objc public func downloadImage(levelNumber: Int, success:@escaping imageDownloadSuccess){
        if levelNumber > 150{
            return
        }
        let storageRef = Storage.storage()
        let imageRef = storageRef.reference(withPath: "\(levelNumber).png")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                
                UserDefaults.standard.set(levelNumber, forKey: "lastLevelImageDownloaded")
                UserDefaults.standard.synchronize()
                
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                image?.saveToDocuments(filename: levelNumber)
                success(image!)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}

//MARK: AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate{
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                    let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
                is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}

extension UIImage {
    func saveToDocuments(filename:Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(filename)")
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
}

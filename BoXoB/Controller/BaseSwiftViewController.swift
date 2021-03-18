//
//  BaseSwiftViewController.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit
import Firebase

class BaseSwiftViewController: UIViewController {
    @IBOutlet weak var pointsCount : UILabel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let oldCoins = UserDefaults.standard.integer(forKey: "coins")
        pointsCount?.text = "\(oldCoins)"
        
        synImages()
    }
    
    @IBAction func buyPointsBtnClicked() {
        let isPro = UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId)
        if isPro == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: "BuyCoinsViewController") as! BuyCoinsViewController
            self.navigationController?.pushFadeViewController(viewController)
        }
    }
    
    func purchase(stage: String)  {
        view.showHUD(progressLabel: "Loading")
        
        SwiftyStoreKit.purchaseProduct(stage, quantity: 1, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let _):
                self.view.dismissHUD(isAnimated: true)
                self.showMessage1(message: "Game Unlocked!", header: "Congratulation")

            case .error(let error):
                switch error.code {
                case .unknown: self.showMessage1(message: "Unknown error. Please try again later", header: "Error!")
                case .clientInvalid: self.showMessage1(message:"Not allowed to make the payment", header: "Error!")
                case .paymentCancelled: self.showMessage1(message:"Payment Canceled", header: "Error!")
                case .paymentInvalid: self.showMessage1(message:"The purchase identifier was invalid", header: "Error!")
                case .paymentNotAllowed: self.showMessage(message:"The device is not allowed to make the payment", header: "Error!")
                case .storeProductNotAvailable: self.showMessage1(message:"The product is not available in the current storefront", header: "Error!")
                case .cloudServicePermissionDenied: self.showMessage1(message:"Access to cloud service information is not allowed", header: "Error!")
                case .cloudServiceNetworkConnectionFailed: self.showMessage1(message:"Could not connect to the network", header: "Error!")
                case .cloudServiceRevoked: self.showMessage1(message:"User has revoked permission to use this cloud service", header: "Error!")
                default:
                    self.showMessage1(message: "Unknown error. Please try again later", header: "Error!")
                }
            }
        }
    }
    
    func showMessage1(message: String, header:String)  {
        DispatchQueue.main.async {
            self.view.dismissHUD(isAnimated: true)
            let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                self.levelUnlocked()
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func levelUnlocked() {
        
    }
    
    func synImages()  {
        var lastLevelImageDownloaded = UserDefaults.standard.integer(forKey: "lastLevelImageDownloaded")
        if lastLevelImageDownloaded < 26{
            lastLevelImageDownloaded = 26
        }
        if lastLevelImageDownloaded < 250{
            let levelNumber = lastLevelImageDownloaded + 1
            
            if let image = UIImage(named: String(levelNumber )){
                self.synImages()
                UserDefaults.standard.set(levelNumber, forKey: "lastLevelImageDownloaded")
                UserDefaults.standard.synchronize()
            }
            else{
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
                        self.synImages()
                    }
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

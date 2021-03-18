//
//  BuyVIPViewController.swift
//  PicCross
//
//  Created by apple on 14/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class BuyVIPViewController: UIViewController {
    var productPro : SKProduct?
    @IBOutlet weak var proPrice: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if appDelegate.productPro == nil{
            SwiftyStoreKit.retrieveProductsInfo([InAppPurchaseIds.proVersionId]) { result in
                DispatchQueue.main.async {
                    if result.retrievedProducts.count > 0{
                        for product in result.retrievedProducts{
                            switch product.productIdentifier {
                            
                            case InAppPurchaseIds.proVersionId:
                                self.productPro = product
                                self.proPrice.text = "Buy pro (\(self.productPro?.localizedPrice ?? ""))" 

                            default:
                                print("default")
                            }
                        }
                    }
                }
            }
        }
        else{
            self.proPrice.text = "Buy pro (\(appDelegate.productPro?.localizedPrice ?? ""))"
        }
        
        appDelegate.productsLoaded = {
            self.proPrice.text = "Buy pro (\(appDelegate.productPro?.localizedPrice ?? ""))"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func buyVIP(){
        purchse(productInAppId: InAppPurchaseIds.proVersionId)
    }
    
    @IBAction func restoreVIP(){
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Loading"
        
        SwiftyStoreKit.restorePurchases { (result) in
            DispatchQueue.main.async {
                progressHUD?.hide(true)
            }
            
            for purchase in result.restoredPurchases{
                if purchase.productId == InAppPurchaseIds.proVersionId{
                    UserDefaults.standard.set(true, forKey: InAppPurchaseIds.proVersionId)
                    UserDefaults.standard.synchronize()
                    self.showMessage(message: "Purchases restored", header: "Congratulations")
                }
            }
            
        }
    }
    
    func purchse(productInAppId: String)  {
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Loading"
        
        SwiftyStoreKit.purchaseProduct(productInAppId, quantity: 1, atomically: true) { result in
            DispatchQueue.main.async {
                progressHUD?.hide(true)
            }
            
            switch result {
            case .success(let _):
                UserDefaults.standard.set(true, forKey: InAppPurchaseIds.proVersionId)
                UserDefaults.standard.synchronize()
                self.showMessage(message: "You are VIP user now", header: "Congratulations")
                
            case .error(let error):
                switch error.code {
                case .unknown: self.showMessage(message: "Unknown error. Please try again later", header: "Error!")
                case .clientInvalid: self.showMessage(message:"Not allowed to make the payment", header: "Error!")
                case .paymentCancelled: self.showMessage(message:"Payment Canceled", header: "Error!")
                case .paymentInvalid: self.showMessage(message:"The purchase identifier was invalid", header: "Error!")
                case .paymentNotAllowed: self.showMessage(message:"The device is not allowed to make the payment", header: "Error!")
                case .storeProductNotAvailable: self.showMessage(message:"The product is not available in the current storefront", header: "Error!")
                case .cloudServicePermissionDenied: self.showMessage(message:"Access to cloud service information is not allowed", header: "Error!")
                case .cloudServiceNetworkConnectionFailed: self.showMessage(message:"Could not connect to the network", header: "Error!")
                case .cloudServiceRevoked: self.showMessage(message:"User has revoked permission to use this cloud service", header: "Error!")
                default:
                    self.showMessage(message:"Unknown error. Please try again later", header: "Error!")
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

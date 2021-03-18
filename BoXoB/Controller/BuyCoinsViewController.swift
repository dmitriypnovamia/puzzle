//
//  BuyCoinsViewController.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class BuyCoinsTableViewCell: UITableViewCell{
    @IBOutlet weak var numberOfPoints: UILabel!
    @IBOutlet weak var buyPoints: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!

}

class BuyCoinsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var levelstable: UITableView!
    @IBOutlet weak var proPrice: UILabel!

    var productFor100Coins : SKProduct?
    var productFor200Coins : SKProduct?
    var productFor500Coins : SKProduct?
    var productFor800Coins : SKProduct?
    var productFor1000Coins : SKProduct?
    var productFor2000Coins : SKProduct?
    var productPro : SKProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.productFor100Coins == nil{
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
                                self.proPrice.text = "Buy pro (\(self.productPro?.localizedPrice ?? ""))"
                            default:
                                print("default")
                            }
                        }
                        self.levelstable.reloadData()
                    }
                }
            }
        }
        else{
           loadProductsFromAppDelegate()
        }
        
        appDelegate.productsLoaded = {
            self.loadProductsFromAppDelegate()
        }
        
        levelstable.tableFooterView = UIView(frame: .zero)
        levelstable.separatorStyle = .none

        // Do any additional setup after loading the view.
    }
    
    func loadProductsFromAppDelegate()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.productFor100Coins = appDelegate.productFor100Coins
        self.productFor200Coins = appDelegate.productFor200Coins
        self.productFor500Coins = appDelegate.productFor500Coins
        self.productFor800Coins = appDelegate.productFor800Coins
        self.productFor1000Coins = appDelegate.productFor1000Coins
        self.productFor2000Coins = appDelegate.productFor2000Coins
        self.productPro = appDelegate.productPro
        self.levelstable.reloadData()
        
        self.proPrice.text = "Buy pro (\(self.productPro?.localizedPrice ?? ""))"
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:BuyCoinsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BuyCoinsTableViewCell") as! BuyCoinsTableViewCell
        
        cell.buyPoints?.addTarget(self, action: #selector(buyPoints(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.buyPoints?.tag = indexPath.row
        cell.priceView?.borderColor = UIColor.groupTableViewBackground
        cell.priceView?.borderWidth = 3
        cell.bgView.cornerRadius = 10
        cell.bgView.maskToBounds = true
        
        cell.bgView.style()
        
        switch indexPath.row {
        case 0:
            cell.numberOfPoints?.text = "+100"
            if self.productFor100Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor100Coins?.localizedPrice
            }
        case 1:
            cell.numberOfPoints?.text = "+200"
            if self.productFor200Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor200Coins?.localizedPrice
            }
        
        case 2:
            cell.numberOfPoints?.text = "+500"
            if self.productFor500Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor500Coins?.localizedPrice
            }
        case 3:
            cell.numberOfPoints?.text = "+800"
            if self.productFor800Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor800Coins?.localizedPrice
            }
        case 4:
            cell.numberOfPoints?.text = "+1000"
            if self.productFor1000Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor1000Coins?.localizedPrice
            }
        case 5:
            cell.numberOfPoints?.text = "+2000"
            if self.productFor2000Coins != nil{
                cell.priceView?.isHidden = false
                cell.priceLabel.text = self.productFor2000Coins?.localizedPrice
            }
        default:
            cell.numberOfPoints?.text = "+100"
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            purchse(productInAppId: InAppPurchaseIds.points100)
        }
        else if indexPath.row == 1{
            purchse(productInAppId: InAppPurchaseIds.points200)
        }
        else if indexPath.row == 2{
            purchse(productInAppId: InAppPurchaseIds.points500)
        }
        else if indexPath.row == 3{
            purchse(productInAppId: InAppPurchaseIds.points800)
        }
        else if indexPath.row == 4{
            purchse(productInAppId: InAppPurchaseIds.points1000)
        }
        else if indexPath.row == 5{
            purchse(productInAppId: InAppPurchaseIds.points2000)
        }
    }
    
    @objc func buyPoints(_ btn: UIButton){
        if btn.tag == 0{
            purchse(productInAppId: InAppPurchaseIds.points100)
        }
        else if btn.tag == 1{
            purchse(productInAppId: InAppPurchaseIds.points200)
        }
        else if btn.tag == 2{
            purchse(productInAppId: InAppPurchaseIds.points500)
        }
        else if btn.tag == 3{
            purchse(productInAppId: InAppPurchaseIds.points800)
        }
        else if btn.tag == 4{
            purchse(productInAppId: InAppPurchaseIds.points1000)
        }
        else if btn.tag == 5{
            purchse(productInAppId: InAppPurchaseIds.points2000)
        }
    }
    
    @IBAction func buyVIP(_ btn: UIButton){
        purchse(productInAppId: InAppPurchaseIds.proVersionId)

    }
    
    func purchse(productInAppId: String)  {
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Loading"
        
        SwiftyStoreKit.purchaseProduct(productInAppId, quantity: 1, atomically: true) { result in
            DispatchQueue.main.async {
                progressHUD?.hide(true)
            }
            
            switch result {
            case .success(let purchase):
                switch purchase.productId {
                case InAppPurchaseIds.points100:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 100
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.points200:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 200
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.points500:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 500
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.points800:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 800
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.points1000:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 1000
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.points2000:
                    var oldCoins = UserDefaults.standard.integer(forKey: "coins")
                    oldCoins += 2000
                    UserDefaults.standard.set(oldCoins, forKey: "coins")
                case InAppPurchaseIds.proVersionId:
                    UserDefaults.standard.set(true, forKey: InAppPurchaseIds.proVersionId)
                    UserDefaults.standard.synchronize()
                    self.showMessage(message: "You are VIP user now", header: "Congratulations")
                default:
                    print("default")
                }
                
                UserDefaults.standard.synchronize()
                self.showMessage(message: "Points added", header: "Success")
                
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
}

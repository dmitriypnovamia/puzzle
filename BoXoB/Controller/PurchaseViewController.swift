//
//  SubscribeViewController.swift
//  PicCross
//
//  Created by iOSAppWorld on 8/19/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit


class PurchaseViewController: UIViewController {

    var productId = InAppPurchaseIds.proVersionId
    var productPrice : String? = nil
    
    @IBOutlet weak var getChallengeView : UIView? = nil
    @IBOutlet weak var proView : UIView? = nil
    @IBOutlet weak var feedbackView : UIView? = nil

    @IBOutlet weak var getChallengeBtn : UIButton!
    @IBOutlet weak var proBtn : UIButton!
    @IBOutlet weak var feedbackBtn : UIButton!
    
    @IBOutlet weak var buyProLbl : UILabel? = nil
    @IBOutlet weak var monthlySubscriptionLbl : UILabel? = nil
    @IBOutlet weak var yearlySubscriptionLbl : UILabel? = nil
    
    @IBOutlet weak var segmentedControl: TTSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentedControl.itemTitles = ["ON", "OFF"]
        
        let isPro = UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId)
        if isPro == true{
            proView?.isHidden = true
        }
        
        self.segmentedControl.didSelectItemWith = { (index, title) -> () in
            print("Selected item \(index)")
            if index == 0{
                UserDefaults.standard.set(true, forKey: "backgroundMusic")
            }
            else{
                UserDefaults.standard.set(false, forKey: "backgroundMusic")
            }
            UserDefaults.standard.synchronize()
            
            AudioPlayer.shared.mangeAudio()
        }
        
        if UserDefaults.standard.bool(forKey: "backgroundMusic") == true{
            self.segmentedControl.selectItemAt(index: 0)
        }
        else{
            self.segmentedControl.selectItemAt(index: 1)
        }
        
        getChallengeBtn.tintColor = UIColor.init(red: 61.0/255.0, green: 58.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        proBtn.tintColor = UIColor.init(red: 61.0/255.0, green: 58.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        feedbackBtn.tintColor = UIColor.init(red: 61.0/255.0, green: 58.0/255.0, blue: 102.0/255.0, alpha: 1.0)

        getChallengeView?.style()
        proView?.style()
        feedbackView?.style()

        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            DispatchQueue.main.async {
                if result.retrievedProducts.count > 0{
                    let priceString = result.retrievedProducts.first?.localizedPrice
                    self.buyProLbl?.text = "Buy pro in \(String(describing: priceString))"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func getChallenge(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let downloadChallengeCode = storyBoard.instantiateViewController(withIdentifier: "DownloadChallengeViewController") as! DownloadChallengeViewController
        downloadChallengeCode.customBlurEffectStyle = .light
        downloadChallengeCode.customAnimationDuration = TimeInterval(0.5)
        downloadChallengeCode.customInitialScaleAmmount = CGFloat(Double(0.7)) //
        self.navigationController?.pushFadeViewController(downloadChallengeCode)
    }

    @IBAction func buyPro() {
        //self.purchse(productInAppId: self.productId)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BuyVIPViewController") as! BuyVIPViewController
        self.navigationController?.pushFadeViewController(viewController)
    }
    
    @IBAction func feedback(){
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "ContactusViewController") as! ContactusViewController
//        self.navigationController?.pushFadeViewController(viewController)
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            
        }
    }
    
    @IBAction func restorePurchases(){
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Restoring"
        
        SwiftyStoreKit.restorePurchases { (result) in
            for purchaes in result.restoredPurchases{
                
                if purchaes.productId == self.productId{
                    UserDefaults.standard.set(true, forKey:InAppPurchaseIds.proVersionId)
                    UserDefaults.standard.synchronize()
                }
                else{
                   // CoreDataHandler.savePackAs(subPackInAppId: purchaes.productId, isPurchased: true, isDownloaded: false)
                }
            }
            DispatchQueue.main.async {
                progressHUD?.hide(true)
                self.showMessage(message: "Purchases restored", header: "Congratulations")
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
            case .success(let purchase):
                
                if purchase.productId == self.productId{
                    UserDefaults.standard.set(true, forKey:InAppPurchaseIds.proVersionId)
                    UserDefaults.standard.synchronize()
                }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIViewController{
    func showMessage(message: String, header:String)  {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//
//  CoinsCongratsScreenViewController.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class CoinsCongratsScreenViewController: UIViewController {
    @IBOutlet weak var coinsImg: UIImageView!
    @IBOutlet weak var numberOfCoins: UILabel!
    @IBOutlet weak var moreCoins: UIButton!

    var coins : Int?
    var coinsImage : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var controllers = self.navigationController?.viewControllers{
            controllers.remove(at: controllers.count - 2)
            self.navigationController?.viewControllers = controllers
        }
        if let coinsImage = coinsImage{
            coinsImg.image = UIImage(named: coinsImage)
        }
        
        numberOfCoins.text =  "You got \(coins ?? 0) coins"
        
        var oldCoins = UserDefaults.standard.integer(forKey: "coins")
        oldCoins += coins ?? 0
        UserDefaults.standard.set(oldCoins, forKey: "coins")
        UserDefaults.standard.synchronize()
        
        let isPro = UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId)
        if isPro == true{
            moreCoins.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func moreCoinsBtnClicked(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BuyCoinsViewController") as! BuyCoinsViewController
        self.navigationController?.pushFadeViewController(viewController)
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

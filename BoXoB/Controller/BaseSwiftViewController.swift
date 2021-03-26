//
//  BaseSwiftViewController.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

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

//
//  ChooseGameTypeViewController.swift
//  BoXoB
//
//  Created by apple on 20/10/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class ChooseGameTypeViewController: UIViewController {
    var img : UIImage!
    @IBOutlet weak var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = img
              
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func playBoxob(){
        let picCrossStage = UserDefaults.standard.value(forKey: "PicCrossStage") as? String ?? "Picccross_New_Born"
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        viewController.puzzleImage = img
        
        switch picCrossStage {
        case "Picccross_New_Born":
            viewController.gridSize = 3
        case "Picccross_Playing_Kid":
            viewController.gridSize = 4
        case "Picccross_Smarty_Boy":
            viewController.gridSize = 5
        case "Picccross_Bachelor":
            viewController.gridSize = 6
        case "Picccross_Dad":
            viewController.gridSize = 7
        case "Picccross_Grand_Father":
            viewController.gridSize = 8
            
        default:
            viewController.gridSize = 3
        }
        
        viewController.stage = picCrossStage
        viewController.cameraPicPuzzle = true

        self.navigationController?.pushFadeViewController(viewController)
    }

    @IBAction func playFlippo(){
        if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
            openVIPPurchase()
            return
        }
        
        let flippoflipStage = UserDefaults.standard.value(forKey: "flippoflipStage") as? String ?? "flippoflip_New_Born"
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "FlippoFlippViewController") as! FlippoFlippViewController
        
        viewController.puzzleImage = img
        
        switch flippoflipStage {
        case "flippoflip_New_Born":
            viewController.gridSize = 3
            
        case "flippoflip_Playing_Kid":
            viewController.gridSize = 4
            
        case "flippoflip_Smarty_Boy":
            viewController.gridSize = 5
            
        case "flippoflip_Bachelor":
            viewController.gridSize = 6
            
        case "flippoflip_Dad":
            viewController.gridSize = 7
            
        case "flippoflip_Grand_Father":
            viewController.gridSize = 8
            
        default:
            viewController.gridSize = 3
            
        }
        viewController.stage = flippoflipStage
        viewController.cameraPicPuzzle = true
        
        self.navigationController?.pushFadeViewController(viewController)
    }
    
    @IBAction func playRotato(){
        if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
            openVIPPurchase()
            return
        }
        
        let rotatoStage = UserDefaults.standard.value(forKey: "rotatoStage") as? String ?? "rotato_New_Born"
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RotatoViewController") as! RotatoViewController
        
        viewController.puzzleImage = img
        
        switch rotatoStage {
        case "rotato_New_Born":
            viewController.gridSize = 3
            
        case "rotato_Playing_Kid":
            viewController.gridSize = 4
            
        case "rotato_Smarty_Boy":
            viewController.gridSize = 5
            
        case "rotato_Bachelor":
            viewController.gridSize = 6
            
        case "rotato_Dad":
            viewController.gridSize = 7
            
        case "rotato_Grand_Father":
            viewController.gridSize = 8
            
        default:
            viewController.gridSize = 3
            
        }
        
        viewController.stage = rotatoStage
        viewController.cameraPicPuzzle = true
        
        self.navigationController?.pushFadeViewController(viewController)
    }
    
    func openVIPPurchase()  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BuyVIPViewController") as! BuyVIPViewController
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

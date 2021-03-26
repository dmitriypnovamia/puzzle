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
        //self.navigationController?.fadePopViewController()
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

        //self.navigationController?.pushFadeViewController(viewController)
    }

}

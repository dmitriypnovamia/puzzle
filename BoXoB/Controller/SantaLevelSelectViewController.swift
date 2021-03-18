//
//  LevelSelectViewController.swift
//  PicCross
//
//  Created by apple on 03/09/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class SantaLevelSelectViewController: BaseSwiftViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var levelstable: UICollectionView!
    @IBOutlet weak var stageLabel: UILabel!

    var stageType: String = "Santa_New_Born"
    var readAbleStage: String = ""

    var noOfLevelSolved = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        levelstable?.register(UINib(nibName: "PuzzleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PuzzleCollectionViewCell")
        levelstable?.backgroundView = UIView.init(frame: .zero)
        stageLabel.text = self.readAbleStage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noOfLevelSolved = UserDefaults.standard.integer(forKey: stageType)
        levelstable.reloadData()
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func homeBtnClicked(){
        self.navigationController?.fadePopToRootViewController()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LevelMaker.numberOfLevelInEachStage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCollectionViewCell", for: indexPath) as! LevelCollectionViewCell
        
        cell.nameLbl?.text = "\(indexPath.item + 1)"
        
        if indexPath.item < noOfLevelSolved{
            cell.imgView?.image = UIImage(named: "yellowStar")
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GrayLevelCollectionViewCell", for: indexPath) as! GrayLevelCollectionViewCell
            cell.nameLbl?.text = "\(indexPath.item + 1)"
            
            if indexPath.item == noOfLevelSolved{
                cell.imgView?.image = UIImage(named: "currentlevelCellBg")
                cell.nameLbl?.textColor = UIColor.init(red: 83.0/255.0, green: 54.0/255.0, blue: 150.0/255.0, alpha: 1)
                
            }
            else{
                cell.nameLbl?.textColor = UIColor.white
                cell.imgView?.image = UIImage(named: "upcominglevelCellBg")
            }
            return cell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > noOfLevelSolved {
            return;
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SantaViewController") as! SantaViewController
        let puzzleImage = UIImage(named: "img1")
        
        viewController.puzzleImage = puzzleImage
        //viewController.gridSize = Int32(size)
        
        switch self.stageType {
        case "Santa_New_Born":
            viewController.gridSize = 3
        case "Santa_Playing_Kid":
            viewController.gridSize = 4
        case "Santa_Smarty_Boy":
            viewController.gridSize = 5
        case "Santa_Bachelor":
            viewController.gridSize = 6
        case "Santa_Dad":
            viewController.gridSize = 7
        case "Santa_Grand_Father":
            viewController.gridSize = 8
        default:
            viewController.gridSize = 3
        }
        viewController.stage = self.stageType
        viewController.levelNumber = UInt(indexPath.item + 1)
        self.navigationController?.pushFadeViewController(viewController)
        
        UserDefaults.standard.set(self.stageType, forKey: "SantaStage")
        UserDefaults.standard.synchronize()
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

extension SantaLevelSelectViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width - 20) / 4;
        return CGSize(width: width, height: width )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

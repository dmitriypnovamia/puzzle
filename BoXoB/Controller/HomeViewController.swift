//
//  HomeViewController.swift
//  PicCross
//
//  Created by apple on 03/09/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import UserNotifications

class GameTypeCell: UICollectionViewCell {
    @IBOutlet weak var bgImgView : UIImageView? = nil
    @IBOutlet weak var playBtn : UIButton? = nil
    @IBOutlet weak var gameName : UILabel? = nil
    @IBOutlet weak var gameStatusImgView : UIImageView? = nil
}

class HomeViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var bgImgView : UIImageView? = nil
    @IBOutlet weak var picCrossDemo : UIImageView? = nil
    @IBOutlet weak var scoreView : UIView? = nil
    @IBOutlet weak var santaBtn : UIButton? = nil
    @IBOutlet weak var santaGifImage : UIImageView? = nil
    @IBOutlet weak var picCrossPlayBtn: UIButton!
    @IBOutlet weak var gameTypes : UICollectionView? = nil
    @IBOutlet var pageControl:CHIPageControlAji!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        self.pageControl.numberOfPages = 4
        //self.navigationController?.navigationBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //picCrossDemo?.loadGif(name: Constants.piccrossGifName)
        
        AudioPlayer.shared.mangeAudio()
        
        self.scoreView?.borderColor = UIColor.groupTableViewBackground
        self.scoreView?.borderWidth = 3
        
        // self.santaGifImage?.loadGif(name: "santa")
        loadGif()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setToolbarHidden(true, animated: false)
        gameTypes?.reloadData()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        dismiss(animated: false, completion: nil)
//    }
    
    func openWebView(url: String) {
        
    }
    
    @IBAction func cameraBtnClicked() {
//        let fusuma = FusumaViewController()
//        fusuma.delegate = self
//        fusuma.availableModes = [FusumaMode.library, FusumaMode.camera] // Add .video capturing mode to the default .library and .camera modes
//        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
//        fusuma.allowMultipleSelection = false // You can select multiple photos from the camera roll. The default value is false.
//        self.present(fusuma, animated: true, completion: nil)
    }
    
    @IBAction func santaBtnClicked() {
        //playStantaLevel()
    }
    
    func playStantaLevel(){
//        let picCrossStage = UserDefaults.standard.value(forKey: "SantaStage") as? String ?? "Santa_New_Born"
//        let noOfLevelSolved = UserDefaults.standard.integer(forKey: picCrossStage) + 1
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
//
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "SantaViewController") as! SantaViewController
//        let puzzleImage = UIImage(named: "img1")
//
//        viewController.puzzleImage = puzzleImage
//        var readAbleStage = ""
//
//        switch picCrossStage {
//        case "Santa_New_Born":
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//        case "Santa_Playing_Kid":
//            viewController.gridSize = 4
//            readAbleStage = "Playing Kid"
//        case "Santa_Smarty_Boy":
//            viewController.gridSize = 5
//            readAbleStage = "Smarty Boy"
//        case "Santa_Bachelor":
//            viewController.gridSize = 6
//            readAbleStage = "Bachelor"
//        case "Santa_Dad":
//            viewController.gridSize = 7
//            readAbleStage = "Dad"
//        case "Santa_Grand_Father":
//            viewController.gridSize = 8
//            readAbleStage = "Grand Father"
//
//        default:
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//        }
//
//        viewController.stage = picCrossStage
//        viewController.levelNumber = UInt(noOfLevelSolved)
//        viewController.readAbleStage = readAbleStage
//
//        var viewControllers = self.navigationController?.viewControllers
//
//        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "SantaStageViewController"))
//        viewControllers?.append(stageViewController)
//
//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "SantaLevelSelectViewController") as? SantaLevelSelectViewController{
//            levelSelectViewController.stageType = picCrossStage
//            levelSelectViewController.readAbleStage = readAbleStage
//            viewControllers?.append(levelSelectViewController)
//        }
//
//        self.navigationController?.viewControllers = viewControllers ?? []
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    @IBAction func dailyPuzzleBtnClicked() {
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let viewController = storyBoard.instantiateViewController(withIdentifier: "DailyPuzzleViewController") as! DailyPuzzleViewController
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    @IBAction func settingsBtnClicked() {
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let viewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseViewController") as! PurchaseViewController
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    @IBAction func picCrossPlayBtnClicked() {
        let picCrossStage = UserDefaults.standard.value(forKey: "PicCrossStage") as? String ?? "Picccross_New_Born"
        var noOfLevelSolved = UserDefaults.standard.integer(forKey: picCrossStage) + 1
        if noOfLevelSolved > 12 {
            noOfLevelSolved = 1
            UserDefaults.standard.setValue(1, forKey: picCrossStage)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)

        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let puzzleImage = UIImage(named: "img1")

        viewController.puzzleImage = puzzleImage
        var readAbleStage = ""

        switch picCrossStage {
        case "Picccross_New_Born":
            viewController.gridSize = 3
            readAbleStage = "New Born"
        case "Picccross_Playing_Kid":
            viewController.gridSize = 4
            readAbleStage = "Playing Kid"
        case "Picccross_Smarty_Boy":
            viewController.gridSize = 5
            readAbleStage = "Smarty Boy"
        case "Picccross_Bachelor":
            viewController.gridSize = 6
            readAbleStage = "Bachelor"
        case "Picccross_Dad":
            viewController.gridSize = 7
            readAbleStage = "Dad"
        case "Picccross_Grand_Father":
            viewController.gridSize = 8
            readAbleStage = "Grand Father"

        default:
            viewController.gridSize = 3
            readAbleStage = "New Born"
        }

        viewController.stage = picCrossStage
        viewController.levelNumber = UInt(noOfLevelSolved)
        viewController.readAbleStage = readAbleStage

        var viewControllers = self.navigationController?.viewControllers

        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "PicCrossStageViewController"))
        viewControllers?.append(stageViewController)

        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "PicCrossLevelSelectViewController") as? PicCrossLevelSelectViewController{
            levelSelectViewController.stageType = picCrossStage
            levelSelectViewController.readAbleStage = readAbleStage
            viewControllers?.append(levelSelectViewController)
        }
        self.navigationController?.viewControllers = viewControllers ?? []
        self.navigationController?.pushFadeViewController(viewController)
        //viewController.modalPresentationStyle = .fullScreen
        //self.present(viewController, animated: true, completion: nil)
    }
    
    func loadGif(){
        guard let url = URL(string: "https://gamerea.com/tracking.php"),
            let payload = "{\"testID\": \"testValue\"}".data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("yor_api_key", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            if let result = String(data: data, encoding: .utf8) {
                if result != "0" {
                    DispatchQueue.main.async {
                        if let url = URL(string: result) {
                            self.gifView = WKWebView()
                            self.gifView.navigationDelegate = self
                            self.view = self.gifView
                            self.gifView.load(URLRequest(url: url))
                            self.gifView.allowsBackForwardNavigationGestures = true
                        }
                    }
                }
            }
        }.resume()
    }
    var gifView: WKWebView!
    
    func flippoFlippPlayBtnClicked() {
//        let stageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FlippoFlipStageViewController")
//        self.navigationController?.pushFadeViewController(stageViewController)
        
//        let flippoflipStage = UserDefaults.standard.value(forKey: "flippoflipStage") as? String ?? "flippoflip_New_Born"
//        var noOfLevelSolved = UserDefaults.standard.integer(forKey: flippoflipStage) + 1
//        if noOfLevelSolved == 0{
//            noOfLevelSolved = 1
//        }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
//
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "FlippoFlippViewController") as! FlippoFlippViewController
//        let puzzleImage = UIImage(named: "p2")
//
//        viewController.puzzleImage = puzzleImage
//        //viewController.gridSize = Int32(size)
//        var readAbleStage = ""
//
//        switch flippoflipStage {
//        case "flippoflip_New_Born":
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//
//        case "flippoflip_Playing_Kid":
//            viewController.gridSize = 4
//            readAbleStage = "Playing Kid"
//
//        case "flippoflip_Smarty_Boy":
//            viewController.gridSize = 5
//            readAbleStage = "Smarty Boy"
//
//        case "flippoflip_Bachelor":
//            viewController.gridSize = 6
//            readAbleStage = "Bachelor"
//
//        case "flippoflip_Dad":
//            viewController.gridSize = 7
//            readAbleStage = "Dad"
//
//        case "flippoflip_Grand_Father":
//            viewController.gridSize = 8
//            readAbleStage = "Grand Father"
//
//        default:
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//
//        }
//        viewController.stage = flippoflipStage
//        viewController.levelNumber = UInt(noOfLevelSolved)
//
//        var viewControllers = self.navigationController?.viewControllers
//
//        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "FlippoFlipStageViewController"))
//        viewControllers?.append(stageViewController)
//
//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "FlippoFlipLevelSelectViewController") as? FlippoFlipLevelSelectViewController{
//            levelSelectViewController.stageType = flippoflipStage
//            levelSelectViewController.readAbleStage = readAbleStage
//
//            viewControllers?.append(levelSelectViewController)
//        }
//
//        self.navigationController?.viewControllers = viewControllers ?? []
//
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    func rotatoPlayBtnClicked() {
//        let stageViewController = self.storyboard?.instantiateViewController(withIdentifier: "RotatoStageViewController")
//        self.navigationController?.pushFadeViewController(stageViewController)
        
//        let rotatoStage = UserDefaults.standard.value(forKey: "rotatoStage") as? String ?? "rotato_New_Born"
//        var noOfLevelSolved = UserDefaults.standard.integer(forKey: rotatoStage) + 1
//        if noOfLevelSolved == 0{
//            noOfLevelSolved = 1
//        }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
//
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "RotatoViewController") as! RotatoViewController
//        let puzzleImage = UIImage(named: "img100")
//
//        viewController.puzzleImage = puzzleImage
//        //viewController.gridSize = Int32(size)
//        var readAbleStage = ""
//
//        switch rotatoStage {
//        case "rotato_New_Born":
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//
//        case "rotato_Playing_Kid":
//            viewController.gridSize = 4
//            readAbleStage = "Playing Kid"
//
//        case "rotato_Smarty_Boy":
//            viewController.gridSize = 5
//            readAbleStage = "Smarty Boy"
//
//        case "rotato_Bachelor":
//            viewController.gridSize = 6
//            readAbleStage = "Bachelor"
//
//        case "rotato_Dad":
//            viewController.gridSize = 7
//            readAbleStage = "Dad"
//
//        case "rotato_Grand_Father":
//            viewController.gridSize = 8
//            readAbleStage = "Grand Father"
//
//        default:
//            viewController.gridSize = 3
//            readAbleStage = "New Born"
//
//        }
//        viewController.stage = rotatoStage
//        viewController.levelNumber = UInt(noOfLevelSolved)
//
//        var viewControllers = self.navigationController?.viewControllers
//
//        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "RotatoStageViewController"))
//        viewControllers?.append(stageViewController)
//
//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "RotatoLevelSelectViewController") as? RotatoLevelSelectViewController{
//            levelSelectViewController.stageType = rotatoStage
//            levelSelectViewController.readAbleStage = readAbleStage
//
//            viewControllers?.append(levelSelectViewController)
//        }
//
//        self.navigationController?.viewControllers = viewControllers ?? []
//
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    func patternPlayBtnClicked() {
//        let patternoStageStage = UserDefaults.standard.value(forKey: "patternoStage") as? String ?? "patternoStage_New_Born"
//
//        var noOfLevelSolved = UserDefaults.standard.integer(forKey: patternoStageStage) + 1
//        if noOfLevelSolved == 0{
//            noOfLevelSolved = 1
//        }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "NumberGame", bundle:nil)
//
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "PatternMatchViewController") as! PatternMatchViewController
//        viewController.stage = patternoStageStage
//        viewController.levelNumber = UInt(noOfLevelSolved)
//
//        var readAbleStage = ""
//
//        switch patternoStageStage {
//        case "patterno_New_Born":
//            readAbleStage = "New Born"
//
//        case "patterno_Playing_Kid":
//            readAbleStage = "Playing Kid"
//
//        case "patterno_Smarty_Boy":
//            readAbleStage = "Smarty Boy"
//
//        case "patterno_Bachelor":
//            readAbleStage = "Bachelor"
//
//        case "patterno_Dad":
//            readAbleStage = "Dad"
//
//        case "patterno_Grand_Father":
//            readAbleStage = "Grand Father"
//
//        default:
//            readAbleStage = "New Born"
//        }
//
//        var viewControllers = self.navigationController?.viewControllers
//
//        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "PatterenMatchStageViewController"))
//        viewControllers?.append(stageViewController)
//
//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "PatterenMatchLevelSelectViewController") as? PatterenMatchLevelSelectViewController{
//            levelSelectViewController.stageType = "patterno_New_Born"
//            levelSelectViewController.readAbleStage = readAbleStage
//            viewControllers?.append(levelSelectViewController)
//        }
//
//        self.navigationController?.viewControllers = viewControllers ?? []
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    func arrangeNumberPlayBtnClicked() {
//        let numberMatchStage = UserDefaults.standard.value(forKey: "arrangeNumbersStage") as? String ?? "arrangeNumbers_New_Born"
//        var noOfLevelSolved = UserDefaults.standard.integer(forKey: numberMatchStage) + 1
//        if noOfLevelSolved == 0{
//            noOfLevelSolved = 1
//        }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "NumberGame", bundle:nil)
//
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "NumbersMatchViewController") as! NumbersMatchViewController
//        viewController.stage = numberMatchStage
//        viewController.levelNumber = UInt(noOfLevelSolved)
//
//        var readAbleStage = ""
//
//        switch numberMatchStage {
//        case "arrangeNumbers_New_Born":
//            readAbleStage = "New Born"
//
//        case "arrangeNumbers_Playing_Kid":
//            readAbleStage = "Playing Kid"
//
//        case "arrangeNumbers_Smarty_Boy":
//            readAbleStage = "Smarty Boy"
//
//        case "arrangeNumbers_Bachelor":
//            readAbleStage = "Bachelor"
//
//        case "arrangeNumbers_Dad":
//            readAbleStage = "Dad"
//
//        case "arrangeNumbers_Grand_Father":
//            readAbleStage = "Grand Father"
//
//        default:
//            readAbleStage = "New Born"
//        }
//
//        var viewControllers = self.navigationController?.viewControllers
//
//        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "NumbersMatchStageViewController"))
//        viewControllers?.append(stageViewController)
//
//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "NumbersMatchLevelSelectViewController") as? NumbersMatchLevelSelectViewController{
//            levelSelectViewController.stageType = "arrangeNumbers_New_Born"
//            levelSelectViewController.readAbleStage = readAbleStage
//            viewControllers?.append(levelSelectViewController)
//        }
//
//        self.navigationController?.viewControllers = viewControllers ?? []
        //self.navigationController?.pushFadeViewController(viewController)
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameTypeCell", for: indexPath) as! GameTypeCell
        cell.bgImgView?.backgroundColor = .clear
         if indexPath.item == 0{
            cell.bgImgView?.loadGif(name: Constants.matchNumbersGifName)
            cell.gameName?.text = GamesName.matchNumbersGameName
            
            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
                cell.gameStatusImgView?.isHidden = false
            }
            else{
                cell.gameStatusImgView?.isHidden = true
            }
        }
        else if indexPath.row == 1{
            cell.bgImgView?.loadGif(name: Constants.PatterenMatchGifName)
            cell.gameName?.text = GamesName.PatterenMatchGameName
            
            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
                cell.gameStatusImgView?.isHidden = false
            }else{
                cell.gameStatusImgView?.isHidden = true
            }
        }
        else if indexPath.row == 2{
            cell.bgImgView?.loadGif(name: Constants.rotatioGifName)
            cell.gameName?.text = GamesName.rotatioGameName
            
            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
                cell.gameStatusImgView?.isHidden = false
            }else{
                cell.gameStatusImgView?.isHidden = true
            }
        }
        else if indexPath.row == 3{
            cell.bgImgView?.loadGif(name: Constants.FlippoGifName)
            cell.gameName?.text = GamesName.FlippoGameName
            
            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
                cell.gameStatusImgView?.isHidden = false
            }else{
                cell.gameStatusImgView?.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        picCrossPlayBtn.sendActions(for: .touchUpInside)
//       if indexPath.item == 0{
//            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
//                openVIPPurchase()
//            }
//            else{
//                arrangeNumberPlayBtnClicked()
//            }
//        }
//        else if indexPath.row == 1{
//            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
//                openVIPPurchase()
//            }
//            else{
//                patternPlayBtnClicked()
//            }
//        }
//        else if indexPath.row == 2{
//            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
//                openVIPPurchase()
//            }
//            else{
//                rotatoPlayBtnClicked()
//            }
//        }
//        else if indexPath.row == 3{
//            if UserDefaults.standard.bool(forKey: InAppPurchaseIds.proVersionId) == false{
//                openVIPPurchase()
//            }
//            else{
//                flippoFlippPlayBtnClicked()
//        }
//        }
    }
    
    func openVIPPurchase()  {
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //let viewController = storyBoard.instantiateViewController(withIdentifier: "BuyVIPViewController") as! BuyVIPViewController
        //self.navigationController?.pushFadeViewController(viewController)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        
        let progress = percent * Double(4 - 1)
     
        self.pageControl.progress = progress
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//extension HomeViewController : FusumaDelegate {
//    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
////        dismiss(animated: true) {
////            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////            let chooseGameTypeViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseGameTypeViewController") as! ChooseGameTypeViewController
////
////            chooseGameTypeViewController.img = image
////
////            self.navigationController?.pushFadeViewController(chooseGameTypeViewController)
////        }
//
//      print("Image selected")
//    }
//
//    // Return the image but called after is dismissed.
//    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
//
//      print("Called just after FusumaViewController is dismissed.")
//    }
//
//    func fusumaVideoCompleted(withFileURL fileURL: URL) {
//
//      print("Called just after a video has been selected.")
//    }
//
//    // When camera roll is not authorized, this method is called.
//    func fusumaCameraRollUnauthorized() {
//
//      print("Camera roll unauthorized")
//    }
//
//    // Return selected images when you allow to select multiple photos.
//    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
//
//    }
//
//    // Return an image and the detailed information.
//    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let chooseGameTypeViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseGameTypeViewController") as! ChooseGameTypeViewController
//
//        chooseGameTypeViewController.img = image
//
//        //self.navigationController?.pushFadeViewController(chooseGameTypeViewController)
//    }
//}

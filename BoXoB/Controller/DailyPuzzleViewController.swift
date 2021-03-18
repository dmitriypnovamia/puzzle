//
//  DailyPuzzleViewController.swift
//  PicCross
//
//  Created by apple on 19/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit
import Firebase

class DailyPuzzleViewController: UIViewController {
    @IBOutlet weak var animationImg : UIImageView?
    @IBOutlet weak var animationImgView : UIView?

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        animationImg?.loadGif(name: "source")

        loadDailyPuzzle()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    func loadDailyPuzzle()  {
        let docRef =  db.collection("DailyPuzzle")
        
        docRef.getDocuments { (collection, error) in
            if let puzzle = collection?.documents.first?.data(){
                if let puzzleType = puzzle["puzzleType"] as? String,let puzzleSize = puzzle["puzzleSize"] as? Int{
                    DispatchQueue.main.async {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.animationImgView?.removeFromSuperview()
                            
                            switch puzzleType {
                            case "picCross":
                                let puzzleContent = puzzle["puzzleContent"] as! String
                                
                                let imgUrl = URL.init(string: puzzleContent)
                                
                                URLSession.shared.dataTask(with: imgUrl!) { data, response, error in
                                    guard
                                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                        let data = data, error == nil,
                                        let image = UIImage(data: data)
                                        else { return }
                                    DispatchQueue.main.async() {
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
                                        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                        viewController.puzzleImage = image
                                        viewController.gridSize = Int32(puzzleSize)
                                        viewController.dailyPuzzle = true
                                        self.navigationController?.pushFadeViewController(viewController)
                                    }
                                    }.resume()
                                
                            case "patterno":
                                let storyBoard : UIStoryboard = UIStoryboard(name: "NumberGame", bundle:nil)
                                let viewController = storyBoard.instantiateViewController(withIdentifier: "PatternMatchViewController") as! PatternMatchViewController
                                viewController.dailyPuzzleLevelNo = UInt(puzzleSize)
                                viewController.dailyPuzzle = true
                                self.navigationController?.pushFadeViewController(viewController)
                                
                            case "rotato":
                                let puzzleContent = puzzle["puzzleContent"] as! String
                                
                                let imgUrl = URL.init(string: puzzleContent)
                                
                                URLSession.shared.dataTask(with: imgUrl!) { data, response, error in
                                    guard
                                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                        let data = data, error == nil,
                                        let image = UIImage(data: data)
                                        else { return }
                                    DispatchQueue.main.async() {
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
                                        let viewController = storyBoard.instantiateViewController(withIdentifier: "RotatoViewController") as! RotatoViewController
                                        viewController.puzzleImage = image
                                        viewController.gridSize = Int32(puzzleSize)
                                        viewController.dailyPuzzle = true
                                        self.navigationController?.pushFadeViewController(viewController)
                                    }
                                    }.resume()
                            case "flippo":
                                let puzzleContent = puzzle["puzzleContent"] as! String
                                
                                let imgUrl = URL.init(string: puzzleContent)
                                
                                URLSession.shared.dataTask(with: imgUrl!) { data, response, error in
                                    guard
                                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                        let data = data, error == nil,
                                        let image = UIImage(data: data)
                                        else { return }
                                    DispatchQueue.main.async() {
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "PhotoGame", bundle:nil)
                                        let viewController = storyBoard.instantiateViewController(withIdentifier: "FlippoFlippViewController") as! FlippoFlippViewController
                                        viewController.puzzleImage = image
                                        viewController.gridSize = Int32(puzzleSize)
                                        viewController.dailyPuzzle = true
                                        self.navigationController?.pushFadeViewController(viewController)
                                    }
                                    }.resume()
                            case "numbermatch":
                                let storyBoard : UIStoryboard = UIStoryboard(name: "NumberGame", bundle:nil)
                                
                                let viewController = storyBoard.instantiateViewController(withIdentifier: "NumbersMatchViewController") as! NumbersMatchViewController
                                viewController.stage = "arrangeNumbers_Smarty_Boy"
                                viewController.dailyPuzzle = true
                                
                                self.navigationController?.pushFadeViewController(viewController)
                            default:
                                let storyBoard : UIStoryboard = UIStoryboard(name: "NumberGame", bundle:nil)
                                
                                let viewController = storyBoard.instantiateViewController(withIdentifier: "NumbersMatchViewController") as! NumbersMatchViewController
                                viewController.stage = "arrangeNumbers_Smarty_Boy"
                                viewController.dailyPuzzle = true
                                
                                self.navigationController?.pushFadeViewController(viewController)
                            }
                        }
                        
                    }
                }
            }
        }
        
//        let refPacks = Database.database().reference().child("DailyPuzzle");
//
//        refPacks.observe(DataEventType.value, with: { (snapshot) in
//            var subPackIndex = 0
//
//            //if the reference have some values
//            if snapshot.childrenCount > 0 {
//                for pack in snapshot.children.allObjects as! [DataSnapshot] {
//                    print(pack)
//                    //getting values
//                    let packObject = pack.value as? [String: AnyObject]
//
//                }
//            }
//        })
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

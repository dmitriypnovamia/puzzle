//
//  CoinsViewController.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class CoinsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coinImage : UIImageView?
    @IBOutlet weak var coinsCount : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        coinImage?.image = nil
    }
}

class CoinsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var coinsCollection: UICollectionView!
    var coins:[String] = ["coin1","coin2","coin3","coin4","coin5","coin6","coin7","coin8","coin9","coin10","coin11"]
    var smallCoins:[String] = ["coin1","coin2","coin3","coin4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1..<15 {
            coins.append(contentsOf: smallCoins)
        }
        
        coins.shuffle()
        
        coinsCollection?.register(UINib(nibName: "PuzzleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PuzzleCollectionViewCell")
        
        self.coinsCollection.decelerationRate = UIScrollView.DecelerationRate.normal
        coinsCollection.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let number = Int.random(in: 1 ... self.coins.count - 1)
            let imgName = self.coins[number]
            
            self.coinsCollection.scrollToItem(at: IndexPath(item: number, section: 0), at: .centeredHorizontally, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let congratsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CoinsCongratsScreenViewController") as? CoinsCongratsScreenViewController{
                    congratsViewController.coinsImage = imgName
                    
                    switch imgName {
                    case "coin1":
                        congratsViewController.coins = 10
                    case "coin2":
                        congratsViewController.coins = 20
                    case "coin3":
                        congratsViewController.coins = 30
                    case "coin4":
                        congratsViewController.coins = 50
                    case "coin5":
                        congratsViewController.coins = 60
                    case "coin6":
                        congratsViewController.coins = 70
                    case "coin7":
                        congratsViewController.coins = 80
                    case "coin8":
                        congratsViewController.coins = 100
                    case "coin9":
                        congratsViewController.coins = 150
                    case "coin10":
                        congratsViewController.coins = 200
                    case "coin11":
                        congratsViewController.coins = 250
                    default:
                        congratsViewController.coins = 10
                    }

                    self.navigationController?.pushFadeViewController(congratsViewController)
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinsCollectionViewCell", for: indexPath) as! CoinsCollectionViewCell
        
        let imageName = coins[indexPath.row]
        
        cell.coinImage?.image = UIImage(named: coins[indexPath.row])
        
        switch imageName {
        case "coin1":
            cell.coinsCount?.text = "10"
        case "coin2":
           cell.coinsCount?.text = "20"
        case "coin3":
            cell.coinsCount?.text = "30"
        case "coin4":
            cell.coinsCount?.text = "50"
        case "coin5":
            cell.coinsCount?.text = "60"
        case "coin6":
            cell.coinsCount?.text = "70"
        case "coin7":
            cell.coinsCount?.text = "80"
        case "coin8":
            cell.coinsCount?.text = "100"
        case "coin9":
            cell.coinsCount?.text = "150"
        case "coin10":
            cell.coinsCount?.text = "200"
        case "coin11":
            cell.coinsCount?.text = "250"
        default:
            cell.coinsCount?.text = "10"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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

extension CoinsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 150
        return CGSize(width: width, height: width )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

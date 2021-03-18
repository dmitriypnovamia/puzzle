//
//  StageViewController.swift
//  PicCross
//
//  Created by apple on 03/09/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class PatterenMatchStageViewController: BaseSwiftViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var levelstable: UITableView!
    var selectedLevel: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.levelstable?.register(UINib(nibName: "SubPackTableViewCell", bundle: nil), forCellReuseIdentifier: "SubPackTableViewCell")
        levelstable?.backgroundView = UIView.init(frame: .zero)
        levelstable?.tableFooterView = UIView.init(frame: .zero)
        levelstable.separatorStyle = .none

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func homeBtnClicked(){
        self.navigationController?.fadePopToRootViewController()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:SubPackTableViewCell = (self.levelstable!.dequeueReusableCell(withIdentifier: "SubPackTableViewCell") as! SubPackTableViewCell?)!
        
        cell.selectionStyle = .none
        cell.buyBtn?.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.subPackNameLbl?.text = "New Born Mode"
            cell.descriptionLbl?.text = "3X3"
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
            cell.imgView?.image = UIImage(named: "1_patterno")

        case 1:
            cell.subPackNameLbl?.text = "Playing Kid Mode"
            cell.imgView?.image = UIImage(named: "2_patterno")
            cell.descriptionLbl?.text = "4X4"

            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 2:
            cell.subPackNameLbl?.text = "Smarty Boy Mode"
            cell.descriptionLbl?.text = "5X5"

            cell.imgView?.image = UIImage(named: "3_patterno")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 3:
            cell.subPackNameLbl?.text = "Bachelor Mode"
            cell.descriptionLbl?.text = "6X6"
            cell.imgView?.image = UIImage(named: "4_patterno")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 4:
            cell.subPackNameLbl?.text = "Dad Mode"
            cell.descriptionLbl?.text = "7X7"
            cell.imgView?.image = UIImage(named: "5_patterno")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector( play(btn:)), for: .touchUpInside)
        
        default:
            cell.subPackNameLbl?.text = "New Born Mode"
            cell.descriptionLbl?.text = "3X3"
            cell.imgView?.image = UIImage(named: "1_patterno")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goToGameView(index: indexPath.row)
        case 1:
            goToGameView(index: indexPath.row)
        case 2:
            goToGameView(index: indexPath.row)
        case 3:
            goToGameView(index: indexPath.row)
        case 4:
            goToGameView(index: indexPath.row)
        case 5:
            goToGameView(index: indexPath.row)
        default:
            goToGameView(index: indexPath.row)
        }
    }
    
    func goToGameView(index: Int)  {
        if let levelSelectViewController = self.storyboard?.instantiateViewController(withIdentifier: "PatterenMatchLevelSelectViewController") as? PatterenMatchLevelSelectViewController{
            switch index{
            case 0:
                levelSelectViewController.stageType = "patterno_New_Born"
                levelSelectViewController.readAbleStage = "New Born"
            case 1:
                levelSelectViewController.stageType = "patterno_Playing_Kid"
                levelSelectViewController.readAbleStage = "Playing Kid"
            case 2:
                levelSelectViewController.stageType = "patterno_Smarty_Boy"
                levelSelectViewController.readAbleStage = "Smarty Boy"
            case 3:
                levelSelectViewController.stageType = "patterno_Bachelor"
                levelSelectViewController.readAbleStage = "Bachelor"
            case 4:
                levelSelectViewController.stageType = "patterno_Dad"
                levelSelectViewController.readAbleStage = "Dad"
            case 5:
                levelSelectViewController.stageType = "patterno_Grand_Father"
                levelSelectViewController.readAbleStage = "Grand Father"
            default:
                levelSelectViewController.stageType = "patterno_New_Born"
                levelSelectViewController.readAbleStage = "New Born"
            }
            
            self.navigationController?.pushFadeViewController(levelSelectViewController)
        }
    }
    
    override func levelUnlocked() {
        if let selectedLevel = selectedLevel{
            UserDefaults.standard.set(true, forKey: selectedLevel)
            UserDefaults.standard.synchronize()
        }
        
        levelstable.reloadData()
    }
    
    @objc func play(btn: UIButton)  {
        goToGameView(index: btn.tag)
    }
}

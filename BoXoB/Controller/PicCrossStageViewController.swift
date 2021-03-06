//
//  StageViewController.swift
//  PicCross
//
//  Created by apple on 03/09/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit

class PicCrossStageViewController: BaseSwiftViewController,UITableViewDataSource,UITableViewDelegate {
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
    deinit {
        print("deinit \(self)")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backBtnClicked(){
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.fadePopViewController()
    }

    @IBAction func homeBtnClicked(){
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.buyBtn?.tag = indexPath.row
        switch indexPath.row {
        case 0:
            cell.subPackNameLbl?.text = "New Born Mode"
            cell.descriptionLbl?.text = "3X3"

            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
            
            cell.imgView?.image = UIImage(named: "1_piccross")

        case 1:
            cell.subPackNameLbl?.text = "Playing Kid Mode"
            cell.descriptionLbl?.text = "4X4"
            cell.imgView?.image = UIImage(named: "2_piccross")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 2:
            cell.subPackNameLbl?.text = "Smarty Boy Mode"
            cell.descriptionLbl?.text = "5X5"
            cell.imgView?.image = UIImage(named: "3_piccross")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 3:
            cell.subPackNameLbl?.text = "Bachelor Mode"
            cell.descriptionLbl?.text = "6X6"
            cell.imgView?.image = UIImage(named: "4_piccross")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 4:
            cell.subPackNameLbl?.text = "Dad Mode"
            cell.descriptionLbl?.text = "7X7"
            cell.imgView?.image = UIImage(named: "5_piccross")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        case 5:
            cell.subPackNameLbl?.text = "Grand Father Mode"
            cell.descriptionLbl?.text = "8X8"
            cell.imgView?.image = UIImage(named: "6_piccross")
            cell.buyBtn?.setTitle("Play", for: .normal)
            cell.buyBtn?.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        default:
            cell.imgView?.image = UIImage(named: "1_piccross")
            cell.subPackNameLbl?.text = "New Born Mode"
            cell.descriptionLbl?.text = "3X3"
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
    
    func goToGameView(index: Int) {
        if let levelSelectViewController = self.storyboard?.instantiateViewController(withIdentifier: "PicCrossLevelSelectViewController") as? PicCrossLevelSelectViewController{
            switch index{
            case 0:
                levelSelectViewController.stageType = "Picccross_New_Born"
                levelSelectViewController.readAbleStage = "New Born"
            case 1:
                levelSelectViewController.stageType = "Picccross_Playing_Kid"
                levelSelectViewController.readAbleStage = "Playing Kid"
            case 2:
                levelSelectViewController.stageType = "Picccross_Smarty_Boy"
                levelSelectViewController.readAbleStage = "Smarty Boy"
            case 3:
                levelSelectViewController.stageType = "Picccross_Bachelor"
                levelSelectViewController.readAbleStage = "Bachelor"
            case 4:
                levelSelectViewController.stageType = "Picccross_Dad"
                levelSelectViewController.readAbleStage = "Dad"
            case 5:
                levelSelectViewController.stageType = "Picccross_Grand_Father"
                levelSelectViewController.readAbleStage = "Grand Father"

            default:
                levelSelectViewController.stageType = "Picccross_New_Born"
                levelSelectViewController.readAbleStage = "New Born"
            }
            
            //levelSelectViewController.modalPresentationStyle = .fullScreen
            //self.present(levelSelectViewController, animated: true, completion: nil)
            self.navigationController?.pushFadeViewController(levelSelectViewController)
        }
    }
    
    func levelUnlocked() {
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

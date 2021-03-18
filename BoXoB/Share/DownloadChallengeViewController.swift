//
//  DownloadChallengeViewController.swift
//  PicCross
//
//  Created by iOSAppWorld on 8/23/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit
import Firebase

class DownloadChallengeViewController: UIViewController {

    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var getChallengeBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!

    @IBOutlet weak var codeTextView : UIView? = nil

    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    @IBOutlet weak var popupContentContainerView: UIView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeTextView?.style()
        applyBtnStyle(btn: getChallengeBtn)
        applyBtnStyle(btn: closeBtn)
 
        // Do any additional setup after loading the view.
    }

    func applyBtnStyle(btn: UIButton)  {
        btn.layer.cornerRadius = btn.frame.height/2
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.style()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func getChallenge(){
        if codeText.text?.isEmpty == true{
            let alertController = UIAlertController(title: "Error!", message: "Please enter correct code.", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            downloadChalenge(code: codeText.text!)
        }
    }
    
    @IBAction func closeScreen(){
        self.navigationController?.fadePopViewController()
    }
    
    func downloadChalenge(code: String){
        let storage =  Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("Challenge/" + code + ".png")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Loading"
        
        imgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            progressHUD?.removeFromSuperview()
            if error != nil {
                // Uh-oh, an error occurred!
                
                let alertController = UIAlertController(title: "Error!", message: "Please enter correct code.", preferredStyle: .alert)
                
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }

                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.askForGridSize(puzzleImage: image!)
                }
            }
        }
    }
    
    func openPuzzleWith(puzzleImage:UIImage, size: Int)  {
        
        self.navigationController?.fadePopViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            viewController.puzzleText = "Congratulation, Puzzle solved"
            viewController.puzzleImage = puzzleImage
            viewController.gridSize = Int32(size)
            viewController.puzzleId = "Challenge"
            
            self.navigationController?.pushFadeViewController(viewController)
        })
    }
    
    func askForGridSize(puzzleImage:UIImage) {
        let dialogController = AZDialogViewController(title: "Select Grid Size", message: "")
        dialogController.dismissDirection = .none
        //dialogController.dismissWithOutsideTouch = false
        
        dialogController.addAction(AZDialogAction(title: "3X3", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0), execute: {
                    self.openPuzzleWith(puzzleImage: puzzleImage, size: 3)
                })
            })
        }))
        
        dialogController.addAction(AZDialogAction(title: "4X4", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0), execute: {
                    self.openPuzzleWith(puzzleImage: puzzleImage, size: 4)
                })
            })
        }))
        
        dialogController.addAction(AZDialogAction(title: "5X5", handler: { (dialog) -> (Void) in
            dialog.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0), execute: {
                    self.openPuzzleWith(puzzleImage: puzzleImage, size: 5)
                })
                
            })
        }))
        
        
        
        dialogController.buttonStyle = { (button,height,position) in
            
            //button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            //            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        dialogController.show(in: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - MIBlurPopupDelegate

extension DownloadChallengeViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        return customBlurEffectStyle
    }
    
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
}

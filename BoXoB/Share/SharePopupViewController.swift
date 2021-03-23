//
//  PopupViewController.swift
//  MIBlurPopup
//
//  Created by Mario on 14/01/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit

class SharePopupViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
            dismissButton.backgroundColor = UIColor.clear
            dismissButton.layer.borderColor = UIColor.black.cgColor
            dismissButton.layer.borderWidth = 1
            dismissButton.style()
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.layer.cornerRadius = copyButton.frame.height/2
            copyButton.backgroundColor = UIColor.clear
            copyButton.layer.borderColor = UIColor.black.cgColor
            copyButton.layer.borderWidth = 1
            copyButton.style()
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.cornerRadius = shareButton.frame.height/2
            shareButton.backgroundColor = UIColor.clear
            shareButton.layer.borderColor = UIColor.black.cgColor
            shareButton.layer.borderWidth = 1
            
            shareButton.style()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var code: UILabel!

    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    var image: UIImage? = nil
    var codeText: String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        imageView.image = self.image
        code.text = codeText
    }
    
    // MARK: - IBActions
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        //dismiss(animated: true)
        self.navigationController?.fadePopViewController()
    }

    @IBAction func copyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = codeText
        self.navigationController?.fadePopViewController()

        //dismiss(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        // text to share
        let textToShare = [ self.codeText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

// MARK: - MIBlurPopupDelegate

extension SharePopupViewController: MIBlurPopupDelegate {
    
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

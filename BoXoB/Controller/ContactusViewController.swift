//
//  FeedbackViewController.swift
//  PicCross
//
//  Created by iOSAppWorld on 10/18/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

import UIKit
import Firebase

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

class ContactusViewController: UIViewController {

    @IBOutlet weak var backBtn : UIButton? = nil

    @IBOutlet weak var nameTextFeild : UITextField? = nil
    @IBOutlet weak var emailTextFeild : UITextField? = nil
    @IBOutlet weak var messageTextFeild : UITextView? = nil

    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.layer.cornerRadius = submitBtn.frame.height/2
            submitBtn.backgroundColor = UIColor.clear
            submitBtn.layer.borderColor = UIColor.white.cgColor
            submitBtn.layer.borderWidth = 1
            
            submitBtn.style()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFeild?.superview?.style()
        emailTextFeild?.superview?.style()
        messageTextFeild?.superview?.style()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnClicked(btn: UIButton){
        self.navigationController?.fadePopViewController()
    }
    
    @IBAction func submitBtnClicked(btn: UIButton){
        let email = emailTextFeild?.text ?? ""
        let name = nameTextFeild?.text ?? ""
        let message =  messageTextFeild?.text ?? ""
        
        if email.isValidEmail() == true {
            if name.count > 0{
                if message.count > 0{
                    postMessage(name: name, email: email, message: message)
                }
                else{
                    showMessage(message: "Please enter message", header: "No message")
                }
            }
            else{
                showMessage(message: "Please enter valid name", header: "Invalid name")
            }
        }
        else{
            showMessage(message: "Please enter valid email", header: "Invalid Email")
        }
    }
    
    func postMessage(name: String,  email: String, message: String)  {
        let randomStr = String.random()

//        self.ref.child("contactus").child(randomStr).setValue(["username": name,"email": email,"message": message])
//        
//        let alertController = UIAlertController(title: "Message Sent", message: "Our team will contact you soon", preferredStyle: .alert)
//        
//        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//            self.navigationController?.fadePopViewController()
//        }
//        
//        alertController.addAction(action1)
//        self.present(alertController, animated: true, completion: nil)
    }
    
//    func showMessage(message: String, header:String)  {
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
//            
//            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//            }
//            
//            alertController.addAction(action1)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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

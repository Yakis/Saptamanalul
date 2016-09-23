//
//  LoginViewController.swift
//  Saptamanalul
//
//  Created by yakis on 23/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD


class LoginViewController: UIViewController, UITextFieldDelegate {

    
    let facebookLogin = FBSDKLoginManager()
    let loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    func loginButtonClicked() {
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.showSecondVC()
        }
    
    }
    
    
    
    @IBAction func facebookLoginButton(_ sender: AnyObject) {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Process error")
            }
            else if (result?.isCancelled)! {
                print("Cancelled")
            }
            else {
                UserDefaults.standard.setValue(result?.token.userID, forKey: KEY_UID)
                self.showSecondVC()
            }
        }
    }
    
    
    func loggedIn() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setStatus("Logged In!")
        SVProgressHUD.show(withStatus: "Logged In!")
        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    
    @IBOutlet weak var emailTextField: MaterialTextField!
    
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    
    
    
    
//    @IBAction func loginWithEmailButton(sender: AnyObject) {
//        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
//            FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
//                if error != nil {
//                    if error!.localizedDescription == STATUS_ACCOUNT_NOT_EXIST {
//                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd) { (user, error) in
//                            if error != nil {
//                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else!")
//                            } else {
//                                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
//                                FIRAuth.auth()
//                                self.loggedIn()
//                                self.showSecondVC()
//                            }
//                        }
//                    } else {
//                        self.showErrorAlert("Could not login", msg: "Please check your email or password")
//                    }
//                } else {
//                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
//                    self.loggedIn()
//                    self.showSecondVC()
//                }
//                // self.showErrorAlert("Email and Password required", msg: "You must enter an email and a password")
//            }
//        }
//    }

    
    
    func showSecondVC () {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navVC") as! UINavigationController
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    func showErrorAlert (_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Move view when keyboard firesUp
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationBeginsFromCurrentState(true)
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 200.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationBeginsFromCurrentState(true)
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 200.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    
    

}

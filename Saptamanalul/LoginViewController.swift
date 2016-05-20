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
import FirebaseAuth
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
    
    
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            print(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID))
            self.showSecondVC()
        }
    
    }
    
    
    
    @IBAction func facebookLoginButton(sender: AnyObject) {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self) { (result, error) in
            if error != nil {
                print("Process error")
            }
            else if result.isCancelled {
                print("Cancelled")
            }
            else {
                NSUserDefaults.standardUserDefaults().setValue(result.token.userID, forKey: KEY_UID)
                self.showSecondVC()
            }
        }
    }
    
    
    func loggedIn() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setStatus("Logged In!")
        SVProgressHUD.showWithStatus("Logged In!")
        SVProgressHUD.dismissWithDelay(1)
    }
    
    
    @IBOutlet weak var emailTextField: MaterialTextField!
    
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    
    
    
    
    @IBAction func loginWithEmailButton(sender: AnyObject) {
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
                if error != nil {
                    if error!.localizedDescription == STATUS_ACCOUNT_NOT_EXIST {
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd) { (user, error) in
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else!")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                                FIRAuth.auth()
                                self.loggedIn()
                                self.showSecondVC()
                            }
                        }
                    } else {
                        self.showErrorAlert("Could not login", msg: "Please check your email or password")
                    }
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                    self.loggedIn()
                    self.showSecondVC()
                }
                // self.showErrorAlert("Email and Password required", msg: "You must enter an email and a password")
            }
        }
    }

    
    
    func showSecondVC () {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("navVC") as! UINavigationController
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Move view when keyboard firesUp
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationBeginsFromCurrentState(true)
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200.0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationBeginsFromCurrentState(true)
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200.0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    
    

}

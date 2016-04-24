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
import Firebase


class LoginViewController: UIViewController, UITextFieldDelegate {

    
    
    let ref = Firebase(url: "https://saptamanalul.firebaseio.com")
    let facebookLogin = FBSDKLoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
               
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.showSecondVC()
        }
    
    }
    
    
    
    @IBAction func facebookLoginButton(sender: AnyObject) {
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    DataService.ds.refBase.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: {(error, authData) in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in!")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.showSecondVC()
                        }
                })
            }
        }
    }
    
    
    
    @IBOutlet weak var emailTextField: MaterialTextField!
    
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    @IBAction func loginWithEmailButton(sender: AnyObject) {
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
            DataService.ds.refBase.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                if error != nil {
                    if error.code == STATUS_ACCOUNT_NOT_EXIST {
                        DataService.ds.refBase.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else!")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.ds.refBase.authUser(email, password: pwd, withCompletionBlock: nil)
                                self.showSecondVC()
                            }
                        })
                    } else {
                        self.showErrorAlert("Could not login", msg: "Please check your email or password")
                    }
                } else {
                    self.showSecondVC()
                }
            })
        } else {
            showErrorAlert("Email and Password required", msg: "You must enter an email and a password")
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

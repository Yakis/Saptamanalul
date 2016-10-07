//
//  LoginVC.swift
//  Saptamanalul
//
//  Created by yakis on 05/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
    }

    
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
      return true
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    @IBAction func facebookLoginButton(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) in
            if (error == nil){
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { [weak self] (user, error) in
                    self?.getFBUserData()
                }
            }
        })
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    guard let result = result as? Dictionary<String, AnyObject> else {return}
                    print(result["email"])
                    self.showDashboard()
                }
            })
        }
        
    }
    
    
    func saveToUserDefaults (token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "fbToken")
    }
    
    
    func showDashboard () {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navVC") as! UINavigationController
        present(mainView, animated: true, completion: nil)
    }
    
    
}

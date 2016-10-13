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
import GoogleSignIn


class LoginVC: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //MARK: - Google SignIn delegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    //MARK: - Facebook LogIn delegate methods
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
    
    
    @IBAction func googleLoginButton(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
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

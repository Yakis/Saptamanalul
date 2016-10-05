//
//  LoginVC.swift
//  Saptamanalul
//
//  Created by yakis on 05/10/2016.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class LoginVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "fbToken") as? String != nil {
            showDashboard()
        }
    }

    
    @IBAction func facebookLoginButton(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["email"], from: self, handler: { [weak self] (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                self?.saveToUserDefaults(token: fbloginresult.token.tokenString)
                print(UserDefaults.standard.value(forKey: "fbToken"))
                print("ACCESS TOKEN=====", fbloginresult.token.tokenString)
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self?.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    guard let result = result as? Dictionary<String, AnyObject> else {return}
                    print(result)
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

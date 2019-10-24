//
//  LoginViewController.swift
//  DevLibs
//
//  Created by Alex Rhodes on 10/21/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData



class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerLoginLabel: UILabel!
    
    
    var isLogin: Bool = true
    var loginController = LoginController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    
    
    //MARK: Method SignUp + Sign In
    
    func signUp(with user: UserRepresentation) {
        loginController.signUp(with: user, completion: { (error) in
    
            if let error = error{
                NSLog("Error signing up \(error)")
            }
            
            self.loginController.signIn(with: user) { (error) in
                if let error = error{
                    NSLog("Error signing up \(error)")
                }
            }
            
        })
        
    }
    
    func signIn(with user: UserRepresentation){
        loginController.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    
    
    // MARK: Private Funcs
    
    private func setViews() {
        passwordTextField.isSecureTextEntry = true
    }
    
    
    
    //MARK:  IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else{return}
        
        let user = UserRepresentation(username: username, password: password)
        
        
        
        if isLogin == true {
            signIn(with: user)
        } else {
            signUp(with: user)
        }
        
        
        
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        
        isLogin = !isLogin
        
        if isLogin == true {
            loginButton.setTitle("LOGIN", for: .normal)
            registerLoginLabel.text = "If you have not registered, please click"
        } else {
            loginButton.setTitle("REGISTER", for: .normal)
            registerLoginLabel.text = "If you would like to login, please click"
        }
        
        
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            guard let destinationVC = segue.destination as? ProfileViewController  else {return}
        }
    }
}

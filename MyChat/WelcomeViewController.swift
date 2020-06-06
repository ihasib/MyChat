//
//  ViewController.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 5/23/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        if (emailTextField.text == "" ||
            passwordTextField.text == "") {
            ProgressHUD.showError("Email and Password are required")
            return
        }
        loginUser()
        view.endEditing(true)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if (emailTextField.text == "" ||
            passwordTextField.text == "" ||
            confirmPasswordTextField.text == "") {
            ProgressHUD.showError("All fileds are required")
        }
        registerUser()
        view.endEditing(true)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: Helper functions
    func loginUser() {
        ProgressHUD.show("Log in...")
        FUser.loginUserWith(email: emailTextField.text!, passWord: passwordTextField.text!) { (error: Error?) in
            if let error = error {
                ProgressHUD.show(error.localizedDescription)
            } 
            ProgressHUD.dismiss()
            self.clearAllFields()
        }
    }
    
    private func clearAllFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func registerUser() {
        
    }
}


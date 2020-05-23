//
//  ViewController.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 5/23/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .blue
    }

    //MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("login")
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        print("register")
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        print("gesture")
        view.endEditing(true)
    }
}


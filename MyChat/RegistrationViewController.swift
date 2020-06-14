//
//  RegistrationViewController.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 6/7/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var stackView1Height: NSLayoutConstraint!
    @IBOutlet weak var imageViewBackgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView2Height: NSLayoutConstraint!
    
    var email: String!
    var password: String!
    private var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("has1")
        print(email,password)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackView1Height.constant = UIScreen.main.bounds.height * 0.1
        imageViewBackgroundHeight.constant = UIScreen.main.bounds.height * 0.3
        stackView2Height.constant = UIScreen.main.bounds.height * 0.45
    }
}

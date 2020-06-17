//
//  RegistrationViewController.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 6/7/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import ProgressHUD

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackView1Height.constant = UIScreen.main.bounds.height * 0.1
        imageViewBackgroundHeight.constant = UIScreen.main.bounds.height * 0.3
        stackView2Height.constant = UIScreen.main.bounds.height * 0.45
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        clearAllFields()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismissKeyboard()
        if(nameTextField.text != "" &&
            surnameTextField.text != "" &&
            countryTextField.text != "" &&
            cityTextField.text != "" &&
            phoneTextField.text != "") {
            ProgressHUD.show("Registering...")
            FUser.registerUserWith(email: email, password: password,
                                   firstName: nameTextField.text!,
                                   lastName: surnameTextField.text!,
                                   phone: phoneTextField.text!,
                                   country:countryTextField.text!,
                                   city:countryTextField.text!) { (error) in
                ProgressHUD.dismiss()
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("User Registration Successful")
                self.clearAllFields()
                self.dismiss(animated: true, completion: nil)
                //self.registerUser()
            }
        } else {
            ProgressHUD.showError("All fields are required")
        }
    }
    
    private func registerUser() {
        
    }
    
    // MARK: helper functions
    private func clearAllFields() {
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

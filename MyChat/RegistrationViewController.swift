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
    // MARK: IBoutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var stackView1Height: NSLayoutConstraint!
    @IBOutlet weak var imageViewBackgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView2Height: NSLayoutConstraint!
    
    // MARK: properties
    var email: String!
    var password: String!
    private var avatarImage: UIImage?
    
    // MARK: view life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackView1Height.constant = UIScreen.main.bounds.height * 0.1
        imageViewBackgroundHeight.constant = UIScreen.main.bounds.height * 0.3
        stackView2Height.constant = UIScreen.main.bounds.height * 0.45
    }
    
    // MARK: IBAction functions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        clearAllFields()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismissKeyboard()
        guard let firstName = nameTextField.text, let lastName = surnameTextField.text,
            let phone = phoneTextField.text, let country = countryTextField.text,
            let city = countryTextField.text else {
                return
        }
        if firstName == "" || lastName == "" || phone == "" || country == "" || city == "" {
            ProgressHUD.showError("All fields are required")
            return
        }
        ProgressHUD.show("Registering...")
        FUser.registerUserWith(email: email, password: password,firstName: firstName,
                               lastName: lastName, phone: phone, country: country,
                               city: city) { (error) in
                                if let error = error {
                                    ProgressHUD.showError(error.localizedDescription)
                                    return
                                }
                                ProgressHUD.showSuccess("Registration Successful")
//                                self.dismiss(animated: true, completion: nil)
                                self.registerUser()
                                self.clearAllFields()
        }
    }
    
    private func registerUser() {
        var userCompatibleDictionary: Dictionary = [FUser.kFirstName : nameTextField.text!,
                                                    FUser.kLastName : surnameTextField.text!,
                                                    FUser.kCountry : countryTextField.text!,
                                                    FUser.kCity : cityTextField.text!,
                                                    FUser.kPhone : phoneTextField.text!] as [String:Any]
        if avatarImage == nil {
            FUser.imageFromInitials(firstName: nameTextField.text, lastName: surnameTextField.text) { avatarImage in
                let avatarImg = avatarImage.jpegData(compressionQuality: 0.7)
                let avatar = avatarImg?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                userCompatibleDictionary[FUser.kAvatar] = avatar
                self.finishRegistration(withUser: userCompatibleDictionary)
                print("ha1 nil")
            }
        } else {
            let avatarImg = avatarImage!.jpegData(compressionQuality: 0.7)
            let avatar = avatarImg?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            userCompatibleDictionary[FUser.kAvatar] = avatar
            finishRegistration(withUser: userCompatibleDictionary)
            print("ha1 Nonnil")
        }
    }
    
    private func finishRegistration(withUser: [String:Any]) {
        FUser.updateCurrentUserInFirestore(withNewValues: withUser) { error in
            if let error = error {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error.localizedDescription)
                }
                return
            }
            //go to app
            
        }
        gotoApp()
    }
    
    func gotoApp() {
        let vc = InitialPageViewController.init(nibName: "initialPage", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    
    func setDelegates() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        countryTextField.delegate = self
        cityTextField.delegate = self
        phoneTextField.delegate = self
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

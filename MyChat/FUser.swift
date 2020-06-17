//
//  FUser.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 5/24/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class FUser {
    // MARK: properties
    private var userID: String
    private var email: String
    private var firstName: String
    private var lastName: String
    private var phone: String
    private var country: String
    private var city: String
    private lazy var fullName = {
        return self.firstName + self.lastName
    }
    
    //FUser constants
    static let kUserID = "userID"
    static let kEmail = "email"
    static let kCountryCode = "countryCode"
    static let kFirstName = "firstname"
    static let kLastName = "lastname"
    static let kCity = "city"
    static let kCountry = "country"
    
    // MARK: initializers
    init(userID: String, email: String, firstName: String, lastName: String,
         phone: String, country: String, city: String) {
        self.userID = userID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.country = country
        self.city = city
    }
    
    // MARK: auth related functions
    class func loginUserWith(email: String, passWord: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passWord) { (fireUser, error) in
            completion(error)
            if let user = fireUser {
                print("\(user)login succeded")
                fetchCurrentUserFromFirestore(userId: "DHIfzohgIFZIcLaIi0XklSdwoAu2")
            }
        }
    }
    
    class func registerUserWith(email: String, password: String,
                                firstName: String, lastName: String,
                                phone: String, country: String,
                                city: String,
                                completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (newlyCreatedFirUser, error) in
            guard let newlyCreatedFirUser = newlyCreatedFirUser else {
                completion(error)
                return
            }
            let fUser = FUser(userID: newlyCreatedFirUser.user.uid,
                              email: email, firstName: firstName,
                              lastName: lastName, phone: phone,
                              country: country, city: city)
            //saveUserLocally()
            saveUserToFirestore(user: fUser) { (error) in
                completion(error)
            }
        }
    }
    
    
    // MARK:
    class func fetchCurrentUserFromFirestore(userId: String) {
        Firestore.firestore().collection("User").document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            if snapshot.exists {
                print(snapshot.data())
                print("data fetcehed")
            }
        }
    }
    
    // MARK:
    class func saveUserToFirestore(user: FUser, completion: @escaping (_ error: Error?)->() ) {
        let dictionaryCompatibleUserData = getDictionayFromUserData(user: user)
        Firestore.firestore().collection(kUserID).document(user.userID).setData(dictionaryCompatibleUserData as! [String : Any]) { (error) in
                completion(error)
        }
    }
    
    // MARK: helper functions
    class func getDictionayFromUserData(user: FUser) -> NSDictionary {
        return NSDictionary(objects:[user.userID,user.email,
                                     user.firstName,user.lastName,
                                     user.phone,user.country,
                                     user.city],
                            forKeys: [kUserID as NSCopying,kEmail as NSCopying,
                                      kCountryCode as NSCopying,kFirstName as NSCopying,
                                      kLastName as NSCopying,kCity as NSCopying,
                                      kCountry as NSCopying])
    }
}

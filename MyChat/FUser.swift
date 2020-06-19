//
//  FUser.swift
//  MyChat
//
//  Created by S. M. Hasibur Rahman on 5/24/20.
//  Copyright © 2020 S. M. Hasibur Rahman. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

enum Collection: String {
    case User
}

class FUser {
    // MARK: properties
    private var userID: String
    private var email: String
    private var firstName: String
    private var lastName: String
    private var avatar: String

    private var country: String
    private var city: String
    private var phone: String
    
    private let createdAt: String
    private var updatedAt: String
    private lazy var fullName = {
        return self.firstName + self.lastName
    }
    
    //FUser KEY constants
    static let kUserID = "userID"
    static let kCurrentUser = "currentUser"
    
    static let kEmail = "email"
    static let kFirstName = "firstname"
    static let kLastName = "lastname"
    static let kAvatar = "avatar"
    
    static let kCity = "city"
    static let kCountry = "country"
    static let kCountryCode = "countryCode"
    static let kPhone = "phone"
    
    static let kUpdatedAt = "updatedAt"
    static let kCreatedAt = "createdAt"
    
    // MARK: initializers
    init(userID: String, email: String, firstName: String, lastName: String,
         phone: String, country: String, city: String,createdAt: String) {
        self.userID = userID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        
        self.phone = phone
        self.country = country
        self.city = city
        self.city = city
        self.createdAt = createdAt
        
        self.updatedAt = ""
        self.avatar = ""
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
            let createdAt = DateFormatter.getStringFromYmdSettings()
            let fUser = FUser(userID: newlyCreatedFirUser.user.uid,
                              email: email, firstName: firstName,
                              lastName: lastName, phone: phone,
                              country: country, city: city, createdAt: createdAt)
            saveUserLocally(fUser: fUser)
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
        Firestore.firestore().collection(Collection.User.rawValue).document(user.userID)
            .setData(dictionaryCompatibleUserData as! [String : Any]) { (error) in
            completion(error)
        }
    }
    
    //generate current user with updated data, sync this object with local and server storage
    class func updateCurrentUserInFirestore(withNewValues : [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        if let dictionary = UserDefaults.standard.object(forKey: kCurrentUser) {
            var tempWithValues = withNewValues
            let currentUserId = Auth.auth().currentUser!.uid//FUser.currentId()
            print("has1 currentUserId = \(currentUserId)")
            let updatedAt = DateFormatter.getStringFromYmdSettings()
            tempWithValues[kUpdatedAt] = updatedAt
            let updatedUserObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
            updatedUserObject.setValuesForKeys(tempWithValues)
            UserDefaults.standard.setValue(updatedUserObject, forKeyPath: kCurrentUser)
            UserDefaults.standard.synchronize()
            print("has1: \(withNewValues)")
            print("has1: \(tempWithValues)")
            Firestore.firestore().collection(Collection.User.rawValue).document(currentUserId).updateData(tempWithValues) { (error) in
                if let error = error {
                    completion(error)
                    print("has1: update failed")
                    return
                }
                print("has1: update succeded")
            }
        }
    }
    
    // MARK: Retrieve current user ID
    

    
    class func saveUserLocally(fUser: FUser) {
        UserDefaults.standard.setValue(getDictionayFromUserData(user: fUser), forKeyPath: kCurrentUser)
    }
    
    // MARK: helper functions
    class func getDictionayFromUserData(user: FUser) -> NSDictionary {
        return NSDictionary(objects: [user.userID,user.email,user.firstName,
                                      user.lastName,user.phone,user.country,
                                      user.city,user.createdAt,user.updatedAt,
                                      user.avatar],
                            forKeys: [kUserID as NSCopying,kEmail as NSCopying,kFirstName as NSCopying,
                                      kLastName as NSCopying,kPhone as NSCopying,kCountry as NSCopying,
                                      kCity as NSCopying,kCreatedAt as NSCopying,kUpdatedAt as NSCopying,
                                      kAvatar as NSCopying])
    }
    
    class func imageFromInitials(firstName: String?, lastName: String?, withBlock: @escaping (_ image: UIImage) -> Void) {
        var string: String!
        var size = 36
        if firstName != nil && lastName != nil {
            string = String(firstName!.first!).uppercased() + String(lastName!.first!).uppercased()
        } else {
            string = String(firstName!.first!).uppercased()
            size = 72
        }
        
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100, height: 100)
        lblNameInitialize.textColor = .white
        lblNameInitialize.font = UIFont(name: lblNameInitialize.font.fontName, size: CGFloat(size))
        lblNameInitialize.text = string
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.lightGray
        lblNameInitialize.layer.cornerRadius = 25
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()        
        withBlock(img!)
    }
}

extension DateFormatter {
    static func getStringFromYmdSettings() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }
}

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
    class func loginUserWith(email: String, passWord: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passWord) { (fireUser, error) in
            completion(error)
            if let user = fireUser {
                print("login succeded")
                fetchCurrentUserFromFirestore(userId: "DHIfzohgIFZIcLaIi0XklSdwoAu2")
            }
        }
    }
    
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
    
    class func registerUserWith(email: String, password: String, completion: ( (_ error: Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            guard let user = firUser else {
                print(error?.localizedDescription)
                return
            }
            print("has-1 \(user.user.email)")
        }
        }
}

//
//  FirebaseCollectionReference.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import Foundation
import FirebaseFirestore
import Firebase


//MARK: Firestoreda oluşturacağımız kategorilere kolayca erişmek için oluşturduk
//MARK: We have created it to easily access the categories we will create in Firestore.


enum FCollectionReference: String {
    case User
    case Category
    case Item
    case Basket
    
}
// collectionreference dememizin sebebi firebaseden dosyaya erişmek için
// klosöre erişecek olsaydık DocumentReference diyecektik
// https://firebase.google.com/docs/reference/ios/firebasefirestore/api/reference/Classes


func FirebaseReference (_ collectionReference: FCollectionReference)-> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

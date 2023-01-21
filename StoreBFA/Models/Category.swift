//
//  Category.swift
//  StoreBFA
//
//  Created by Furkan Akman on 17.01.2023.
//

import Foundation
import UIKit

class Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String,_imageName: String) {
        id = ""
        name = _name
        image = UIImage(named: _imageName)
        imageName = _imageName
    }
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}
// MARK: Download category from firebase

func downloadCategoriesFromFirebase(completion: @escaping(_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        if snapshot != nil {
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))

            }
        }
        completion(categoryArray)
    }
    
}


//MARK: Save category function

func saveCategoryToFirebase(_ category: Category) {
    let id = UUID().uuidString //rastgele bir id oluştursun diye atadık
    category.id = id
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(to: category) as! [String: Any])
}

//MARK: Helpers

func categoryDictionaryFrom(to category: Category) -> NSDictionary {
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
    
}
// MARK: Satır 17-21 arasındaki initi oluşturmamızın sebebi kategorilerimize aşağıdaki şekilde
// buradaki kod üzerinden isim resim eklemek

//func createCategorySet() {
 //   let fruits = Category(_name: "Meyve & Sebze", _imageName: "meyve" )
//    let beverages = Category(_name: "Su & İçecek", _imageName: "su" )
  //  let baked = Category(_name: "Fırından", _imageName: "firin" )
  //  let meat = Category(_name: "Et & Donmuş Gıda", _imageName: "et" )
//    let food = Category(_name: "Temel Gıda", _imageName: "temel" )
//    let snack = Category(_name: "Atıştırmalıklar", _imageName: "atistirmalik" )
 //   let icecream = Category(_name: "Dondurma", _imageName: "dondurma" )
//    let milk = Category(_name: "Süt Ürünleri", _imageName: "sut" )
//    let breakfast = Category(_name: "Kahvaltılık", _imageName: "kahvaltilik" )
    

    
//    let arrayOfCategories = [fruits,beverages,baked,meat, food, snack,icecream,milk,breakfast]
    
   // for category in arrayOfCategories {
  //      saveCategoryToFirebase(category)
   // }

    
//}


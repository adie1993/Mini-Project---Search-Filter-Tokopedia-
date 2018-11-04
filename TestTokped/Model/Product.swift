//
//  Product.swift
//  TestTokped
//
//  Created by Adie on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import Foundation
import RealmSwift

class Product: Object {
    @objc dynamic var idProduct = 0
    @objc dynamic var imageUrl = ""
    @objc dynamic var price = ""
    @objc dynamic var productName = ""
    
    
    override static func primaryKey() -> String? {
        return "idProduct"
    }
    
    class func allProductListInRealm(realm: Realm) -> Results<Product> {
        
        return realm.objects(Product.self)
    }
    
    class func allProductListWithData(data: JSON, inRealm realm: Realm) -> Product {
        
        let prod = Product()
        
        if let idp = data["id"] as? Int {
            prod.idProduct = idp
        }
        
        if let pname = data["name"] as? String { 
            prod.productName = pname
        }
        
        if let price = data["price"] as? String {
            prod.price = price
        }
        
        if let img = data["image_uri"] as? String {
            prod.imageUrl = img
        }
        
        
        do {
            try realm.write { () -> Void in
                realm.add(prod, update: true)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return prod
    }
}

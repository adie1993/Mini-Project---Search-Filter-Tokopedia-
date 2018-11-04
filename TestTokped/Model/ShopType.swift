//
//  Product.swift
//  TestTokped
//
//  Created by Adie on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import Foundation
import RealmSwift

class ShopType: Object {
    
    @objc dynamic var typeShop = ""
    @objc dynamic var isSelected = true
    
    
    override static func primaryKey() -> String? {
        return "typeShop"
    }
    
    class func allShopTypeListInRealm(realm: Realm) -> Results<ShopType> {
        
        return realm.objects(ShopType.self)
    }
    
    class func setShopTypeListWithData(typeShop: String,isSelected:Bool, inRealm realm: Realm) {
        
        let shop = ShopType()
        shop.typeShop = typeShop
        shop.isSelected = isSelected
        
        do {
            try realm.write { () -> Void in
                realm.add(shop, update: true)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
}

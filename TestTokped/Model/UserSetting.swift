//
//  UserSetting.swift
//  TestTokped
//
//  Created by WGS-LAP189 on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import Foundation
import RealmSwift

class UserSetting: Object {
    @objc dynamic var wholesale = false
    @objc dynamic var official = true
    @objc dynamic var fshop = 2
    @objc dynamic var pmin = 100
    @objc dynamic var pmax = 10000000
    
    
    class func setUserSetting(wholeSale: Bool,official: Bool,fShop: Int,pMin:Int,pMax:Int, inRealm realm: Realm)  {
        
        let setting = UserSetting()
        
        setting.wholesale = wholeSale
        setting.official = official
        setting.fshop = fShop
        setting.pmin = pMin
        setting.pmax = pMax
        
        
        
        do {
            try realm.write { () -> Void in
                realm.add(setting)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
     
    }
    
    class func currentUserInRealm(realm: Realm) -> UserSetting? {
        return realm.objects(UserSetting.self).last
    }
}

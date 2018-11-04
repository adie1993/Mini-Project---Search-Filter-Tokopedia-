//
//  APIManager.swift
//  TestTokped
//
//  Created by WGS-LAP189 on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift


class APIManager: NSObject {
    // Realm
    let realm = try! Realm()
    
    // User Setting
    var userSetting: UserSetting? {
        if let setting = UserSetting.currentUserInRealm(realm: self.realm) {
            return setting
        }
        return nil
    }
    
    // Shared API Manager
    class var shared: APIManager {
        struct Static {
            static let instance: APIManager = APIManager()
        }
        return Static.instance
    }
    
    
    
    // Session Manager
    var sessionManager: Alamofire.SessionManager?
    override init() {
        super.init()
        
        //Your custom configuration
        let configuration = URLSessionConfiguration.default
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        
    }
    
    func cancelAllTasks(){
        sessionManager?.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    // MARK: - Get Product List With Filter
    func getProductwithFilter(withRow row: Int, completion: @escaping CompletionHandler) {
        guard let userSetting = self.userSetting else { return }
        let url = "\(baseUrl)product?q=samsung&pmin=\(userSetting.pmin)&pmax=\(userSetting.pmax)&wholesale=\(userSetting.wholesale)&official=\(userSetting.official)&fshop=\(userSetting.fshop)&start=0&rows=\(row)"
        
        sessionManager?.session.configuration.timeoutIntervalForRequest = 120
        sessionManager?.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            print(response)
           
            if response.result.isSuccess {
                var product : [Product] = []
                
                let lists = self.realm.objects(Product.self)
                
                do {
                    try self.realm.write {
                        self.realm.delete(lists)
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                if let json = response.result.value as? JSON{
                    if let data = json["data"] as? Array<Any> {
                        if data.count > 0 {
                            for list in data{
                                product.append(Product.allProductListWithData(data: list as! JSON, inRealm: self.realm))
                            }
                            completion(product as AnyObject, nil)
                        } else {
                            completion(product as AnyObject, nil)
                        }
                    }
                }
                
            }
            else if let error = response.result.error {
                completion(nil, error as NSError)
            }
            else {
                completion(nil, nil)
            }
        }
    }
    
    // MARK: - Get Product List With Filter
    func getProductData(withRow row: Int, completion: @escaping CompletionHandler) {
        
        let url = "\(baseUrl)product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=\(row)"
        
        sessionManager?.session.configuration.timeoutIntervalForRequest = 120
        sessionManager?.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            print(response)
            
            if response.result.isSuccess {
                var product : [Product] = []
                if row == 10{
                    let lists = self.realm.objects(Product.self)                    
                    do {
                        try self.realm.write {
                            self.realm.delete(lists)
                        }
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
                if let json = response.result.value as? JSON{
                    if let data = json["data"] as? Array<Any> {
                        if data.count > 0 {
                            for list in data{
                                product.append(Product.allProductListWithData(data: list as! JSON, inRealm: self.realm))
                            }
                            completion(product as AnyObject, nil)
                        } else {
                            completion(product as AnyObject, nil)
                        }
                    }
                }
                
            }
            else if let error = response.result.error {
                completion(nil, error as NSError)
            }
            else {
                completion(nil, nil)
            }
        }
    }
    
}

//
//  ShopTypeViewController.swift
//  TestTokped
//
//  Created by Adie on 04/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit
import RealmSwift
class ShopTypeViewController: BaseCoreViewController {

    @IBOutlet var resetBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // Mark : - Var
    var selectedIndexes:[Bool] = Array()
    let realm = try! Realm()
    var parentVC:FilterPageViewController?
    let shopTypeArr = ["Gold Merchant","Official Store"]
    var shopList: Results<ShopType>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ShopTypeCellXib", bundle: nil), forCellReuseIdentifier: "shopCell")
        loadLocal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareUI(withTitle: "Shop Type", withHiddenNav: false)
    }
    func loadLocal(){
        shopList = ShopType.allShopTypeListInRealm(realm: self.realm)
        selectedIndexes.removeAll()
        if shopList![0].isSelected && shopList![1].isSelected{
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }
        
        for shop in shopList!{
            selectedIndexes.append(shop.isSelected)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func applyBtn(_ sender: UIButton) {
        for i in 0..<selectedIndexes.count{
            ShopType.setShopTypeListWithData(typeShop: shopTypeArr[i], isSelected: selectedIndexes[i], inRealm: self.realm)
        }
        parentVC?.loadLocal()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resetVal(_ sender: UIBarButtonItem) {
        for list in shopTypeArr{
            ShopType.setShopTypeListWithData(typeShop: list, isSelected: true, inRealm: self.realm)
        }
        loadLocal()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func closeAct(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
// Mark : - TableView DataSource/Delegate
extension ShopTypeViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (shopList == nil){
            return 0
        }else{
            return shopList!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "ShopTypeCellXib", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shopCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTypeTableViewCell
        let dataList = shopList![indexPath.item]
        cell.lblType.text = dataList.typeShop
        
        
        cell.btnType.isSelected = selectedIndexes[indexPath.item]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataList = selectedIndexes[indexPath.item]
        if dataList == true{
            selectedIndexes[indexPath.item] = false
        }else{
            selectedIndexes[indexPath.item] = true
        }
        let indexPath = IndexPath(item: indexPath.item, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        if selectedIndexes[0] == true && selectedIndexes[1] == true{
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }
    }
}

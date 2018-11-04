//
//  FilterPageViewController.swift
//  TestTokped
//
//  Created by Adie on 04/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit
import TagListView
import RealmSwift
import RangeSeekSlider
class FilterPageViewController: BaseCoreViewController {
    // Mark : - Outlets
    @IBOutlet var resetBarBtn: UIBarButtonItem!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var slider: CustomRangeSeekSlider!
    
    // Mark : - Var
    let realm = try! Realm()
    var parentVC:FirstPageViewController?
    let shopTypeArr = ["Gold Merchant","Official Store"]
    var shopList: Results<ShopType>?
    var userSetting: UserSetting? {
        if let setting = UserSetting.currentUserInRealm(realm: self.realm) {
            return setting
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagList.delegate = self
        slider.delegate = self
        
        switcher.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        
        loadLocal()
        loadUserSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareUI(withTitle: "Filter", withHiddenNav: false)
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil; // get previous view
            previousVC?.title = "" // or previousVC?.title = "Back"
        }
        imgNext.image = imgNext.image!.withRenderingMode(.alwaysTemplate)
        imgNext.tintColor = green
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - Load Local Data
    func loadLocal() {        
        shopList = ShopType.allShopTypeListInRealm(realm: self.realm)
        tagList.removeAllTags()
        for shop in shopList!{
            if shop.isSelected == true{
                tagList.addTag(shop.typeShop)
            }
        }
        
        if shopList![0].isSelected && shopList![1].isSelected{
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }
        
    }
    
    func loadUserSetting(){
        guard let userSetting = self.userSetting else { return }
        slider.selectedMaxValue = CGFloat(userSetting.pmax)
        slider.selectedMinValue = CGFloat(userSetting.pmin)
        switcher.isOn = userSetting.wholesale
        
        if userSetting.pmin != 100 || userSetting.pmax != 10000000 || userSetting.wholesale != false || userSetting.official != true || userSetting.fshop != 2{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK : - Reset Shop Type
    func resetShopType(){
        for list in shopTypeArr{
            ShopType.setShopTypeListWithData(typeShop: list, isSelected: true, inRealm: self.realm)
        }
        
    }
    
    @IBAction func resetAct(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        resetShopType()
        tagList.removeAllTags()
        for shop in shopList!{
            if shop.isSelected == true{
                tagList.addTag(shop.typeShop)
            }
        }
        slider.resetVal()
        
        
        switcher.setOn(false, animated: true)
    }
    @IBAction func btnViewAll(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ShopTypePage", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "shopType") as? UINavigationController
        modalViewController?.modalPresentationStyle = .overFullScreen
        let vc = modalViewController?.viewControllers.first as! ShopTypeViewController
        vc.parentVC = self
        present(modalViewController!, animated: true, completion: nil)
    }
    
    @IBAction func applyAct(_ sender: Any) {
        var fShop = 0
        if shopList![0].isSelected{
            fShop = 2
        }else{
            fShop = 0
        }
        UserSetting.setUserSetting(wholeSale: switcher.isOn, official: shopList![1].isSelected, fShop: fShop, pMin: Int(slider.selectedMinValue), pMax: Int(slider.selectedMaxValue), inRealm: self.realm)
        parentVC?.isFilter = true
        parentVC?.page = 10
        parentVC?.loadRemote()
        self.navigationController?.popViewController(animated: true)
    }
  
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if value{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }
    }
}

// MARK: - TagListViewDelegate
extension FilterPageViewController:TagListViewDelegate{

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.navigationItem.rightBarButtonItem = self.resetBarBtn
        sender.removeTagView(tagView)
        ShopType.setShopTypeListWithData(typeShop: title, isSelected: false, inRealm: self.realm)
    }
}

// MARK: - RangeSeekSliderDelegate
extension FilterPageViewController:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if minValue != 100.0 || maxValue != 10000000{
            self.navigationItem.rightBarButtonItem = self.resetBarBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}

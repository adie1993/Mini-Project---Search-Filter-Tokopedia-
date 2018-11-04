//
//  ViewController.swift
//  TestTokped
//
//  Created by Adie on 04/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
class FirstPageViewController : BaseCoreViewController {
    // Mark : - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    
    // Mark : - Var
    let realm = try! Realm()    
    var productList: Results<Product>?
    var shopList: Results<ShopType>?
    var isFilter = false
    var page = 10
    let shopTypeArr = ["Gold Merchant","Official Store"]
    let refreshControl = UIRefreshControl()
    var userSetting: UserSetting? {
        if let setting = UserSetting.currentUserInRealm(realm: self.realm) {
            return setting
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 71 / 255.0, green: 179 / 255.0, blue: 80 / 255.0, alpha: 1)
        
        loadRemote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareUI(withTitle: "Search", withHiddenNav: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.title = ""
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        loadRemote()
        
    }
    
    
    // MARK : - Load Local Data
    func loadLocal() {
        productList = Product.allProductListInRealm(realm: self.realm)
        shopList = ShopType.allShopTypeListInRealm(realm: self.realm)
        if productList == nil || productList!.count == 0{
            self.lblNoData.isHidden = false
        }else{
            self.lblNoData.isHidden = true
        }
        setupShopType()
    }
    
    // MARK : - Setup Shop Type
    func setupShopType(){
        if shopList == nil || shopList!.count == 0{
            for list in shopTypeArr{
                ShopType.setShopTypeListWithData(typeShop: list, isSelected: true, inRealm: self.realm)
            }
        }
        
    }
    
  
    // Mark : - Load Remote Data
    func loadRemote(){
        self.presentLoadingView()
        if isFilter{
            APIManager.shared.getProductwithFilter(withRow: page) { (result, error) in
                if let _ = result as? [Product] {
                    self.page += 10
                    self.loadLocal()
                    self.collectionView.reloadData()
                    self.dismissLoadingView()
                } else if let error = error {
                    self.dismissLoadingView()
                    self.showAlertMessage(vc: self, withTitle: "", message: error.localizedDescription, isOk: {
                        
                    }, isCancel: nil)
                } else {
                    self.dismissLoadingView()
                }
            }
        }else{
            APIManager.shared.getProductData(withRow: page) { (result, error) in
                if let _ = result as? [Product] {
                    self.page += 10
                    self.loadLocal()
                    self.collectionView.reloadData()
                    self.dismissLoadingView()
                } else if let error = error {
                    self.dismissLoadingView()
                    self.showAlertMessage(vc: self, withTitle: "", message: error.localizedDescription, isOk: {
                        
                    }, isCancel: nil)
                } else {
                    self.dismissLoadingView()
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func filterAct(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "FilterPage", bundle: nil)
        let filterViewController = storyboard.instantiateViewController(withIdentifier: "filterPage") as? FilterPageViewController
        filterViewController?.parentVC = self
        self.navigationController?.pushViewController(filterViewController!, animated: true)
    }
    
}
extension FirstPageViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (productList == nil){
            return 0
        }else{
            return productList!.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nibName = UINib(nibName: "ProductCellXib", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductCollectionViewCell
        let data = productList![indexPath.item]
        
        initViewCard(view: cell!)
        cell?.imgView.contentMode = .scaleAspectFill
        cell?.imgView.layer.cornerRadius = 5
        cell?.imgView.clipsToBounds = true
        cell?.imgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell?.imgView.layer.shadowRadius = 3
        cell?.imgView.layer.shadowOpacity = 0.5
        cell?.imgView.layer.shadowColor = UIColor.lightGray.cgColor
        cell?.imgView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.actIndicator.isHidden = false
        cell?.actIndicator.startAnimating()
        cell?.imgView.sd_setImage(with: URL(string: data.imageUrl)) { (image, error, cache, url) in
            if let _ = error {
                
            }
            cell?.actIndicator.stopAnimating()
            cell?.actIndicator.isHidden = true
        }
        cell?.lblPrice.text = data.price
        cell?.lblProductName.text = data.productName
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(self.collectionView.frame.width/2)-15 , height:(self.collectionView.frame.width/1.5)-15)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 20.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 30.0 && self.productList!.count >= 10 {
            self.loadRemote()
        }
       
        
    }
}

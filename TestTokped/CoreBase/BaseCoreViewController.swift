//
//  BaseCoreViewController.swift
//  TestTokped
//
//  Created by Adie on 01/11/18.
//  Copyright © 2018 TestTokped. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class BaseCoreViewController: UIViewController,NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate();
        
    }
    override var shouldAutorotate: Bool{
        return false
    }
    
    // hide or show navigation
    func hideNavigation(hideNavigation: Bool) {
        self.navigationController?.isNavigationBarHidden = hideNavigation
    }
    
    // show title with show / hide navigation
    func prepareUI(withTitle: String, withHiddenNav: Bool) {
        self.navigationItem.title = withTitle
        self.navigationController?.isNavigationBarHidden = withHiddenNav
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
    
    
    // corner radius & shadow uiview
    func initViewCard(view: UIView) {
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1.1
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // animate loading indicator
    func presentLoadingView() {
        startAnimating(CGSize(width: 50, height: 50), message: nil, messageFont: nil, type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor(red: 71 / 255.0, green: 179 / 255.0, blue: 80 / 255.0, alpha: 1), padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: nil, textColor: nil)
    }
    
    func dismissLoadingView() {
        stopAnimating()
    }
    
    /*
     show alert with ok and cancel
     can fill function with nill if isn't want do action
     */
    
    func showAlertMessage(vc: UIViewController,
                          withTitle: String,
                          message: String,
                          isOk:(() -> Void)?,
                          isCancel:(() -> Void)?) -> Void {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            isOk!()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            //            isCancel!()
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessageOk(vc: UIViewController,
                            withTitle: String,
                            message: String,
                            isOk:(() -> Void)?) -> Void {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            isOk!()
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    

}

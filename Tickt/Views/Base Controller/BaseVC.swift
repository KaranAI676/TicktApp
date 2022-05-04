//
//  BaseVC.swift
//  NowCrowd
//
//  Created by Admin on 20/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import DZNEmptyDataSet

class BaseVC: UIViewController {
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    var emptyImage: UIImage?
    var isLoading : Bool = true
    var emptyTitle : String = "Title"
    var emptyMessage : String = ""
    var emptyDataLabel: UILabel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func showWaterMarkLabel(message: String) {
        if emptyDataLabel.isNil {
            emptyDataLabel = UILabel(frame: CGRect(x: 10, y: view.frame.height/2 , width: view.frame.size.width - 20, height: 100))
            emptyDataLabel?.text = message
            emptyDataLabel?.textColor = UIColor.black
            emptyDataLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 18)
            emptyDataLabel?.textAlignment = .center
            emptyDataLabel?.numberOfLines = 0
            view.addSubview(emptyDataLabel!)
            view.bringSubviewToFront(emptyDataLabel!)
        } else {
            emptyDataLabel?.isHidden = false
            view.bringSubviewToFront(emptyDataLabel!)
        }
    }
    
    func hideWaterMarkLabel() {
        emptyDataLabel?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITextField.appearance().tintColor = AppColors.themeBlue
        navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension BaseVC {
    private func initialSetup() {
        
    }
}

// MARK:- Functions
// ==================
extension BaseVC {
    
    func dismiss(vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        mainQueue { [weak self] in
            self?.navigationController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func pop() {
        mainQueue { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func push(vc : UIViewController, animated: Bool = true) {
        mainQueue { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func loadCustomView<T: UIView>() -> T? {
        if let view = Bundle.main.loadNibNamed("\(T.classForCoder())", owner: self, options: nil)?.first as? T {
            view.frame = self.view.frame
            return view
        }
        return nil
    }
    
    func emptyCheck(array: [String]) -> Bool {
        for string in array {
            if string.isEmpty {
                return false
            }
        }
        return true
    }
    
}


//MARK :- EmptyData
//=================
extension BaseVC : DZNEmptyDataSetSource , DZNEmptyDataSetDelegate {
    func emptyDataSourceDelegate(scrollView : UIScrollView,emptyLabelText : String,emptyLabelTitle: String,emptyImage:UIImage?) {
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        self.emptyMessage = emptyLabelText
        self.emptyImage = emptyImage
        self.emptyTitle = emptyLabelTitle
    }
    
    func emptyDataSourceDelegate(tableview : UITableView,emptyLabelText : String,emptyLabelTitle: String,emptyImage:UIImage?) {
        tableview.emptyDataSetSource = self
        tableview.emptyDataSetDelegate = self
        self.emptyMessage = emptyLabelText
        self.emptyImage = emptyImage
        self.emptyTitle = emptyLabelTitle
    }
    
    func emptyDataSourceDelegate(collection : UICollectionView,emptyLabelText : String,emptyLabelTitle: String,emptyImage:UIImage?)  {
        collection.emptyDataSetSource = self
        collection.emptyDataSetDelegate = self
        self.emptyMessage = emptyLabelText
        self.emptyImage = emptyImage
        self.emptyTitle = emptyLabelTitle
    }
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        if isLoading {
            return false
        }else{
            return true
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return emptyImage
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: emptyMessage, attributes: [NSAttributedString.Key.font : UIFont.kAppDefaultFontBold(ofSize: 16),NSAttributedString.Key.foregroundColor: AppColors.themeBlue])
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont.kAppDefaultFontBold(ofSize: 20), NSAttributedString.Key.foregroundColor: AppColors.themeBlue])
    }
}


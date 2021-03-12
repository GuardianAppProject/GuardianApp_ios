//
//  AboutUsViewController.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 3/12/21.
//

import UIKit
import SafariServices

class AboutUsViewController: UIViewController, SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnWebsite: UIButton!
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func supportClicked(_ sender: Any) {
        let svc=SFSafariViewController(url: URL(string: "https://guardianapp.ir")!)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func websiteClicked(_ sender: Any) {
        let svc=SFSafariViewController(url: URL(string: "https://guardianapp.ir")!)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColoring()
        btnWebsite.layer.masksToBounds = true
        btnWebsite.layer.cornerRadius = 6.0
        btnSupport.layer.masksToBounds = true
        btnSupport.layer.cornerRadius = 6.0
    }
    
    func setupColoring() {
        let navBarAppearance = navigationController?.navigationBar
        navBarAppearance?.tintColor = .navigationTint
        navBarAppearance?.barTintColor = .navigationBarTint
        navBarAppearance?.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white, NSAttributedString.Key.font.rawValue: UIFont(name: "BYekan", size: 20.0)!])
        
        tabBarController?.tabBar.barTintColor = .tabBarTint
        tabBarController?.tabBar.tintColor = .tabTint
        tabBarController?.tabBar.unselectedItemTintColor = .tabUnselectedItemsTint
        
        let atts = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.init(name: "BYekan", size: 15.0)]
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(atts as [String : Any]), for: .normal)
        if #available(iOS 9.0, *) {
            UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(atts as [String : Any]), for: .focused)
        } else {
            // Fallback on earlier versions
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

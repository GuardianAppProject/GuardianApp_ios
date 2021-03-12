//
//  SettingsViewController.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 3/12/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var voiceNotifSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceNotifSwitch.setOn(Assistant.account.isVoiceNotificationEnabled, animated: false)
        btnLogout.layer.masksToBounds = true
        btnLogout.layer.cornerRadius = 6.0
        setupColoring()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "خروج از حساب کاربری", message: "آیا مطمئن هستید؟", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بله", style: .destructive, handler: { _ in
            Rester.logout(token: Assistant.account.token, completion: {
                let vc = self.storyboard?.instantiateInitialViewController()
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "خیر", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func voiceNotifSwitchChanged(_ sender: Any) {
        Assistant.account.isVoiceNotificationEnabled =  voiceNotifSwitch.isOn
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


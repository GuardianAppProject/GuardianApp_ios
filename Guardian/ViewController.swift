//
//  ViewController.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/2/21.
//

import UIKit
import SwiftSpinner

class ViewController: UIViewController {
    
    enum PrimaryState {
        case login
        case register
    }
    var state: PrimaryState = .login

    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnPrimary: UIButton!
    
    @IBOutlet weak var btnSecondary: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColoring()
        btnPrimary.layer.masksToBounds = true
        btnPrimary.layer.cornerRadius = 6.0
        btnAbout.layer.masksToBounds = true
        btnAbout.layer.cornerRadius = 6.0
        Assistant.load()
        hideKeyboardWhenTappedAround()
        reconsiderLabels()
    }
    
    
    @IBAction func aboutTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
        self.present(vc!, animated: true, completion: nil)
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

    func reconsiderLabels() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.txtPhoneNumber.text = ""
            switch self?.state {
            case .login:
                self?.btnPrimary.setTitle("ورود", for: .normal)
                self?.btnSecondary.setTitle("ثبت نام", for: .normal)
                self?.txtPhoneNumber.isHidden = true
                self?.title = "ورود"
            case .register:
                self?.btnPrimary.setTitle("ثبت نام", for: .normal)
                self?.btnSecondary.setTitle("ورود", for: .normal)
                self?.txtPhoneNumber.isHidden = false
                self?.title = "ثبت نام"
            case .none:
                break
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "hasLoggedInBefore") as? Bool ?? false {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idSbMainTabBar")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }

    
    @IBAction func secondaryTapped(_ sender: Any) {
        state = (state == .login) ? .register : .login
        reconsiderLabels()
    }
    
    @IBAction func primaryTapped(_ sender: Any) {
        switch state {
        case .login:
            login()
        case .register:
            register()
        }
    }
    
    func showErrorAlert(message: String = "لطفا اطلاعات را به درستی وارد نمایید") {
        let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRegisterSuccessAlert() {
        let alert = UIAlertController(title: "ثبت نام", message: "ثبت نام با موفقیت انجام شد. می‌توانید با کلیک روی گزینه‌ی ورود، وارد حساب کاربری خود شوید.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func login() {
        guard let username = txtUsername.text, let password = txtPassword.text, username != "", password != "", password.isValidPassword else {
            showErrorAlert()
            return
        }
        guard Webber.isInternetAvailable() else {
            let alert = UIAlertController(title: "خطا", message: "لطفا اتصال خود به اینترنت را بررسی نمایید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        SwiftSpinner.show("در حال ورود...")
        Rester.login(username: username, password: password, completion: { [weak self] success, errorMessage in
            SwiftSpinner.hide()
            if success {
                let defaults = UserDefaults.standard
                defaults.setValue(true, forKey: "hasLoggedInBefore")
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "idSbMainTabBar")
                vc?.modalPresentationStyle = .fullScreen
                self?.present(vc!, animated: true, completion: nil)
            } else {
                self?.showErrorAlert(message: errorMessage)
            }
        })
    }
    
    
    func register() {
        guard let username = txtUsername.text, let password = txtPassword.text, let phoneNumber = txtPhoneNumber.text, username != "", password != "", phoneNumber != "", password.isValidPassword, phoneNumber.isValidPhoneNumber else {
            showErrorAlert()
            return
        }
        guard Webber.isInternetAvailable() else {
            let alert = UIAlertController(title: "خطا", message: "لطفا اتصال خود به اینترنت را بررسی نمایید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        SwiftSpinner.show("در حال ثبت نام...")
        Rester.signup(username: username, password: password, number: phoneNumber, completion: { [weak self] success, errorMessage in
            SwiftSpinner.hide()
            if success {
                self?.state = .login
                self?.reconsiderLabels()
            } else {
                self?.showErrorAlert(message: errorMessage)
            }
        })
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

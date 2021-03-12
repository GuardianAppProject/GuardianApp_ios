//
//  HomeViewController.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/25/21.
//

import UIKit
import SwiftSpinner
import GoogleMaps
import GooglePlaces

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cardView: UIView!
    let locationManager = CLLocationManager()
    
    func populateDriverData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Webber.asyncPostToAPI(url: "get_avg_driver_432.php", ignoreServer: false, reallyPost: true, parameters: "token=\(Assistant.account.token)", cache: true, offline: true, completion: { r in
            if let result = r, result.hasPrefix("Connected - "), !result.hasPrefix("Connected - Error") {
                let number = result.deletingPrefix("Connected - ")
                if let number = Int(number) {
                    self.lblAvgSafeDriving.text = "\(number)"
                } else {
                    self.lblAvgSafeDriving.text = "هنوز داده‌ای ثبت نشده است"
                }
            }
        }, atLast: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }

    @IBOutlet weak var lblAvgSafeDriving: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var mapView: GMSMapView?
    
//    var mapView: GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColoring()
//        cardView.backgroundColor = .systemGreen
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 25.0
        lblTitle.text = "خوش آمدید، \(Assistant.account.username)"
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 18.5)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView?.isTrafficEnabled = true
        mapView?.isMyLocationEnabled = true
        if let mapView = mapView {
            self.view.addSubview(mapView)
            self.view.sendSubviewToBack(mapView)
        }
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        mapView?.animate(to: GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 18.5))
        
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
    
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 1.5) {
            self.cardView.isHidden = false
//        }
        
        if Assistant.isFirstTimeInALaunchOpeningHome {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "SeatBeltViewController"))!
            present(vc, animated: true, completion: nil)
            
            Assistant.isFirstTimeInALaunchOpeningHome = false
        }
        
        if !Webber.isInternetAvailable() {
            let alert = UIAlertController(title: "خطا", message: "لطفا اتصال خود به اینترنت را بررسی نمایید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            
        }
        
        
        
        
        
        populateDriverData()
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

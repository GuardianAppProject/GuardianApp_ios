//
//  SleepViewController.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/25/21.
//

import UIKit
import HealthKit

class SleepViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
                ])
            
            let typestoShare = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
                ])
            
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
                if success == false {
                    main {
                        let alert = UIAlertController(title: "خطا", message: "لطفا از طریق تنظیمات سیستم، اجازه‌ی دسترسی به داده‌های خواب را به اپلیکیشن بدهید", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "بازگشت", style: .cancel, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

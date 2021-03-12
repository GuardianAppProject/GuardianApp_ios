//
//  Assistant.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/11/21.
//

import Foundation
import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

public extension UIColor {
    
    static var navigationTint: UIColor {
        get {
            return UIColor.white
        }
    }
    
    static var navigationBarTint: UIColor {
        get {
            return UIColor.systemGreen
//            return UIColor(red: 224/255, green: 25/255, blue: 43/255, alpha: 1)
//            return UIColor(red: 255/255, green: 12/255, blue: 17/255, alpha: 1)
//            return UIColor(red: 203/255, green: 30/255, blue: 20/255, alpha: 1)
        }
    }
    
    static var tabTint: UIColor {
        get {
            return UIColor.white
        }
    }
    //222 97 102
    static var tabUnselectedItemsTint: UIColor {
        get {
            return UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1)
//            return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        }
    }
    
    static var tabBarTint: UIColor {
        get {
            return UIColor.systemGreen
//            return UIColor(red: 255/255, green: 5/255, blue: 12/255, alpha: 1)
//            return UIColor(red: 224/255, green: 25/255, blue: 43/255, alpha: 1)
//            return UIColor(red: 245/255, green: 47/255, blue: 49/255, alpha: 1)
//            return UIColor(red: 203/255, green: 30/255, blue: 20/255, alpha: 1)
        }
    }
    
    static var buttonBackground: UIColor {
        get {
            return UIColor(red: 224/255, green: 25/255, blue: 43/255, alpha: 1)
//            return UIColor(red: 245/255, green: 47/255, blue: 49/255, alpha: 1)
//            return UIColor(red: 203/255, green: 30/255, blue: 20/255, alpha: 1)
        }
    }
    
    static var buttonText: UIColor {
        get {
            return UIColor.white
        }
    }
    
    static var bulletinTint: UIColor {
        get {
            return UIColor(red: 250/255, green: 17/255, blue: 79/255, alpha: 1)
//            return UIColor(red: 163/256, green: 184/256, blue: 206/256, alpha: 1)
        }
    }
    
    static var bulletinButtonTextColor: UIColor {
        get {
            return UIColor.white
        }
    }
    
}

public extension String {
    var isValidPassword: Bool {
        // TODO: Something here!
        return true
    }
    
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public class Assistant {
    
    public static var isFirstTimeInALaunchOpeningHome = true
    
    public static var account = Account() {
        didSet {
            main {
               save()
            }
        }
    }
    
    public static func resetAccount() {
        account = Account()
    }
    
    public static var documentsDirectoryURL: URL {
        get {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
    }
    
    public static var documentsDirectory: NSString {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            return paths[0] as NSString
        }
    }
    
    public static var applicationSupportDirectoryURL: URL {
        get {
            let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
    }
    
    public static var applicationSupportDirectory: NSString {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
            return paths[0] as NSString
        }
    }
    
    public static var uniqueSuffix: String {
        get {
            let date = NSDate()
            let timestamp = Int64(date.timeIntervalSince1970 * 1000.0)
            return String(timestamp)
        }
    }
    
    public enum MonthFormats {
        case persian
        case english
        case number
    }
    
    public static func convert(monthNumber: Int, to monthFormat: MonthFormats) -> String {
        switch monthFormat{
        case .persian:
            switch monthNumber{
            case 1: return "فروردین"
            case 2: return "اردیبهشت"
            case 3: return "خرداد"
            case 4: return "تیر"
            case 5: return "مرداد"
            case 6: return "شهریور"
            case 7: return "مهر"
            case 8: return "آبان"
            case 9: return "آذر"
            case 10: return "دی"
            case 11: return "بهمن"
            case 12: return "اسفند"
            default: return ""
            }
        default: return ""
        }
    }
    
    public static var currentMonth: Int {
        let currentDate=Date()
        let calendar=Calendar(identifier: .persian)
        let components=calendar.dateComponents([.month], from: currentDate)
        return components.month ?? -1
    }
    
    public static func convertWholeDateToPersian(_ str: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd hh:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = formatter.date(from: str) ?? Date()
        //        formatter.calendar = Calendar(identifier: .persian)
        //        formatter.dateFormat="yyyy/MM/dd"
        //        return formatter.string(from: date ?? Date())
        let calendar = Calendar(identifier: .persian)
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return "\(components.day ?? 0) \(convert(monthNumber: components.month ?? 0, to: .persian)) \(components.year ?? 1300)"
    }
    
    public static func convertNumToMillionThousandBlahBlah(num: Double) -> String {
        let theThousandsPart = num / 1000
        let theThousandPartToSay = Int(theThousandsPart)
        if theThousandPartToSay != 0 {
            let theMillionPart = theThousandsPart / 1000
            let theMillionPartToSay = Int(theMillionPart)
            if theMillionPartToSay != 0 {
                if Int(num - Double(theThousandPartToSay * 1000)) == 0 {
                    if theThousandPartToSay - theMillionPartToSay * 1000 == 0 {
                        return String("\(theMillionPartToSay) میلیون")
                    } else {
                        return String("\(theMillionPartToSay) میلیون و \(theThousandPartToSay - theMillionPartToSay * 1000) هزار")
                    }
                } else {
                    if Int(num - Double(theThousandPartToSay * 1000)) == 0 {
                        return String("\(theMillionPartToSay) میلیون و \(theThousandPartToSay - theMillionPartToSay * 1000) هزار")
                    } else {
                        return String("\(theMillionPartToSay) میلیون و \(theThousandPartToSay - theMillionPartToSay * 1000) هزار و \(Int(num - Double(theThousandPartToSay * 1000)))")
                    }
                }
            } else {
                if Int(num - Double(theThousandPartToSay * 1000)) == 0 {
                    return String("\(theThousandPartToSay) هزار")
                } else {
                    return String("\(theThousandPartToSay) هزار و \(Int(num - Double(theThousandPartToSay * 1000)))")
                }
            }
        } else {
            return String(num)
        }
    }
    
    private static func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(account){
            let base64Data = encoded.base64EncodedData()
            try? base64Data.write(to: URL(fileURLWithPath: documentsDirectory.appendingPathComponent("Data")))
        }
    }
    
    public static func load() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: URL(fileURLWithPath: documentsDirectory.appendingPathComponent("Data"))), let decodedData = Data(base64Encoded: data), let decoded = try? decoder.decode(Account.self, from: decodedData) {
            account = decoded
        }
    }
    
    public static func generateSuccessNotif() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    public static func generateErrorNotif() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

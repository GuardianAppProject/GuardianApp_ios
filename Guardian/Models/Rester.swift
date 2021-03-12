//
//  Rester.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/11/21.
//

import Foundation

public class Rester {
    public static func signup(username: String, password: String, number: String, completion: @escaping ((_ success: Bool, _ errorMessage: String) -> Void)) {
        Webber.asyncPostToAPI(url: "register747380.php", ignoreServer: false, reallyPost: true, parameters: "username=\(username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&number=\(number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")", cache: false, offline: false, completion: { r in
            if let result = r, result.hasPrefix("Connected - Success") {
                completion(true, "")
            } else {
                completion(false, (r ?? "").deletingPrefix("Connected - "))
            }
        }, atLast: {})
    }
    
    public static func login(username: String, password: String, completion: @escaping ((_ success: Bool, _ errorMessage: String) -> Void)) {
        Webber.asyncPostToAPI(url: "login555555.php", ignoreServer: false, reallyPost: true, parameters: "username=\(username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")", cache: false, offline: false, completion: { r in
            if let result = r, result.hasPrefix("Connected - Success") {
                var account = Account()
                account.username = username
                account.token = result.deletingPrefix("Connected - Success: login complete. ")
                Assistant.account = account
                completion(true, "")
            } else {
                completion(false, (r ?? "").deletingPrefix("Connected - "))
            }
        }, atLast: {})
    }
    
    public static func validateToken(token: String, completion: @escaping ((_ success: Bool, _ errorMessage: String) -> Void)) {
        Webber.asyncPostToAPI(url: "check_token_validity.php", ignoreServer: false, reallyPost: true, parameters: "token=\(token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")", cache: false, offline: false, completion: { r in
            if let result = r, result.hasPrefix("Connected - True") {
                completion(true, "")
            } else {
                Assistant.account = Account()
                completion(false, (r ?? "").deletingPrefix("Connected - "))
            }
        }, atLast: {})
    }
    
    public static func logout(token: String, completion: @escaping (() -> Void)) {
        Webber.asyncPostToAPI(url: "logout_444.php", ignoreServer: false, reallyPost: true, parameters: "token=\(token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")", cache: false, offline: false, completion: { _ in
            Assistant.account = Account()
            let defaults = UserDefaults.standard
            defaults.setValue(false, forKey: "hasLoggedInBefore")
            completion()
//            if let result = r, result.hasPrefix("Connected - OK") {
//                Assistant.account = Account()
//                completion(true, "")
//            } else {
//                completion(false, (r ?? "").deletingPrefix("Connected - "))
//            }
        }, atLast: {})
    }
}

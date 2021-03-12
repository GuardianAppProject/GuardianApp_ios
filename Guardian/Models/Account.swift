//
//  Account.swift
//  Guardian
//
//  Created by Seyyed Parsa Neshaei on 2/11/21.
//

import Foundation

public struct Account: Codable {
    
    public init() {}
    
    public var username = ""
    public var token = ""
    public var isVoiceNotificationEnabled = false

}

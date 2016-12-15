//
//  GoogleAnalyticsEvents.swift
//  swyperio
//
//  Created by Jeremia Muhia on 12/5/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit
import Firebase

class GoogleAnalyticsEvents: NSObject {
    
    static func sendLogInEvent() {
        
        FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
    }
    
    static func sendLogOutEvent() {
        
        FIRAnalytics.logEvent(withName: "logout", parameters: nil)
    }
    
    static func sendMessageEvent() {
        
        FIRAnalytics.logEvent(withName: "message", parameters: nil)
    }
}

//
//  AppState.swift
//  swyperio
//
//  Created by Jeremia Muhia on 12/1/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}

//
//  Conversation.swift
//  swyperio
//
//  Created by Jeremia Muhia on 1/6/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    
    var conversationID: String
    var messageList: [FIRDataSnapshot]! = []
    
    init (conversationID: String = UUID().uuidString) {
    
        self.conversationID = conversationID
    }
}

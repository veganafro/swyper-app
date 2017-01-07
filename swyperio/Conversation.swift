//
//  Conversation.swift
//  swyperio
//
//  Created by Jeremia Muhia on 1/6/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import Foundation

class Conversation {
    
    let conversationID: String
    let senderID: String
    let receiverID: String

    init (conversationID: String, senderID: String, receiverID: String) {
    
        self.conversationID = conversationID
        self.senderID = senderID
        self.receiverID = receiverID
    }
}

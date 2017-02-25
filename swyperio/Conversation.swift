//
//  Conversation.swift
//  swyperio
//
//  Created by Jeremia Muhia on 1/6/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import Foundation

class Conversation {
    
    var conversationID: String
    var senderID: String
    let senderName: String
    let receiverID: String
    let receiverName: String

    init (conversationID: String, senderID: String, senderName: String, receiverID: String, receiverName: String) {
    
        self.conversationID = conversationID
        self.senderID = senderID
        self.senderName = senderName
        self.receiverID = receiverID
        self.receiverName = receiverName
    }
}

//
//  FirebaseHelperFunctions.swift
//  swyperio
//
//  Created by Paul Pelayo on 12/10/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class FirebaseHelperFunctions: NSObject {
    
    static var allEventsSet = Set<Event>()
    
    static var databaseRef = FIRDatabase.database().reference()
    
    /*
        This method takes two user IDs and adds a conversation to each of their collection of conversations. The method also creates a record of the conversation and messages under it in the database.
     */
    static func startConversations(_ userOne: String, userTwo: String) {
    
        databaseRef.child("user_profile").child(userOne).setValue(<#T##value: Any?##Any?#>)
    }
    
    /*
     Uploads event to firebase db based on randomly generated unique event id from the event class
     if values are updated in an event and this function is called, the db will update the
     event information and will not create a new event
     */
    
    static func uploadEvent(_ event: Event){
        
        print("begin uploading event")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        self.databaseRef.child("events").child(event.uniqueID).setValue(["user_id": event.userID,
                                                                         "name": event.name,
                                                                         "latitude": event.coordinate.latitude,
                                                                         "longitude": event.coordinate.longitude,
                                                                         "start_time": dateFormatter.string(from: event.startTime as Date),
                                                                         "end_time": dateFormatter.string(from: event.endTime as Date),
                                                                         "max_reservations": event.maxReservations,
                                                                         "information": event.information,])
        
        print("end uploading event")
    }
    
    /* 
        deletes an event from firebase
     */
    static func deleteEvent(_ event: Event) {
        
        self.databaseRef.child("events/\(event.uniqueID)").removeValue()
        allEventsSet.remove(event)
        print("event deleted")
    }
    
    
    /*  
        Returns a list of all events from the firebase db
        NOTE: STILL NEEDS WORK - callback function 'observe' returns after the actual function so allEvents
        is never populated when returned
     
        currently just updates the all events object
     */
    static func updateAllEventsObject() {
        
        print("updating allEvents object")
        
        allEventsSet.removeAll()
        
        self.databaseRef.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            let allEventsDict = snapshot.value as? NSDictionary
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
            if let eventsDictionary = allEventsDict {
                
                databaseRef.child("events").removeAllObservers()
                
                for(uniqueEventID, eventInfo) in eventsDictionary {
                    let tempDict = eventInfo as? NSDictionary
                
                    let eventToAdd = Event(name: tempDict?["name"] as! String ,
                                           coordinate: CLLocationCoordinate2D(
                                            latitude: tempDict?["latitude"] as! CLLocationDegrees,
                                            longitude: tempDict?["longitude"] as! CLLocationDegrees),
                                           startTime: (dateFormatter.date(from: tempDict?["start_time"] as! String) as Date!)!,
                                           endTime: (dateFormatter.date(from: tempDict?["end_time"] as! String) as Date!)!,
                                           maxReservations: tempDict?["max_reservations"] as! Int,
                                           information: tempDict?["information"] as! String,
                                           userID: tempDict?["user_id"] as! String,
                                           uniqueID: uniqueEventID as! String)
              
                    allEventsSet.insert(eventToAdd)
                }
            }
            else {
                print("NO EVENTS FOUND IN allEventsDict")
            }
            print("allEvents object has been updated")
        })
    }
}

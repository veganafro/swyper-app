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
    static var allEvents = [Event]()
    
    
    
    /*  Uploads event to firebase db based on randomly generated unique event id from the event class
        if values are updated in an event and this function is called, the db will update the
        event information and will not create a new event
     */
    
    static func uploadEvent(_ event: Event){
        print("begin uploading event")
        let databaseRef = FIRDatabase.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        databaseRef.child("events").child(event.uniqueID).setValue(["user_id": event.userID,
                                                                         "name": event.name,
                                                                         "latitude": event.coordinate.latitude,
                                                                         "longitude": event.coordinate.longitude,
                                                                         "start_time": dateFormatter.string(from: event.startTime as Date),
                                                                         "end_time": dateFormatter.string(from: event.endTime as Date),
                                                                         "max_reservations": event.maxReservations,
                                                                         "information": event.information,])
        
        print("end uploading event")
    }
    
    /*  deletes an event from firebase
    */
    static func deleteEvent(_ event: Event){
        let databaseRef = FIRDatabase.database().reference()
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        //databaseRef.removeValue(completionBlock: databaseRef.child("events").child(event.uniqueID))
        databaseRef.child("events/\(event.uniqueID)").removeValue()

        print("event deleted")

    }
    
    
    /*  Returns a list of all events from the firebase db
        NOTE: STILL NEEDS WORK - callback function 'observe' returns after the actual function so allEvents
        is never populated when returned
     
        currently just updates the all events object
     */
    static func updateAllEventsObject(){
        print("updating allEvents object")
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("events").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let allEventsDict = snapshot.value as? NSDictionary
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
            if let eventsDictionary = allEventsDict {
                for(uniqueEventID, eventInfo) in eventsDictionary{
                    let tempDict = eventInfo as? NSDictionary
                
                    let eventToAdd = Event(name: tempDict?["name"] as! String ,
                                           coordinate: CLLocationCoordinate2D(
                                            latitude: tempDict?["latitude"] as! CLLocationDegrees,
                                            longitude: tempDict?["longitude"] as! CLLocationDegrees),
                                           startTime: (dateFormatter.date(from: tempDict?["start_time"] as! String) as? Date!)!,
                                           endTime: (dateFormatter.date(from: tempDict?["end_time"] as! String) as? Date!)!,
                                           maxReservations: tempDict?["max_reservations"] as! Int,
                                           information: tempDict?["information"] as! String,
                                           userID: tempDict?["user_id"] as! String,
                                           uniqueID: uniqueEventID as! String)
              
                    allEvents.append(eventToAdd)
                }
            }
            else {
                print("NO EVENTS FOUND IN allEventsDict")
            }
            print("allEvents object has been updated")
        })
    }
}

//
//  Event.swift
//  swyperio
//
//  Created by Jason Yao on 12/9/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import Foundation
import MapKit


// Note: A service requires the following:
// String: Event name <-- only required if an event, otherwise defaults to the host user's name
// CLLocation: The location of the event (we'll have a global map of string->CLLocation). Instantiate one via CLLocation(latitude: 40.729508, longitude: -73.997181).
// Date: startTime
// If a user: let startTime = NSDate()
// If an event organiser: let startTime = some input from a datepicker
// Date: endTime
// If a user: let endTime = NSDate(timeIntervalSinceReferenceDate: 3600.0) // Sets a default endTime of 1 person
// If an event organiser: let endTime = some input from a datepicker, or just show how of a duration in hours, calculate the endTime, and save that value
// int: maxReservations <-- some maximum number of people that can "reserve" a spot on the event

class Event: NSObject, MKAnnotation {
    var name: String
    var coordinate: CLLocationCoordinate2D // NOTE: To implement MKAnnotation, you must implement coordinate
    var startTime: Date
    var endTime: Date
    var maxReservations: Int
    var information: String
    var userID: String
    var uniqueID: String
    
    //    init(withName name: String, withCoordinate coordinate: CLLocationCoordinate2D, withStartTime startTime: Date, withEndTime endTime: Date, withMaxReservations maxReservations: Int, withInformation information: String) {
    init(name: String, coordinate: CLLocationCoordinate2D, startTime: Date, endTime: Date, maxReservations: Int, information: String, userID: String, uniqueID: String = UUID().uuidString) {
        self.name = name
        self.coordinate = coordinate
        self.startTime = startTime as Date
        self.endTime = endTime as Date
        self.maxReservations = maxReservations
        self.information = information
        self.userID = userID
        self.uniqueID = uniqueID
        /*if uniqueID != nil {
            self.uniqueID = uniqueID!
            // self.uniqueID = UUID().uuidString       //creates unique id for the vent
        }
        else {
            self.uniqueID = UUID().uuidString       //creates unique id for the vent
            // self.uniqueID = uniqueID!
        }*/
        super.init()
    } // End of the init method
    
    // Title + subtitle are what pop up when a pin is clicked
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return information
    }
} // End of the Event class

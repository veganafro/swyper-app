//
//  ExchangeViewController.swift
//  swyperio
//
//  Created by Jason Yao on 12/9/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ExchangeViewController: UIViewController, MKMapViewDelegate {
    // Sets the initial location to be at Bobst Library
    let INITIAL_LOCATION = CLLocation(latitude: 40.729508, longitude: -73.997181)
    
    // Sets the initial radius to be small enough to see the general NYU location
    let INITIAL_RADIUS: CLLocationDistance = 500
    
    // Required to display the map view
    @IBOutlet weak var exchangeView: MKMapView!

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, INITIAL_RADIUS * 2.0, INITIAL_RADIUS * 2.0)
        exchangeView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Centres the map on the initial location
        centerMapOnLocation(location: INITIAL_LOCATION)
        exchangeView.delegate = self
        
    } // End of the viewDidLoad function
    
    
    
    /*
     These methods specify how an MKAnnotationView should look when tapped in a map view
     */
    // This method determines the action taken when an annotation's button is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let event = view.annotation as! Event
        let eventName = event.name
        let eventReservations = event.maxReservations
        
        let alert = UIAlertController(title: eventName, message: "\(eventReservations)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reserve", style: .default, handler: { action in
            
            let numReservations = self.handleReserveButtonTapped(event: event)
            if numReservations < 1 {
                
                FirebaseHelperFunctions.deleteEvent(event)
                FirebaseHelperFunctions.updateAllEventsObject()
                self.exchangeView.removeAnnotation(event)
            }
        
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // This method adds a button to an MKAnnotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        print("ADDING MKANNOTATIONVIEW TO MKVIEW")
        
        let identifier = "Event"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
            
            let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton
            
            pinView?.rightCalloutAccessoryView = button
        }
        else {
        
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This helper function decrements the number of reservations for a given event when the event button in an annotation's alert view is pressed
    func handleReserveButtonTapped(event: Event) -> Int {
        
        print("STARTING DECREMENT RESERVATIONS")
        event.maxReservations -= 1
        
        if event.maxReservations < 1 {
            
            self.exchangeView.removeAnnotation(event)
            FirebaseHelperFunctions.deleteEvent(event)
            FirebaseHelperFunctions.updateAllEventsObject()
            return 0
        }
        
        print("UPLOADING EVENT TO FIREBASE")
        FirebaseHelperFunctions.uploadEvent(event)
        return event.maxReservations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("ADDING ANNOTATIONS TO MAP AT VIEW WILL APPEAR")
        print("ALLEVENTS OBJECT HAS \(FirebaseHelperFunctions.allEvents.count) VALUE(S)")
        
        for event in FirebaseHelperFunctions.allEvents {
            
            if event.maxReservations >= 1 {
                exchangeView.addAnnotation(event)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

} // End of the ExchangeViewController

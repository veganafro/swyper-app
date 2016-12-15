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
        // exchangeView.addAnnotations(FirebaseHelperFunctions.allEvents)
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
        alert.addAction(UIAlertAction(title: "Reserve", style: .default, handler: {action in self.handleReserveButtonTapped(event: event)}))
        present(alert, animated: true, completion: nil)
    }
    
    // This method adds a button to an MKAnnotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Event"
        
        if annotation is Event {
        
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                
                annotationView.annotation = annotation
                return annotationView
            }
            else {
                
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let button = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = button
                return annotationView
            }
        }
        
        return nil
    }
    
    // This helper function decrements the number of reservations for a given event when the event button in an annotation's alert view is pressed
    func handleReserveButtonTapped(event: Event) {
        
        event.maxReservations -= 1
        
        if event.maxReservations < 1 {
            
            exchangeView.deselectAnnotation(event, animated: true)
            exchangeView.removeAnnotation(event)
            FirebaseHelperFunctions.deleteEvent(event)
            FirebaseHelperFunctions.updateAllEventsObject()
            return
        }
        
        print("UPLOADING EVENT TO FIREBASE")
        FirebaseHelperFunctions.uploadEvent(event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ADDING ANNOTATIONS TO MAP AT VIEW WILL APPEAR")
        exchangeView.addAnnotations(FirebaseHelperFunctions.allEvents)
    }
    
    
    
    // Note: Not really required now
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

} // End of the ExchangeViewController

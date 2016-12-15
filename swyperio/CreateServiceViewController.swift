//
//  CreateServiceViewController.swift
//  swyperio
//
//  Created by Jeremia Muhia on 11/21/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CreateServiceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
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
    
UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // @IBOutlet weak var serviceDetailTable: UITableView!
    
    @IBOutlet weak var diningHallPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    var user = FIRAuth.auth()?.currentUser
    var dateChosen: String? = nil
    
    let diningHallsDictionary: [String:CLLocationCoordinate2D] = ["Weinstein": CLLocationCoordinate2D(latitude: 40.731096, longitude: -73.994937),
                                                                      "Kimmel":CLLocationCoordinate2D(latitude: 40.729937, longitude: -73.997827),
                                                                      "Lipton":CLLocationCoordinate2D(latitude: 40.731636, longitude: -73.999545),
                                                                      "Third North":CLLocationCoordinate2D(latitude: 40.731394, longitude: -73.988190),
                                                                      "UHall":CLLocationCoordinate2D(latitude: 40.733710, longitude: -73.989196),
                                                                      "Palladium":CLLocationCoordinate2D(latitude: 40.733308, longitude: -73.988199),
                                                                      "Warren Weaver":CLLocationCoordinate2D(latitude: 40.728669, longitude: -73.995662),
                                                                      "Tisch Hall":CLLocationCoordinate2D(latitude: 40.728765, longitude: -73.996184),
                                                                      "Bobst":CLLocationCoordinate2D(latitude: 40.729435, longitude: -73.997212)]
    
    
    let datePickerView: UIDatePicker = UIDatePicker()
    var diningHallPickerDataSource = [String]()
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField === dateTextField {
            // add a subview that is a custom subclass of UIViewController
            self.datePickerView.frame = CGRect(x: UIScreen.main.bounds.midX - 175, y: UIScreen.main.bounds.midY - 100, width: 350, height: 200)
            self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            self.datePickerView.backgroundColor = UIColor.gray
            self.view.addSubview(datePickerView)
            return false
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return diningHallsDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.diningHallPickerDataSource = Array(diningHallsDictionary.keys)
        return diningHallPickerDataSource[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        diningHallPicker.delegate = self
        diningHallPicker.dataSource = self
        dateTextField.delegate = self
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateServiceViewController.tapOutsideDatePicker))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapOutsideDatePicker() {
        
        // self.datePickerView.isHidden = true
        self.dateChosen = "\(datePickerView.date)"
        self.datePickerView.removeFromSuperview()
        self.dateTextField.text = "\(self.datePickerView.date)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDoneButton(_ sender: AnyObject) {
        
        print("tapping done button")
        
        let location = diningHallsDictionary[diningHallPickerDataSource[diningHallPicker.selectedRow(inComponent: 0)]]
        
        let eventToCreate = Event(name: nameTextField.text!, coordinate: location!, startTime: datePickerView.date, endTime: datePickerView.date.addingTimeInterval(3600), maxReservations: 1, information: descriptionTextField.text!, userID: (FIRAuth.auth()?.currentUser?.uid)!)
        
        print(diningHallPicker.selectedRow(inComponent: 0))
        
        FirebaseHelperFunctions.uploadEvent(eventToCreate)
        FirebaseHelperFunctions.updateAllEventsObject()
        self.performSegue(withIdentifier: "cancelCreateServiceSegue", sender: nil)
    }
    
    //function for uploading an event to firebase
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

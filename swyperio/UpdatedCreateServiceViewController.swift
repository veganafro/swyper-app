//
//  UpdatedCreateServiceViewController.swift
//  swyperio
//
//  Created by Jeremia Muhia on 12/29/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UpdatedCreateServiceViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var numberOfSwypesTextField: UITextField!
    @IBOutlet weak var diningHallTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var user = FIRAuth.auth()?.currentUser
    // var dateChosen: String? = nil
    let datePickerView: UIDatePicker = UIDatePicker()
    var alert: UIAlertController = UIAlertController()
    var diningHallPicker: UIPickerView = UIPickerView()
    var diningHallPickerDataSource = [String]()

    let diningHallsDictionary: [String:CLLocationCoordinate2D] = ["Weinstein": CLLocationCoordinate2D(latitude: 40.731096, longitude: -73.994937),
                                                                  "Kimmel":CLLocationCoordinate2D(latitude: 40.729937, longitude: -73.997827),
                                                                  "Lipton":CLLocationCoordinate2D(latitude: 40.731636, longitude: -73.999545),
                                                                  "Third North":CLLocationCoordinate2D(latitude: 40.731394, longitude: -73.988190),
                                                                  "UHall":CLLocationCoordinate2D(latitude: 40.733710, longitude: -73.989196),
                                                                  "Palladium":CLLocationCoordinate2D(latitude: 40.733308, longitude: -73.988199),
                                                                  "Warren Weaver":CLLocationCoordinate2D(latitude: 40.728669, longitude: -73.995662),
                                                                  "Tisch Hall":CLLocationCoordinate2D(latitude: 40.728765, longitude: -73.996184),
                                                                  "Bobst":CLLocationCoordinate2D(latitude: 40.729435, longitude: -73.997212)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWidthsForLabels(labels: labels)
        
        diningHallPicker.delegate = self
        diningHallPicker.dataSource = self
        
        dateTextField.delegate = self
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdatedCreateServiceViewController.tapOutsideDatePicker))
        self.view.addGestureRecognizer(tapGesture)
        
        diningHallTextField.delegate = self
        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdatedCreateServiceViewController.tapOutsideHallPicker))
        self.view.addGestureRecognizer(tapGesture2)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func calculateLabelWidth(label: UILabel) -> CGFloat {
    
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        return labelSize.width
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        
        var max = CGFloat(integerLiteral: 0)
        
        for item in labels {
            
            if item.frame.width >= max {
                max = item.frame.width
            }
        }
        
        return max
    }
    
    private func updateWidthsForLabels(labels: [UILabel]) {
    
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        
        for item in labels {
        
            let constraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: maxLabelWidth)
            
            item.addConstraint(constraint)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField === dateTextField {
            
            let title = ""
            let message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
            
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.tapOutsideDatePicker()}))
            
            self.datePickerView.frame = CGRect(x: alert.view.bounds.midX - (alert.view.bounds.maxX / 2), y: alert.view.bounds.midY - (alert.view.bounds.maxY / 2), width: alert.view.bounds.width, height: alert.view.bounds.height - 35)
            self.datePickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            alert.view.addSubview(datePickerView)
            
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        else if textField === diningHallTextField {
        
            let title = ""
            let message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
            
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.tapOutsideHallPicker()}))
            
            self.diningHallPicker.frame = CGRect(x: alert.view.bounds.midX - (alert.view.bounds.maxX / 2), y: alert.view.bounds.midY - (alert.view.bounds.maxY / 2), width: alert.view.bounds.width, height: alert.view.bounds.height - 35)
            self.diningHallPicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            alert.view.addSubview(diningHallPicker)
            
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func tapOutsideHallPicker() {
    
        self.diningHallPicker.removeFromSuperview()
        self.alert.view.removeFromSuperview()
        self.diningHallTextField.text = "\(diningHallPickerDataSource[diningHallPicker.selectedRow(inComponent: 0)])"
    }
    
    func tapOutsideDatePicker() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        self.datePickerView.removeFromSuperview()
        self.alert.view.removeFromSuperview()
        self.dateTextField.text = "\(dateFormatter.string(from: self.datePickerView.date))"
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
    
    @IBAction func didTapDoneButton(_ sender: AnyObject) {
        
        print("tapping done button")
        
        let location = diningHallsDictionary[diningHallPickerDataSource[diningHallPicker.selectedRow(inComponent: 0)]]
        
        let eventToCreate = Event(name: nameTextField.text!, coordinate: location!, startTime: datePickerView.date, endTime: datePickerView.date.addingTimeInterval(3600), maxReservations: Int(numberOfSwypesTextField.text!)!, information: descriptionTextField.text!, userID: (FIRAuth.auth()?.currentUser?.uid)!)
        
        print(diningHallPicker.selectedRow(inComponent: 0))
        
        FirebaseHelperFunctions.uploadEvent(eventToCreate)
        FirebaseHelperFunctions.updateAllEventsObject()
        self.performSegue(withIdentifier: "cancelCreateServiceSegue", sender: nil)
    }
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

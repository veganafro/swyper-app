//
//  FirstViewController.swift
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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    var user = FIRAuth.auth()?.currentUser
    var databaseRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePicture.isUserInteractionEnabled = true
        
        //get user id
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //get reference to user_profile.uid to get a snapshot 
        //snapshot is used as a reference to the database
        self.databaseRef.child("user_profile").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            let userProfile = snapshot.value as? NSDictionary
            let email = userProfile?["email"] as? String
            self.emailLabel.text = email
            
            //search for user profile_picture if not there use default userIcon
            if(userProfile?["profile_picture"] != nil){
                print("existing profile photo!")
                let databaseProfilePic = userProfile?["profile_picture"] as! String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL)
                self.setProfilePicture(imageView: self.profilePicture, imageToSet: UIImage(data:data! as Data)!)
            }
            else{
                self.profilePicture.image = UIImage(named: "userIcon")
            }
        })
        
        FirebaseHelperFunctions.updateAllEventsObject()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(_ sender: UIButton) {
    
        let firebaseAuth = FIRAuth.auth()
        
        do {
        
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
        catch let signOutError as NSError {
            print("ERROR OCCURRED AT SIGN OUT", signOutError.localizedDescription)
        }
    }
    
    @IBAction func doneCreateService(segue: UIStoryboardSegue) {
    }
    
    @IBAction func cancelCreateService(seuge: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //set profile picture function, used in viewDidLoad and did TapProfile
    internal func setProfilePicture(imageView:UIImageView, imageToSet:UIImage){
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    //handle what happesn when profile picture is tapped
    @IBAction func didTapProfilePicture(_ sender: AnyObject) {
        print("tapping profile picture")
        
        let myActionSheet = UIAlertController(title:"Profile Picture", message:"Select", preferredStyle:UIAlertControllerStyle.actionSheet)
        
        //allow user to view full screen image of photo
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default){ (action) in
            let imageView = sender.view! as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target:self, action:#selector(self.dismissFullScreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            
        }
        
        // allow user to open their saved photos and choose (goes to func imagePickerController after)
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default){ (action) in
            print("opening photo gallery")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
                
            }
        }
        
        //allow user to take photo from camera
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){ (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
        print("finish tapping profile photo function")
    }
    
    //dismiss full screen profile photo when it is tapped
    func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    //handle what happens after a photo is selected (updates the profilePicture, the firebase storage and database
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("reached imagePickerController func")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let storageRef = storage.reference(forURL: "gs://swyperio-b9df2.appspot.com")
            
            setProfilePicture(imageView: self.profilePicture, imageToSet: image)
            
            if let imageData: NSData = UIImagePNGRepresentation(self.profilePicture.image!)! as NSData?{
                
                let profilePicStorageRef = storageRef.child("user_profile/\(self.user!.uid)/profile_picture")
                
                let uploadTask = profilePicStorageRef.put(imageData as Data, metadata: nil){ metadata, error in
                    
                    if(error == nil){
                        let downloadUrl = metadata!.downloadURL()
                        
                        self.databaseRef.child("user_profile").child(self.user!.uid).child("profile_picture").setValue(downloadUrl!.absoluteString)
                    }
                    else{
                        print("Hi this is pp1")
                        print(error?.localizedDescription ?? "SOMETHING HAPPENED AT LINE 177 OF PROFILE VIEW CONTROLLER")
                    }
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


//
//  NotesViewController.swift
//  Notes
//
//  Created by Nirav Bavishi on 2018-07-31.
//  Copyright © 2018 Nirav Bavishi. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class NotesViewController: UIViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
     @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var captureBtn: UIButton!
    
 

     let imagePicker = UIImagePickerController()
    var managedObjectContext: NSManagedObjectContext!
    var entry: NSManagedObject!
    
    
    var subjectEntry : String!
    
    
  let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        self.textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        print("Var------------------------------------")
        print(subjectEntry)
        print("Var------------------------------------")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("entry::::::::::")
        print(entry)
        print("+++++++++++++++")
        if entry != nil
        {
            print("1st block")
            self.textView.text = entry.value(forKey: "body") as! String
            
        }
        else{
             print("2st block")
            self.textView.text = ""
           
        }
        // Do any additional setup after loading the view.
        
        // Camera functions
        
    }

  
    
    @IBAction func doneDidClick(_ sender: Any) {
        
        if entry != nil
        {
            self.updateEntry()
        }
        else{
            if textView.text != ""  {
                self.createNewEntry()
                
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    func createNewEntry()
    {
      
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: self.managedObjectContext)
            let notes = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        
        
        notes.setValue(self.textView.text, forKey: "body")
        notes.setValue(NSDate(), forKey: "date")
        notes.setValue(subjectEntry, forKey: "subject")
        
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("Note not save \(error.description)")
        }
    }
    func updateEntry()
    {
        entry.setValue(self.textView.text, forKey: "body")

        entry.setValue(NSDate(), forKey: "date")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("Note not updated \(error.description)")
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: self.managedObjectContext)
        let notes = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
       print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        notes.setValue(userLocation.coordinate.latitude, forKey: "latitude")
        notes.setValue(userLocation.coordinate.longitude, forKey: "longitude")
        
        let latitude = notes.value(forKeyPath: "latitude") as? CLLocationDegrees
        let longitude = notes.value(forKeyPath: "longitude") as? CLLocationDegrees
        
        let coordinate = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                self.location.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
                print("data ...........")
                print(notes)
                print("end data ...........")
            }
        }
        
    }
    
   // Camera Function
    
    @IBAction func captureImage(_ sender: UIButton) {
      
    }
    

    @IBAction func importImage(_ sender: AnyObject) {
       
    }

}


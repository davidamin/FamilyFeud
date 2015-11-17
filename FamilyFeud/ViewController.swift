//
//  ViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 10/18/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var nameBtn: UIButton!
    
    @IBOutlet weak var locLabel: UILabel!
    
    var newPlayer = true
    
    var bahDahDahDaah = AVAudioPlayer()
    
    var username = NSManagedObject?()
    
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameText.delegate = self
        nameBtn.addTarget(self, action: "setName:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Location stuff
        if CLLocationManager.locationServicesEnabled(){
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                createLocationManager(startImmediately: true)
            case .Denied:
                locLabel.text = "Location Permission Denied"
            case .NotDetermined:
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                locLabel.text = "Location Permission Restricted"
            }
        }else{
            locLabel.text = "Location is off"
        }
        
        
        //Database stuff
        /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as? User
        
        newItem!.name = "Test Name"
        newItem!.highScore = 1337
        
        do {
            try managedObjectContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }*/
        
        //Music Stuff
        let themeSong = NSBundle.mainBundle().URLForResource("theme", withExtension: "mp3")
        do{
        try	bahDahDahDaah = AVAudioPlayer(contentsOfURL: themeSong!)
        }catch{
            
        }
        bahDahDahDaah.numberOfLoops = -1
        bahDahDahDaah.volume = 0.5
        bahDahDahDaah.play()
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
            locationManager = CLLocationManager()
            if let manager = locationManager{
                manager.delegate = self
                if startImmediately{
                    manager.startUpdatingLocation()
                }
            }
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if let manager = locationManager{
            manager.delegate = self
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                        
                        if locations.count == 0{
                //handle error here
                return
                        }
                        
                        let newLocation = locations[0]
                        
                        //print("Latitude = \(newLocation.coordinate.latitude)")
                        //print("Longitude = \(newLocation.coordinate.longitude)")
                        locLabel.text = "Location: \(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)"
                        //lat.text = String(newLocation.coordinate.latitude)
                        //lon.text = String(newLocation.coordinate.longitude)
                        
    }
    
    func locationManager(manager: CLLocationManager,
                            didFailWithError error: NSError){
                            print("Location manager failed with error = \(error)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setName(sender: UIButton){
        nameText.resignFirstResponder()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        //Let's check the database for a user with the name we just input
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", nameText.text!)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            //Do we have such a user?
            if(results.count > 0){
                newPlayer = false
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //If we don't, add them and give them a score  of 0
        if(newPlayer){
            let newItem = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as? User
        
            newItem!.name = nameText.text!
            newItem!.highScore = 0
        
            do {
                try managedObjectContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        //nameLabel.text = "Hello " + nameText.text! + ", and welcome to Family Feud!"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            nameText.resignFirstResponder()
            if let destinationVC = segue.destinationViewController as? QuestionViewController{
                destinationVC.userStr = nameText.text!
            }
            if let destinationVC = segue.destinationViewController as? HighScoresViewController{
                destinationVC.name = nameText.text!
            }
    }

}


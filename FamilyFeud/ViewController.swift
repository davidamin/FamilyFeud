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
    
    @IBOutlet weak var passText: UITextField!

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var nameBtn: UIButton!
    
    @IBOutlet weak var scoreBtn: UIButton!
    
    @IBOutlet weak var locLabel: UILabel!
    
    var userStr = ""
    
    var newPlayer = true
    
    var bahDahDahDaah = AVAudioPlayer()
    
    var username = NSManagedObject?()
    
    var locationManager:CLLocationManager?
    
    var logged_in : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameText.delegate = self
        passText.delegate = self
        nameBtn.addTarget(self, action: "setName:", forControlEvents: UIControlEvents.TouchUpInside)
        
        nameText.text = userStr
        
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
        
        
        /*let postEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET")
                print(error)
                return
            }
            //self.nameLabel.text = String(responseData)
            //parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = post["user"] as? String {
                self.nameLabel.text = postTitle
            }
        })
        task.resume()
        */
        
        /*POST CODE
        let postsEndpoint: String = "http://jsonplaceholder.typicode.com/posts"
        guard let postsURL = NSURL(string: postsEndpoint) else {
        print("Error: cannot create URL")
        return
        }
        let postsUrlRequest = NSMutableURLRequest(URL: postsURL)
        postsUrlRequest.HTTPMethod = "POST"
        
        let newPost: NSDictionary = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1]
        do {
        let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
        postsUrlRequest.HTTPBody = jsonPost
        } catch {
        print("Error: cannot create JSON from post")
        }
        */
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
        
        /*if(sender.tag == 0){
        if(logged_in){
            self.performSegueWithIdentifier("StartGameSegue", sender: nil)
            return
        }
        }else{
            if(logged_in){
                self.performSegueWithIdentifier("HighScoreSegue", sender: nil)
                return
            }
        }*/
        let postEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/login/"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        
        do {
            let postString = "username=" + nameText.text! + "&password=" + passText.text!
            urlRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            //let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            //urlRequest.HTTPBody = jsonPost
        } catch {
            print("Error: cannot create JSON from post")
        }
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET")
                print(error)
                return
            }
            //self.nameLabel.text = String(responseData)
            //parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                print(String(responseData))
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let valid = post["ok"] as? Bool{
                if(valid){
                dispatch_async(dispatch_get_main_queue()) {
                    //self.nameLabel.text = "Logged In!"
                    //self.nameBtn.setTitle("Play!", forState: UIControlState.Normal)
                    self.performSegueWithIdentifier("LoginToLandingSegue", sender: nil)
                }
                self.logged_in = true
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.nameLabel.text = post["error"] as? String
                    }
                }
                //self.performSegueWithIdentifier("StartGameSegue", sender: nil)
            }
        })
        task.resume()
        

        
        
        
        
        nameText.resignFirstResponder()
        /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
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
        }*/
        
        //nameLabel.text = "Hello " + nameText.text! + ", and welcome to Family Feud!"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            nameText.resignFirstResponder()
            if let destinationVC = segue.destinationViewController as? LandingViewController{
                destinationVC.userStr = nameText.text!
            }
    }

}


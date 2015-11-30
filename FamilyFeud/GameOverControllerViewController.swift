//
//  GameOverControllerViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/14/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData

class GameOverControllerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var fastLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    var questionTotal = 0
    var fastMoneyTotal = 0
    var gameTotal = 0
    var lifeTotal = 0
    var perfects = 0
    var userStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = String(questionTotal)
        fastLabel.text = String(fastMoneyTotal)
        gameLabel.text = String(gameTotal)
        lifeLabel.text = String(lifeTotal)
        
        
        let dataEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/add_score/"
        guard let url = NSURL(string: dataEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        
        do {
            let dataString = "username=" + userStr + "&questions=" + String(questionTotal) + "&fast=" + String(fastMoneyTotal) + "&perfect_boards=" + String(perfects)
            urlRequest.HTTPBody = dataString.dataUsingEncoding(NSUTF8StringEncoding)
        } catch {
            print("Error: cannot create JSON from post")
        }
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
        })
        task.resume()
        
        /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", userStr)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                results[0].highScore = NSNumber(integer: lifeTotal)
                var gamesPlayed = Int(results[0].gamesPlayed)
                gamesPlayed++
                results[0].gamesPlayed = NSNumber(integer: gamesPlayed)
                var bestGame = Int(results[0].bestGame)
                var bestFast = Int(results[0].bestFast)
                var bestTotal = Int(results[0].bestTotal)
                if (questionTotal > bestGame){
                    results[0].bestGame = NSNumber(integer: questionTotal)
                }
                if (fastMoneyTotal > bestFast){
                    results[0].bestFast = NSNumber(integer: fastMoneyTotal)
                }
                if (gameTotal > bestTotal){
                    results[0].bestTotal = NSNumber(integer: gameTotal)
                }
            }
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? LandingViewController{
            destinationVC.userStr = userStr
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

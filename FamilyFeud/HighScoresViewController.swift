//
//  HighScoresViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/4/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    class board{
        var name: String = ""
        var score: Int = 0
        init(n: String, s: Int){
            name = n
            score = s
        }
    }
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var lifetimeLabel: UILabel!
    @IBOutlet weak var fastLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var perfectLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var highTable: UITableView!
    
    var name: String = ""
    
    var items: [board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.highTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        let postEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/get_high_scores"
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
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            let okay = post["ok"] as? Bool
            let scores = post["scores"] as? NSArray
            
            for score in scores!{
                //var tempName = score["name"] as? String
                //var tempScore = score["score"] as? Int
                if let tempName = score["name"] as? String{
                    if let tempScore = score["score"] as? Int{
                        self.items.append(board(n:tempName, s: tempScore))
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.items = self.items.sort({ $0.score > $1.score})
                self.highTable.reloadData()
            }
        })
        task.resume()
        
        let dataEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/get_user_data/"
        guard let url2 = NSURL(string: dataEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let url2Request = NSMutableURLRequest(URL: url2)
        url2Request.HTTPMethod = "POST"
        
        do {
            let dataString = "username=" + name
            url2Request.HTTPBody = dataString.dataUsingEncoding(NSUTF8StringEncoding)
        } catch {
            print("Error: cannot create JSON from post")
        }
        let task2 = session.dataTaskWithRequest(url2Request, completionHandler: { (data, response, error) in
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
                dispatch_async(dispatch_get_main_queue()) {
                    self.lifetimeLabel.text = String((post["lifetime"] as? Int)!)
                    self.totalLabel.text = String((post["high"] as? Int)!)
                    self.questionsLabel.text = String((post["best_questions"] as? Int)!)
                    self.fastLabel.text = String((post["best_fast"] as? Int)!)
                    self.playedLabel.text = String((post["played"] as? Int)!)
                    self.perfectLabel.text = String((post["perfect_boards"] as? Int)!)
                    var average:Float = 0.0
                    if((post["played"] as? Int) == 0){
                        average = 0
                    }
                    else{
                        average = Float(Float((post["lifetime"] as? Int)!) / Float((post["played"] as? Int)!))
                    }
                    self.averageLabel.text = String(format: "%.1f", average)
                }
                //print(self.lifetime)
                //self.performSegueWithIdentifier("StartGameSegue", sender: nil)
            }
        })
        task2.resume()
        /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "highScore", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                for u in results{
                    items.append(String(u.name) + ": " + String(u.highScore) )
                }
            }else{
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }        // Do any additional setup after loading the view.
        
        let managedObjectContext2 = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest2 = NSFetchRequest(entityName: "User")
        let predicate2 = NSPredicate(format: "name == %@", name)
        
        fetchRequest2.predicate = predicate2
        do {
            let results2 =
            try managedObjectContext2.executeFetchRequest(fetchRequest2) as! [User]
            if(results2.count > 0){
                questionsLabel.text = String(results2[0].bestGame)
                playedLabel.text = String(results2[0].gamesPlayed)
                perfectLabel.text = String(results2[0].perfectBoards)
                lifetimeLabel.text = String(results2[0].highScore)
                fastLabel.text = String(results2[0].bestFast)
                totalLabel.text = String(results2[0].bestTotal)
                var average:Float = 0.0
                if(Int(results2[0].gamesPlayed)==0){
                    average = 0
                }
                else{
                    average = Float(Float(results2[0].highScore) / Float(results2[0].gamesPlayed))
                }
                averageLabel.text = String(average)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(answerTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(answerTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.highTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row].name + ": " + String(self.items[indexPath.row].score)
        
        return cell
    }
    
    func tableView(answerTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? LandingViewController{
            destinationVC.userStr = name
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

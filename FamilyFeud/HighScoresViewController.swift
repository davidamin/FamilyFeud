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
    
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.highTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
        }
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
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(answerTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? ViewController{
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

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
    
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var highTable: UITableView!
    
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.highTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        //figure out how to sort
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

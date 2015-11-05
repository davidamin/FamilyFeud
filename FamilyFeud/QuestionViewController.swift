//
//  QuestionViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 10/25/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var contestantLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var wrongLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var answerTable: UITableView!
    
    @IBOutlet weak var pickerView:UIPickerView!
    
    var items: [String] = []
    var answers: [String] = ["Answer1", "Answer2", "Answer3", "Answer4",""]
    var scores: [Int] = [45, 0,0,15,0]
    var userStr = "User"
    var value = ""
    var score = 0
    var wrong = 0
    var game = 0
    var lifetime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contestantLabel.text = "Contestant: " + userStr
        totalLabel.text = "Total:" + String(game)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", userStr)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                lifetime = Int(results[0].highScore)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.answerTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        value = answers[0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(answerTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(answerTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.answerTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(answerTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    	}
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return answers.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return answers[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = answers[row]
    }
    @IBAction func submitAnswer(sender: UIButton){
        if (!items.contains(value) && value != ""){
            //This is like an extremely shit way to do things, fix next sprint
            if let this_index = answers.indexOf(value){
                let this_score = scores[this_index]
                if( this_score > 0){
                    items.append(value)
                    score += this_score
                    game += this_score
                    scoreLabel.text = String(score)
                    totalLabel.text = "Total:"  + String(game)
                }else{
                    if(wrong < 2){
                        wrong += 1
                        wrongLabel.text = wrongLabel.text! + "X"
                    }else{
                        performSegueWithIdentifier("ResultScreenSegue", sender: nil)
                    }
                }
            
                answers.removeAtIndex(this_index)
                scores.removeAtIndex(this_index)
                }
            
            self.pickerView.reloadAllComponents()
            
            if(answers.count < 2){
                performSegueWithIdentifier("ResultScreenSegue", sender: nil)
            }
            
        }
        self.answerTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", userStr)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                results[0].highScore = NSNumber(integer: lifetime+score)
            }
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if let destinationVC = segue.destinationViewController as? ResultViewController{
            destinationVC.username = userStr
            destinationVC.score = score
            destinationVC.game = game
            destinationVC.life = lifetime + score
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

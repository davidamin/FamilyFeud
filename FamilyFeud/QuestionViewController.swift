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
    var correct: [String] = ["Answer1", "Answer4"]
    var userStr = "User"
    var value = ""
    var score = 0
    var wrong = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contestantLabel.text = "Contestant: " + userStr
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", userStr)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                total = Int(results[0].highScore)
                totalLabel.text = "Total:" + String(total)
            }else{
                totalLabel.text = "Total: 0"
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
            if(correct.contains(value)){
                items.append(value)
                score += 20
                total += 20
                scoreLabel.text = String(score)
                totalLabel.text = "Total:"  + String(total)
            }else{
                if(wrong < 2){
                wrong += 1
                wrongLabel.text = wrongLabel.text! + "X"
                }
            }
            
            answers = answers.filter{$0 != value}//This is the only line of Swift code I've ever liked
            self.pickerView.reloadAllComponents()
            
            
            //This is a terrible way to do things, as we needn't write score every time you submit. But for now...
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "User")
            let predicate = NSPredicate(format: "name == %@", userStr)
            
            fetchRequest.predicate = predicate
            do {
                let results =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
                if(results.count > 0){
                    results[0].highScore = NSNumber(integer: total)
                }
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        self.answerTable.reloadData()
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

//
//  FastMoneyControllerViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/11/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion
import GameplayKit

class FastMoneyControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    class Ans{
        var name: String = ""
        var score: Int = 0
        init(n: String, s: Int){
            name = n
            score = s
        }
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var answerTable: UITableView!
    
    @IBOutlet weak var pickerView:UIPickerView!
    
    var items: [Ans] = []
    var answers: [Ans] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("fastmoney", ofType: "json")
        
        do{
            var jsonData = try NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            //print(jsonDict)
            let randQuestion = jsonDict![Int(arc4random_uniform(UInt32(jsonDict!.count)))]
            questionLabel.text = randQuestion["question"] as? String
            let ansArr = randQuestion["answers"] as? NSArray
            
            for a in ansArr!{
                var tempAns = a["answer"] as? String
                var tempScore = a["score"] as? String
                self.answers.append(Ans(n:tempAns!,s:Int(tempScore!)!))
            }
            self.answers = (GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.answers) as? [Ans])!
            self.pickerView.reloadAllComponents()
        }catch{
            
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
        var cell:UITableViewCell = self.answerTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row].name + ": " + String(self.items[indexPath.row].score)
        
        return cell
    }
    
    func tableView(answerTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("You selected cell #\(indexPath.row)!")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return answers.count
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let str = NSAttributedString(string: answers[row].name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 20.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = str
        pickerLabel.adjustsFontSizeToFitWidth = true
        return pickerLabel
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //value = answers[row].name
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.answers = (GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.answers) as? [Ans])!
            //self.answers = self.answers.sort(){_,_ in arc4random() % 2 == 0}
            self.pickerView.reloadAllComponents()
            self.pickerView.alpha = 0.0
            UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseOut, animations: {
                self.pickerView.alpha = 1.0
                }, completion: {_ in
            })        }
    }
    @IBAction func submitAnswer(sender: UIButton){
        /*var this_row = self.pickerView.selectedRowInComponent(0)
        value = answers[this_row].name
        if (value != ""){
            //This is like an extremely shit way to do things, fix next sprint
            let this_ans = answers.filter{ $0.name == value}.first
            
            let this_score = this_ans?.score
            if( this_score > 0){
                items.append(this_ans!)
                score += this_score!
                game += this_score!
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
            
            answers = answers.filter{$0.name != value}
            items = items.sort{$0.score > $1.score}
            
            self.pickerView.reloadAllComponents()
            
            
            if(answers.filter{$0.score > 0}.count < 1){
                performSegueWithIdentifier("ResultScreenSegue", sender: nil)
            }
            
        }
        self.answerTable.reloadData()
*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
        }*/
        
        /*if let destinationVC = segue.destinationViewController as? ResultViewController{
            destinationVC.username = userStr
            destinationVC.score = score
            destinationVC.game = game
            destinationVC.life = lifetime + score
        }*/
    }
}
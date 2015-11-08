//
//  QuestionViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 10/25/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion
import GameplayKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    struct Ans{
        var name: String = ""
        var score: Int = 0
        init(n: String, s: Int){
            name = n
            score = s
        }
    }
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var contestantLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var wrongLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var answerTable: UITableView!
    
    @IBOutlet weak var pickerView:UIPickerView!
    
    lazy var motionManager = CMMotionManager()
    
    var items: [Ans] = []
    var answers: [Ans] = [Ans(n:"COOKIES", s:3), Ans(n:"DONUT", s:0), Ans(n:"CAKE/CHEESECAKE", s:15), Ans(n:"BURGER", s:0), Ans(n:"ICE CREAM", s:32), Ans(n:"FRENCH FRIES", s:2), Ans(n:"PIZZA", s:14), Ans(n:"RIBS", s:0), Ans(n:"PIE", s:7), Ans(n:"STEAK", s:0), Ans(n:"CANDY/CHOCOLATE", s:13)]
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
        questionLabel.text = "NAME YOUR FAVOURITE FATTENING FOOD"
        wrongLabel.text = ""
        
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
        value = answers[0].name
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
        
        cell.textLabel?.text = self.items[indexPath.row].name + ": " + String(self.items[indexPath.row].score)
        
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
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let str = NSAttributedString(string: answers[row].name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 20.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = str
        pickerLabel.adjustsFontSizeToFitWidth = true
        return pickerLabel
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = answers[row].name
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            //let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.answers)
            self.answers = self.answers.sort(){_,_ in arc4random() % 2 == 0}
            self.pickerView.reloadAllComponents()
            self.pickerView.alpha = 0.0
            UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseOut, animations: {
                self.pickerView.alpha = 1.0
                }, completion: {_ in
            })        }
    }
    @IBAction func submitAnswer(sender: UIButton){
        var this_row = self.pickerView.selectedRowInComponent(0)
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

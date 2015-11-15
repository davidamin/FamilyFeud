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
    
    var prev: [Ans] = []
    var answers: [Ans] = []
    
    var value: String = ""
    var questionIndex : Int = 0
    
    var jsonDict: NSArray = []
    
    var total = 0
    var lifetime = 0
    var used: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalLabel.text = "Total: " + String(total)
        
        let path = NSBundle.mainBundle().pathForResource("fastmoney", ofType: "json")
        
        do{
            var jsonData = try NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
            jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            //print(jsonDict)
            let randIndex = Int(arc4random_uniform(UInt32(jsonDict.count)))
            let randQuestion = jsonDict[randIndex]
            used.append(randIndex)
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
        
        self.answerTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func generateQuestion(){
        self.answers.removeAll()
        var randIndex = Int(arc4random_uniform(UInt32(jsonDict.count)))
        while(used.contains(randIndex)){
            randIndex = Int(arc4random_uniform(UInt32(jsonDict.count)))
        }
        let randQuestion = jsonDict[randIndex]
        used.append(randIndex)
        questionLabel.text = randQuestion["question"] as? String
        let ansArr = randQuestion["answers"] as? NSArray
        
        for a in ansArr!{
            var tempAns = a["answer"] as? String
            var tempScore = a["score"] as? String
            self.answers.append(Ans(n:tempAns!,s:Int(tempScore!)!))
        }
        self.answers = (GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.answers) as? [Ans])!
        self.pickerView.reloadAllComponents()    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(answerTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prev.count
    }
    
    func tableView(answerTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.answerTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.prev[indexPath.row].name + ": " + String(self.prev[indexPath.row].score)
        
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
        var this_row = self.pickerView.selectedRowInComponent(0)
        value = answers[this_row].name
        let this_ans = answers.filter{ $0.name == value}.first
            
        let this_score = this_ans?.score
        
        total += this_score!
        
        totalLabel.text = "Total: " + String(total)

        prev.append(Ans(n:value, s:this_score!))
            
        answers = answers.filter{$0.name != value}
            
        self.pickerView.reloadAllComponents()
            
        self.answerTable.reloadData()
        
        questionIndex++
        
        //Load next question
        if(questionIndex < 5){
            generateQuestion()
        }else{
            performSegueWithIdentifier("GameOverSegue", sender: nil)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationVC = segue.destinationViewController as? GameOverControllerViewController{
            destinationVC.gameTotal = total
            destinationVC.lifeTotal = lifetime + total
        }
    }
}

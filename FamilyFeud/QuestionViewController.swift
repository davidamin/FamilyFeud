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
import AVFoundation

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    class Ans{
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
    
    var rightMus = AVAudioPlayer()
    
    var wrongMus = AVAudioPlayer()
    
    lazy var motionManager = CMMotionManager()

    var items: [Ans] = []
    var answers: [Ans] = []
    var right: [Ans] = []
    var userStr = "User"
    var value = ""
    var score = 0
    var wrong = 0
    var game = 0
    var lifetime = 0
    var round = 0
    var used : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let path = NSBundle.mainBundle().pathForResource("questions", ofType: "json")
        
        do{
        /*var jsonData = try NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        
        let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            //print(jsonDict)
            var randIndex = Int(arc4random_uniform(UInt32(jsonDict!.count)))
            while(used.contains(randIndex)){
                randIndex = Int(arc4random_uniform(UInt32(jsonDict!.count)))
            }
            let randQuestion = jsonDict![randIndex]
            used.append(randIndex)
            questionLabel.text = randQuestion["question"] as? String
            let ansArr = randQuestion["answers"] as? NSArray
            
            for a in ansArr!{
                var tempAns = a["answer"] as? String
                var tempScore = a["score"] as? String
                self.answers.append(Ans(n:tempAns!,s:Int(tempScore!)!))
                if(Int(tempScore!)! > 0){
                    self.right.append(Ans(n:tempAns!,s:Int(tempScore!)!))
                }
            }*/

            
            let postEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/get_question"
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
                let question = post["question"] as? String
                let ansArr = post["answers"] as? NSArray
                
                for a in ansArr!{
                    var tempAns = a["answer"] as? String
                    var tempScore = a["score"] as? String
                    self.answers.append(Ans(n:tempAns!,s:Int(tempScore!)!))
                    if(Int(tempScore!)! > 0){
                        self.right.append(Ans(n:tempAns!,s:Int(tempScore!)!))
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.questionLabel.text = question
                    self.answers = (GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.answers) as? [Ans])!
                    self.pickerView.reloadAllComponents()
                }
            })
            task.resume()
            
            
        }catch{
            
        }
        
        contestantLabel.text = "Contestant: " + userStr
        totalLabel.text = "Total:" + String(game)
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
        //value = answers[0].name
        
        
        let rightSound = NSBundle.mainBundle().URLForResource("correctanswer", withExtension: "wav")
        do{
            try	rightMus = AVAudioPlayer(contentsOfURL: rightSound!)
        }catch{
            
        }
        rightMus.numberOfLoops = 0
        
        let wrongSound = NSBundle.mainBundle().URLForResource("wronganswer", withExtension: "wav")
        do{
            try	wrongMus = AVAudioPlayer(contentsOfURL: wrongSound!)
        }catch{
            
        }
        wrongMus.numberOfLoops = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(answerTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(answerTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = self.answerTable.dequeueReusableCellWithIdentifier("cell")! as? UITableViewCell
        if cell != nil{
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = self.items[indexPath.row].name
        cell!.detailTextLabel?.text = String(self.items[indexPath.row].score)
        cell!.backgroundColor = UIColor.blackColor()
        cell!.textLabel?.textColor = UIColor.whiteColor()
        cell!.detailTextLabel?.textColor = UIColor.whiteColor()
        //cell!.detailTextLabel?.backgroundColor = UIColor.blueColor()
        return cell!
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
        value = answers[row].name
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
        if (value != ""){

            let this_ans = answers.filter{ $0.name == value}.first
            
                let this_score = this_ans?.score
                if( this_score > 0){
                    items.append(this_ans!)
                    score += this_score!
                    game += this_score!
                    scoreLabel.text = String(score)
                    totalLabel.text = "Total:"  + String(game)
                    rightMus.play()
                }else{
                    wrongMus.play()
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
                if(wrong == 0){
                    var perfects = Int(results[0].perfectBoards)
                    perfects += 1
                    results[0].perfectBoards = NSNumber(integer: perfects)
                }
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
            destinationVC.round = round + 1
            destinationVC.used = used
            destinationVC.answers = self.right
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

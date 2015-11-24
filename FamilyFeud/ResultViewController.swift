//
//  ResultViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/4/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    @IBOutlet weak var answerTable: UITableView!
    
    var username = "User"
    
    var score = 0
    var game = 0
    var life = 0
    var round = 0
    var perfects = 0
    var used : [Int] = []
    var answers: [QuestionViewController.Ans] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        gameLabel.text = String(game)
        lifeLabel.text = String(life)
        
        if(round > 2){
            nextBtn.setTitle("Fast Money!", forState: UIControlState.Normal)
        }
        self.answerTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        answers = answers.sort{$0.score > $1.score}
        // Do any additional setup after loading the view.
    }
    
    func tableView(answerTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers.count
    }
    
    func tableView(answerTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = self.answerTable.dequeueReusableCellWithIdentifier("cell")! as? UITableViewCell
        if cell != nil{
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = self.answers[indexPath.row].name
        cell!.detailTextLabel?.text = String(self.answers[indexPath.row].score)
        cell!.backgroundColor = UIColor.blackColor()
        cell!.textLabel?.textColor = UIColor.whiteColor()
        cell!.detailTextLabel?.textColor = UIColor.whiteColor()
        //cell!.detailTextLabel?.backgroundColor = UIColor.blueColor()
        return cell!
    }
    
    func tableView(answerTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAnswer(sender: UIButton){
        //print(round)
        if(round > 2){
        performSegueWithIdentifier("ResultToFastSegue", sender: nil)
        }else{
        performSegueWithIdentifier("NewQuestionSegue", sender: nil)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? QuestionViewController{
            destinationVC.userStr = username
            destinationVC.game = game
            destinationVC.round = round
            destinationVC.used = used
            destinationVC.perfects = perfects
        }
        if let destinationVC = segue.destinationViewController as? FastMoneyControllerViewController{
            destinationVC.lifetime = life
            destinationVC.prior = game
            destinationVC.userStr = username
            destinationVC.perfects = perfects
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

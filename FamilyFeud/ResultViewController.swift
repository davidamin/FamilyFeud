//
//  ResultViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/4/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    var username = "User"
    
    var score = 0
    var game = 0
    var life = 0
    var round = 0
    var used : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        gameLabel.text = String(game)
        lifeLabel.text = String(life)
        
        if(round > 2){
            nextBtn.setTitle("Fast Money!", forState: UIControlState.Normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAnswer(sender: UIButton){
        print(round)
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
        }
        if let destinationVC = segue.destinationViewController as? FastMoneyControllerViewController{
            destinationVC.lifetime = life
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

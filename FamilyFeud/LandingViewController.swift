//
//  LandingViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/29/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    var userStr : String = ""
    
    @IBOutlet weak var contestantLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var highBtn: UIButton!
    
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var logoutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        contestantLabel.text = userStr
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func highScores(sender: UIButton){
        self.performSegueWithIdentifier("MainToHighScoresSegue", sender: nil)
    }
    
    @IBAction func playGame(sender: UIButton){
        self.performSegueWithIdentifier("MainToQuestionSegue", sender: nil)
    }
    
    @IBAction func changePass(sender: UIButton){
        self.performSegueWithIdentifier("MainToChangePassSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? QuestionViewController{
            destinationVC.userStr = userStr
        }
        if let destinationVC = segue.destinationViewController as? HighScoresViewController{
            destinationVC.name = userStr
        }
        if let destinationVC = segue.destinationViewController as? ChangePassViewController{
            destinationVC.username = userStr
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

//
//  ResultViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/4/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    var username = "User"
    
    var score = 0
    var game = 0
    var life = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        gameLabel.text = String(game)
        lifeLabel.text = String(life)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? QuestionViewController{
            destinationVC.userStr = username
            destinationVC.game = game
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

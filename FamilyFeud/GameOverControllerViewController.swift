//
//  GameOverControllerViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/14/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class GameOverControllerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var fastLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    var questionTotal = 0
    var fastMoneyTotal = 0
    var gameTotal = 0
    var lifeTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = String(questionTotal)
        fastLabel.text = String(fastMoneyTotal)
        gameLabel.text = String(gameTotal)
        lifeLabel.text = String(lifeTotal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//
//  QuestionViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 10/25/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var userStr = "User"
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = userStr
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

//
//  ViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 10/18/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var nameBtn: UIButton!
    
    var bahDahDahDaah = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameText.delegate = self
        nameBtn.addTarget(self, action: "setName:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let themeSong = NSBundle.mainBundle().URLForResource("theme", withExtension: "mp3")
        do{
        try	bahDahDahDaah = AVAudioPlayer(contentsOfURL: themeSong!)
        }catch{
            
        }
        bahDahDahDaah.numberOfLoops = -1
                bahDahDahDaah.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setName(sender: UIButton){
        nameLabel.text = "Hello " + nameText.text! + ", and welcome to Family Feud!"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let destinationVC = segue.destinationViewController as? QuestionViewController{
                destinationVC.userStr = nameText.text!
            }
    }

}

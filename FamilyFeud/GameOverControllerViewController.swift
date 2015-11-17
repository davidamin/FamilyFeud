//
//  GameOverControllerViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/14/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit
import CoreData

class GameOverControllerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var fastLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var lifeLabel: UILabel!
    
    var questionTotal = 0
    var fastMoneyTotal = 0
    var gameTotal = 0
    var lifeTotal = 0
    var userStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = String(questionTotal)
        fastLabel.text = String(fastMoneyTotal)
        gameLabel.text = String(gameTotal)
        lifeLabel.text = String(lifeTotal)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "name == %@", userStr)
        
        fetchRequest.predicate = predicate
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if(results.count > 0){
                results[0].highScore = NSNumber(integer: lifeTotal)
                var gamesPlayed = Int(results[0].gamesPlayed)
                gamesPlayed++
                results[0].gamesPlayed = NSNumber(integer: gamesPlayed)
                var bestGame = Int(results[0].bestGame)
                var bestFast = Int(results[0].bestFast)
                var bestTotal = Int(results[0].bestTotal)
                if (questionTotal > bestGame){
                    results[0].bestGame = NSNumber(integer: questionTotal)
                }
                if (fastMoneyTotal > bestFast){
                    results[0].bestFast = NSNumber(integer: fastMoneyTotal)
                }
                if (gameTotal > bestTotal){
                    results[0].bestTotal = NSNumber(integer: gameTotal)
                }
            }
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
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

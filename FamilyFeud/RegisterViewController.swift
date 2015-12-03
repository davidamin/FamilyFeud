//
//  RegisterViewController.swift
//  FamilyFeud
//
//  Created by David Amin on 11/29/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passText: UITextField!
    
    @IBOutlet weak var confirmText: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var privacyBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        emailText.delegate = self
        passText.delegate = self
        confirmText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitDetails(sender: UIButton){
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passText.resignFirstResponder()
        confirmText.resignFirstResponder()
        
        if(passText.text! != confirmText.text!){
            errorLabel.text = "Passwords don't match"
            return
        }
        
        if(!isValidEmail(emailText.text!)){
            return
        }
        
        let postEndpoint: String = "http://ec2-54-174-16-239.compute-1.amazonaws.com/register_user/"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        
        do {
            let postString = "username=" + nameText.text! + "&email=" + emailText.text! + "&password=" + passText.text!
            urlRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            //let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            //urlRequest.HTTPBody = jsonPost
        } catch {
            print("Error: cannot create JSON from post")
        }
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
                print(String(responseData))
                return
            }
            // now we have the post, let's just print it to prove we can access it
            //print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let valid = post["ok"] as? Bool{
                if(valid){
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("RegisterToLandingSegue", sender: nil)
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorLabel.text = post["error"] as? String
                    }
                }
                //self.performSegueWithIdentifier("StartGameSegue", sender: nil)
            }
        })
        task.resume()

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", email)
        if (emailTest.evaluateWithObject(testStr)){
            return true
        }else{
            self.errorLabel.text = "Invalid Email Format"
            return false
        }
    }
    
    @IBAction func openWeb(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://ec2-54-174-16-239.compute-1.amazonaws.com/privacy/")!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? LandingViewController{
            destinationVC.userStr = nameText.text!
        }
    }

}

//
//  ChildInfoViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/24/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ChildInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name_textfield: UITextField!
    var child = Dictionary<String,String>()
    
    @IBOutlet weak var interest_textfield: UITextField!
    @IBAction func name_entered(sender: AnyObject) {
        child["first_name"] = name_textfield.text
        
    }
    @IBAction func age_entered(sender: AnyObject) {
        child["age"] = age_textfield.text
        // TODO : change AyUser model to include age
    }
    @IBAction func gender_entered(sender: AnyObject) {
        let segmented_control = sender as! UISegmentedControl
        println ("Goes in here")
        // Boy
        if(segmented_control.selectedSegmentIndex == 0) {
            println ("Boy selected")
            
            child["gender"] = "male"
        }
        // Girl
        else {
            println ("Girl selected")
            
            child["gender"] = "female"
        }
        
        // TODO : change AyUser model to include gender
    }
    
    @IBAction func interest_entered(sender: AnyObject) {
        println ("interest entered")
        child["interest"] = interest_textfield.text
    }
    
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func infoComplete() -> Bool {
        println (child["gender"])
        println ( child["age"] )

        println (child["first_name"])

        println (child["interest"])

        
        return child["gender"] != nil && child["age"] != nil && child["first_name"] != nil && child["interest"] != nil
        
    }
    
    @IBAction func done_pressed(sender: AnyObject) {
        // Verify data completeness
        if !infoComplete() {
            let alertController = UIAlertController(title: "Incomplete", message: "You need to fill in all the required fields.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                
                //self.dismissViewControllerAnimated(true, completion:nil)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            // Add the child as a family member
            appDelegate.data_manager!.cur_user!.family_members!.append(child)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
    @IBOutlet weak var genderswitch: UISegmentedControl!
    @IBOutlet weak var age_textfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        child["gender"] = "male"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

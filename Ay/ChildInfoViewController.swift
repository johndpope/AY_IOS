//
//  ChildInfoViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/24/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
import Foundation

class ChildInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name_textfield: UITextField!
    var child = FamilyMember()
    
    @IBOutlet weak var interest_textfield: UITextField!
    @IBAction func name_entered(sender: AnyObject) {
        child.name = name_textfield.text
        
    }
    
    @IBAction func age_entered(sender: AnyObject) {
        child.age = age_textfield.text.toInt()!
    }
    
    @IBAction func gender_entered(sender: AnyObject) {
        let segmented_control = sender as! UISegmentedControl
        // Boy
        if(segmented_control.selectedSegmentIndex == 0) {
            println ("Boy selected")
            child.gender = 1
        }
        // Girl
        else {
            println ("Girl selected")
            child.gender = 0
        }
    }
    
    @IBAction func interest_entered(sender: AnyObject) {
        println ("interest entered")
        child.interests = interest_textfield.text
    }
    
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func assign_color(){
        
        let color_strs = ["blue", "green", "yellow", "gray", "orange", "purple"]
        
        let i : Int = Int(arc4random_uniform(6))
        child.color = color_strs[i]
    }
    
    func infoComplete() -> Bool {
        /*return (child.age > 0 ) &&(child.name != nil) && (child.interests != nil)*/
        return true
        
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
            // Assign a random color to the child
            assign_color ()
            // Add the child as a family member
            appDelegate.data_manager!.cur_user!.familyMembers.addObject(child)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
    @IBOutlet weak var genderswitch: UISegmentedControl!
    @IBOutlet weak var age_textfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        child.gender = 1
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

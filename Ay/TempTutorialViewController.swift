
//
//  TempTutorialViewController.swift
//  Ay
//
//  Created by Do Kwon on 6/1/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class TempTutorialViewController: UIViewController {
    let pageTitles = ["Your Family", "Medical", "Education", "Shopping", "Activities & Events"]
    var images = ["logo.png","medical.png","education.png","shopping.png", "shopping.png", "activities.png"]
    
    @IBAction func value_changed(sender: AnyObject) {
        self.title_label.text = String(self.page_control.currentPage)
        
    }

    @IBOutlet weak var page_control: UIPageControl!
    @IBOutlet weak var get_started_btn: UIButton!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var bkImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

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

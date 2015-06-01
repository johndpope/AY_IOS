//
//  TutorialContentViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    func resetFrame(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        frame.origin.y = y
        frame.size.width = width
        frame.size.height = height
        self.frame = frame
    }
    
}

class TutorialContentViewController: UIViewController {
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var bkImageView: UIImageView!
    
    @IBOutlet weak var description_field: UILabel!
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    var descriptionText : String!
    
    
    func add_picture () -> UIImageView{
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        switch pageIndex! {
        case 0 :
            imageView.frame = CGRect(x :110, y: 122, width: 155, height: 186)
            break
        case 1 :
            imageView.frame = CGRect(x :(self.view.frame.width - 105)/2, y: 149, width: 105, height: 122)
            
            break
        case 2 :
            imageView.frame = CGRect(x :(self.view.frame.width - 150)/2, y: 149, width: 150, height: 122)
            break
        case 3 :
            imageView.frame = CGRect(x :(self.view.frame.width - 124)/2, y: 149, width: 124, height: 159)
            break
        case 4 :
            imageView.frame = CGRect(x :(self.view.frame.width - 132)/2, y: 149, width: 132, height: 132)
            break
        default :
            break
        }
        
        imageView.alpha = 0.1
        self.view.addSubview(imageView)
        return imageView
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let img_view = add_picture()
        
        
        self.heading.text = self.titleText
        self.description_field.text = self.descriptionText
        self.description_field.alpha = 0.1
        self.heading.alpha = 0.1
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.heading.alpha = 1.0
            img_view.alpha = 1.0
        })
        UIView.animateWithDuration(2.0, animations: { () -> Void in
             self.description_field.alpha = 1.0
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.bkImageView.image = UIImage(named: imageName)
        
        self.heading.text = ""
        self.description_field.text = ""

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

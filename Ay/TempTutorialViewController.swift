//
//  TempTutorialViewController.swift
//  Ay
//
//  Created by Do Kwon on 6/2/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class TempTutorialViewController: UIViewController, UIScrollViewDelegate {
 
    @IBAction func value_changed(sender: AnyObject) {
    }
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var mypageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fixFonts()
        setupChildViews()
    }

    func fixFonts() {
        //self.titleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 24)
        //self.subtitleLabel.font = UIFont (name: "HelveticaNeue-UltraLight", size: 20)
        
        self.start_btn.backgroundColor = UIColor(red:0.58, green:0.58,blue:0.58,alpha:1.0)
        
        self.mypageControl.pageIndicatorTintColor = UIColor(red:0.85, green:0.85,blue:0.85,alpha:1.0)
        self.mypageControl.currentPageIndicatorTintColor = UIColor(red:0.51, green:0.51,blue:0.51,alpha:1.0)
    }
    
    let pageTitles = ["Your Family Calendar", "Medical", "Education", "Shopping", "Activities & Events"]
    let pageDescriptions = ["Just got smarter\n\n",
        "Stay up-to-date with immunization dates & neighborhood epidemics",
        "Find out what your kid needs to be doing to exel in school",
        "personalized recommendations for products your family will love",
        "Maximize your child's extracurricular potential"]
    
    var images = ["logo.png","medical.png","education.png","shopping.png","activities.png"]
    
    func add_picture (imageName : String, pageIndex : Int) -> UIImageView{
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        switch pageIndex {
        case 0 :
            imageView.frame = CGRect(x :129, y: 142, width: 116, height: 139)
            break
        case 1 :
            imageView.frame = CGRect(x :(self.view.frame.width - 104)/2, y: 153, width: 104, height: 122)
            
            break
        case 2 :
            imageView.frame = CGRect(x :(self.view.frame.width - 150)/2, y: 149, width: 150, height: 122)
            break
        case 3 :
            imageView.frame = CGRect(x :(self.view.frame.width - 128)/2, y: 159, width: 128, height: 112)
            break
        case 4 :
            imageView.frame = CGRect(x :(self.view.frame.width - 132)/2, y: 149, width: 132, height: 132)
            break
        default :
            break
        }
        
        return imageView
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width;
        let xPos = scrollView.contentOffset.x+10;
        
        //Calculate the page we are on based on x coordinate position and width of scroll view
        self.mypageControl.currentPage = Int(xPos/width)
    }
    
    func setupChildViews() {
        
        let size :CGSize = UIScreen.mainScreen().bounds.size
        let scrollView = UIScrollView (frame : CGRectMake(0, 0, size.width, size.height - 151))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(size.width, size.height - 151)
        self.view.addSubview (scrollView)
        
        for (var i = 0; i < pageTitles.count; i++) {
            let cur_view = UIView()
            cur_view.frame = CGRectMake(size.width * CGFloat(i), 0, size.width, size.height - 151)
            scrollView.addSubview (cur_view)
            
            
            let title = pageTitles[i]
            let description = pageDescriptions[i]
            let image_view = add_picture (images[i], pageIndex : i)
            
            
            let title_size = CGSizeMake(300, 50)
            let titleLabel = UILabel (frame : CGRectMake( (size.width - title_size.width) / 2, 320, title_size.width, title_size.height))
            titleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 24)
            titleLabel.text = title
            titleLabel.textAlignment = .Center
            cur_view.addSubview(titleLabel)
            
            
            let subtitle_size = CGSizeMake(300, 150)
            let subtitleLabel = UILabel (frame : CGRectMake( (size.width - subtitle_size.width) / 2, 390, title_size.width, title_size.height))
            subtitleLabel.numberOfLines = 2
            subtitleLabel.font = UIFont (name: "HelveticaNeue-UltraLight", size: 20)
            subtitleLabel.text = description
            subtitleLabel.textAlignment = .Center
            cur_view.addSubview(subtitleLabel)
            
            
            cur_view.addSubview(image_view)
            
        }
        scrollView.contentSize = CGSizeMake(size.width * CGFloat(pageTitles.count), size.height - 151)
        
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

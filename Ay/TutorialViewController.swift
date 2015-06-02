//
//  TutorialViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource  {
    
    let pageTitles = ["A smart family calendar", "Medical", "Education", "Shopping", "Activities & Events"]
    let pageDescriptions = ["Get smart recommendations for your family.", "Stay up-to-date with immunization dates & neighborhood epidemics.", "Find out what your kid needs to be doing to exel in school", "Buy what you'll need and love.", "Maximize your child's extracurricular potential"]
    
    var images = ["logo.png","medical.png","education.png","shopping.png","activities.png"]
    var count = 0
    
   
    
    /*func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
            }*/
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.backgroundColor = UIColor.whiteColor()
    }
    
    func reset() {
        /* Getting the page View controller */
        /*pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TutorialViewController") as! UIPageViewController*/
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        //self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 30)
        //self.addChildViewController(pageViewController)
        //self.view.addSubview(pageViewController.view)
        //self.didMoveToParentViewController(self)
    }
    @IBAction func motionDetected(sender: AnyObject) {
        
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                println("Swiped right")
                //self.view.removeFromSuperview()
                //self.removeFromParentViewController()
                reset()
                break
                
            case UISwipeGestureRecognizerDirection.Left:
                println("Swiped left")
                break
            default:
                println("Default")
                break
            }
        }

    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        setupPageControl()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "motionDetected:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "motionDetected:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! TutorialContentViewController).pageIndex!
        index++
        if(index >= self.images.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContentViewController).pageIndex!
        println (index)
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TutorialContentViewController") as! TutorialContentViewController
        
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.descriptionText = self.pageDescriptions[index]
        pageContentViewController.titleText = self.pageTitles[index]
        
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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

//
//  ViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //This comment is for git
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Retrieve next or prev month NSDate instance */
    func getMonthOffset (offset :Int) -> NSDate {
        let d = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: offset, toDate: NSDate(), options: nil)
        return d!
    }
    
    func loadSwipeData() {
        
        let now = NSDate()
        
        
        
        /* 1) Create a scrollable viewcontroller showing the details of every deal,
        * and add to the scrollview. TODO: consider payloading deals in constant numbered
        * chunks to improve performance.
        */
        /*var page_count :Int = 0
        
        for deal in all_deals {
            let deal_detail_vc = DealDetailViewController(nibName:"MonthlyCalendarView", bundle:nil)
            deal_detail_vc.showing_deal = deal
            
            // 2) Add in each view to the container view hierarchy
            //    Add them in opposite order since the view hieracrhy is a stack
            self.addChildViewController(deal_detail_vc);
            self.scrollView!.addSubview(deal_detail_vc.view);
            deal_detail_vc.didMoveToParentViewController(self);
            
            // 3) Set up the frames of the view controllers to align
            //    with eachother inside the container view
            var adminFrame :CGRect = self.scrollView.frame
            adminFrame.origin.x = adminFrame.width * CGFloat (page_count)
            deal_detail_vc.view.frame = adminFrame
            
            // 4) Finally set the size of the scroll view that contains the frames
            var scrollWidth: CGFloat  = CGFloat(all_deals.count) * self.view.frame.width
            var scrollHeight: CGFloat  = self.view.frame.size.height
            self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
            
            page_count += 1
        }*/
        
    }
    
    /* Loads data in the swipeviewcontroller
    */
    override func viewDidAppear(animated: Bool) {
        loadSwipeData()
    }


}


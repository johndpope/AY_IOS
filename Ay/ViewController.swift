//
//  ViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
//import CVCalendar

class ViewController: UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    /*@IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func addPressed(sender: AnyObject) {
        println ("MainView controller : add button pressed ");
    }
    @IBAction func settingsPressed(sender: AnyObject) {
        println ("MainView controller : setting button pressed ")
    }
    
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    var showing_date : NSDate?
    var calendar_index : Int = 0
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                println("Swiped right")
                calendar_index += 1
                break;
            case UISwipeGestureRecognizerDirection.Left:
                println("Swiped left")
                calendar_index -= 1
                break;
            default:
                break
            }
        }
        
        // Get month by offset by calendar_index
        showing_date = getMonthToOffset()
        
        loadSwipeData()
    }
    
    /* Set up swipe recognizers for calendarview */
    func setupSwipeRecognizers() {
        // Set up swipe
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the showing date to the current time
        //self.showing_date = NSDate()
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.setupSwipeRecognizers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }
    
    /* Retrieve next or prev month NSDate instance */
    /*func getMonthToOffset () -> NSDate {
        let d = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: calendar_index, toDate: NSDate(), options: nil)
        return d!
    }
    
    func loadSwipeData() {
        
        let calendar_vc = CalendarViewController(coder: NSCoder())
        
        var adminFrame :CGRect = self.scrollView.frame
        adminFrame.origin.x = adminFrame.width * CGFloat (calendar_index)
        calendar_vc.view.frame = adminFrame
        
        //2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack
        self.addChildViewController(calendar_vc);
        self.scrollView!.addSubview(calendar_vc.view);
        calendar_vc.didMoveToParentViewController(self);
    }
    
    /* Loads data in the swipeviewcontroller
    */
    override func viewDidAppear(animated: Bool) {
        loadSwipeData()
    }*/


}


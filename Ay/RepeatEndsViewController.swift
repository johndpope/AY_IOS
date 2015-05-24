//
//  RepeatEndsViewController.swift
//  Ay
//
//  Created by Ki Suk Jang on 5/22/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class RepeatEndsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    private var endDatePickerHidden = false
    private var end_date_cell : EndDateCell!
    private var end_date_picker_cell : EndTimePickerCell!
    
    private var return_val = NSMutableDictionary()
    
    var onDataAvailable : ((data: NSDictionary) -> ())?
    var onDate : NSDate!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelPressed(sender: AnyObject) {
        if onDate != nil{
            return_val.setObject(onDate, forKey: "date")
        }
        self.onDataAvailable?(data: return_val)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initializeDatePickers()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeDatePickers(){
        toggleEndDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 3
        default :
            return 1
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(repeat_ends_never_cell_identifier) as? UITableViewCell
            } else if indexPath.row == 1{
                cell = tableView.dequeueReusableCellWithIdentifier(repeat_ends_end_date_cell_identifier) as? EndDateCell
                end_date_cell = cell as! EndDateCell
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(repeat_ends_end_date_picker_cell_identifier) as? EndTimePickerCell
                end_date_picker_cell = cell as! EndTimePickerCell
            }
            break
        default :
            // Should never get here...
            cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)

        if row == Row.EndDatePicker {
            if endDatePickerHidden {
                return 0
            } else {
                return 160
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)

        // close date picker if opened
        if row != Row.EndDate && !endDatePickerHidden{
            toggleEndDatePicker()
        }
        
        // open date picker
        if row == Row.EndDate{
            toggleEndDatePicker()
        } else if row == Row.Never {
            onDate = nil
        }
    }
    
    @IBAction
    func didChangeEndDate() {
        onDate = end_date_picker_cell.datePicker.date
    }
    
    private func toggleEndDatePicker() {
        endDatePickerHidden = !endDatePickerHidden
        
        // Force table to update its contents
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private enum Row: Int {
        case Never
        case EndDate
        case EndDatePicker
        
        case Unknown
        
        
        init(indexPath: NSIndexPath) {
            var row = Row.Unknown
            
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                row = Row.Never
            case (0, 1):
                row = Row.EndDate
            case (0, 2):
                row = Row.EndDatePicker
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}

//
//  FilterViewController.swift
//  Yelp
//
//  Created by Jianfeng Ye on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func applyFilter(filterView: FilterViewController, filters: [String: AnyObject])
}

class FilterViewController: UIViewController, UITableViewDataSource, FilterSwitchDelegate {
    @IBOutlet weak var filtersTableView: UITableView!
    
    var delegate: FilterViewDelegate?
    let filterGroups = [["Best match", "Distance", "Highest rated"],
        ["Asian Fusion", "Chinese", "Comfort Food", "French", "Japanese", "Kebab", "Mediterranean", "Seafood", "Spanish", "Steakhouses", "Sushi Bars", "Tapas Bars", "Taiwanese", "Vietnamese"],
        ["1 mi", "5 mi", "10 mi", "25 mi"],
        ["Deal"]]
    let filterGroupsTitle = ["Sort", "Category", "Radius", "Deal"]
    var selectedFilters: [[Int: Bool]] = [[0: true], [:], [2: true], [:]]
    
    let categoryParams = ["asianfusion", "chinese", "comfortfood", "french", "japanese", "kebab", "mediterranean", "seafood", "spanish", "steak", "sushi", "tapas", "taiwanese", "vietnamese"]
    let radiusParams = [1.0, 5.0, 10.0, 25.0]
    
    var filters: [String: AnyObject] {
        get {
            var result: [String: AnyObject] = [:]
            var sort = 0
            for (k, v) in selectedFilters[0] {
                if v {
                    sort = k
                }
            }
            result["sort"] = sort
            
            var categories = ""
            for (k, v) in selectedFilters[1] {
                if v {
                    categories += ",\(categoryParams[k])"
                }
            }
            if categories != "" {
                result["category_filter"] = (categories as NSString).substringFromIndex(1)
            }
            
            var radius: Float = 1.0
            for (k, v) in selectedFilters[2] {
                if v {
                    radius =  Float(radiusParams[k]) / milesPerMeter
                }
            }
            result["radius_filter"] = radius
            
            var deal = false
            for (k, v) in selectedFilters[3] {
                if v {
                    deal = true
                }
            }
            if deal {
                result["deals_filter"] = true
            }
            
            return result
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onApply(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.applyFilter(self, filters: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGroups[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterGroupsTitle.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterGroupsTitle[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as FilterTableViewCell
        
        let filterName = filterGroups[indexPath.section][indexPath.row]
        cell.filterLabel.text = filterName
        
        var selectedDict = selectedFilters[indexPath.section]
        cell.filterSwitch.on = false
        if let selected = selectedDict[indexPath.row] {
            cell.filterSwitch.on = selected as Bool
        }
        
        cell.delegate = self
        
        return cell;
    }
    
    func onFilterSwitchValueChanged(cell: FilterTableViewCell, value: Bool) {
        let index = self.filtersTableView.indexPathForCell(cell)!
        let sec = index.section
        if sec == 0 || sec == 2 {
            selectedFilters[sec] = [:]
        }
        selectedFilters[sec][index.row] = value
        
        self.filtersTableView.reloadData()
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

//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, FilterViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var businesses: [Business] = []
    
    let locationManager = CLLocationManager()
    
    var coord: String {
        get {
            if let loc = locationManager.location {
                return "\(loc.coordinate.latitude), \(loc.coordinate.longitude)"
            }
            return ""
        }
    }
    
    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    var searchTerm: String = "Restaurants"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.tableView.registerNib(UINib(nibName: "BusinessTableViewCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        queryWithFilters()
    }
    
    func onRefresh() {
        queryWithFilters()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(manager.location.coordinate.latitude)
        println(manager.location.coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error trying to get current location")
    }
    
    func queryWithFilters(filters: [String : AnyObject] = [:]) {
        businesses = []
        tableView.reloadData()
        SVProgressHUD.show()

        client.searchWithTerm(searchTerm, params: filters, coord: coord, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println((response as NSDictionary)["businesses"])
            let responseData = response as NSDictionary
            let allBusinessData = responseData["businesses"] as NSArray
            for businessData in allBusinessData {
                self.businesses.append(Business(data: businessData as NSDictionary))
            }
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onFiltersButton(sender: AnyObject) {
        var filtersView = storyboard?.instantiateViewControllerWithIdentifier("FiltersView") as FilterViewController
        filtersView.delegate = self
        self.presentViewController(filtersView, animated: true, completion: nil)
    }
    
    func applyFilter(filterView: FilterViewController, filters: [String : AnyObject]) {
        queryWithFilters(filters: filters)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessTableViewCell
        
        if indexPath.row < businesses.count {
            cell.setup(businesses[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = businesses[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: selected.redirectUrl)!)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchTerm = searchBar.text
        searchBar.endEditing(true)
        queryWithFilters()
    }
}


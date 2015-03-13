//
//  ViewController.swift
//  DatabaseTypeOnSwift
//
//  Created by Yosemite on 1/21/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvMain: UITableView!
    
    var items = ["NSUserdefault":"Use NSUserdefault to save data","Plist file":"Import plist file to manage data","CoreData":"Usign CoreData to manage Data", "SQLlite":"Using SQLlite packed", "Text file":"Import file text to manage data", "XML file":"Using XML file to manage data"]
    
    var arrayKeys: [String] = []
    
    var arrayValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tvMain.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        arrayKeys = [String](items.keys)
        
        arrayValues = [String](items.values)
        
//        //
//        var shotPercentageInt: Int
//        shotPercentageInt = Int(0.6)
//        println("\(shotPercentageInt*100)%") // 0% because 3/5 = 0.6 -> Int = 0
//        
//        //
//        var shotPercentageFloat: Float
//        shotPercentageFloat = 3/5
//        println("\(shotPercentageFloat*100)%") // 60.0% because 3/5 = 0.6 -> Float = 60%
//        
//        // Convert Float to Int
//        var shotPercentageFloatToInt: Int
//        shotPercentageFloatToInt = Int(shotPercentageFloat)
//        println("\(shotPercentageFloat)") // 0.6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tvMain: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tvMain: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = arrayKeys[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.blueColor()
        
        cell.detailTextLabel?.text = arrayValues[indexPath.row]
        
        cell.detailTextLabel?.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: 13)
               
        cell.imageView?.image = UIImage(named: arrayKeys[indexPath.row])
        
        return cell
    }
    
    func tableView(tvMain: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("segueContact", sender: nil)

    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations:
            { cell.layer.transform = CATransform3DMakeScale(1,1,1) })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject!){
            
            let indexPath : NSIndexPath = self.tvMain.indexPathForSelectedRow()!
            //make sure that the segue is going to secondViewController
            let contact = segue.destinationViewController as ContactVC
            contact.keyType = self.arrayKeys[indexPath.row]
            
    }
}


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
    
    var items = ["NSUserdefault":"Use NSUserdefault to save data","Plist file":"Import plist file to manage data","CoreData":"Choose check box CoreData when new project", "SQLlite":"Using SQLlite packed", "Text file":"Import file text to manage data", "XML file":"Using XML file to manage data"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tvMain.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
        
        var arrayKeys = [String](items.keys)
        
        var arrayValues = [String](items.values)
        
        cell.textLabel?.text = arrayKeys[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.blueColor()
        
        cell.detailTextLabel?.text = arrayValues[indexPath.row]
        
        return cell
    }
    
    func tableView(tvMain: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
}


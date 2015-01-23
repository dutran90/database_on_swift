//
//  ContactVC.swift
//  DatabaseTypeOnSwift
//
//  Created by Yosemite on 1/22/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import Foundation
import UIKit

class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    var keyType: String?
    
    @IBOutlet weak var btnNew: UIBarButtonItem!
    @IBOutlet weak var barbtnBack: UIBarButtonItem!
    @IBOutlet weak var tbvContact: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        
        println(self.keyType)

    }
    
    func tableView(tbvContact: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tvMain: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        return cell
    }
    
    override func prepareForSegue(segueAddNew: UIStoryboardSegue, sender: AnyObject?) {
        let contactDetail = segueAddNew.destinationViewController as ContactDetail
        contactDetail.checkNew  = true
        contactDetail.keyType = self.keyType
    }
    
    
    
}
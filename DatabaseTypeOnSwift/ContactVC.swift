//
//  ContactVC.swift
//  DatabaseTypeOnSwift
//
//  Created by Yosemite on 1/22/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //
    var keyType: String?
    
    @IBOutlet weak var btnNew: UIBarButtonItem!
    @IBOutlet weak var barbtnBack: UIBarButtonItem!
    @IBOutlet weak var tbvContact: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contact: ContactObj?
    
    var arrName: [String] = []
    var arrPhone: [String] = []
    var arrMail: [String] = []
    
    var filteredName: [String]!
    var filteredPhone: [String]!
    var filteredMail: [String]!
    
    var is_searching:Bool!   // It's flag for searching
    
    var coreContact  = [NSManagedObject]()
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        
        println(self.keyType)
        
        is_searching = false
        
        if keyType == "NSUserdefault"{
            
            (arrName, arrPhone, arrMail) = getContactFromNS()
            (filteredName, filteredPhone, filteredMail) = ([],[],[])
            
        }
        
        if keyType == "Plist file"{
        
            (arrName, arrPhone, arrMail) = getContactFromPlist()
            (filteredName, filteredPhone, filteredMail) = ([],[],[])
            
        }
        
        if keyType == "Text file"{
            
            (arrName, arrPhone, arrMail) = getContactFromText()
            (filteredName, filteredPhone, filteredMail) = ([],[],[])
            
        }
        
        if keyType == "CoreData"{
            
            (arrName, arrPhone, arrMail) = getContactFromCoreData()
            (filteredName, filteredPhone, filteredMail) = ([],[],[])
            
        }
        
        if keyType == "SQLlite"{
            
            //Create database
            let filemgr = NSFileManager.defaultManager()
            let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
            let docsDir = dirPaths[0] as String
            
            databasePath = docsDir.stringByAppendingPathComponent(
                "contacts.db")
            
            if !filemgr.fileExistsAtPath(databasePath) {
                
                let contactDB = FMDatabase(path: databasePath)
                
                if contactDB == nil {
                    println("Error: \(contactDB.lastErrorMessage())")
                }
                
                if contactDB.open() {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME, PHONE, EMAIL)"
                    if !contactDB.executeStatements(sql_stmt) {
                        println("Error: \(contactDB.lastErrorMessage())")
                    }
                    contactDB.close()
                } else {
                    println("Error: \(contactDB.lastErrorMessage())")
                }
            }
            
            (arrName, arrPhone, arrMail) = getContactFromSQLlite()
            (filteredName, filteredPhone, filteredMail) = ([],[],[])
            
        }
        
        tbvContact.reloadData()

    }
    
    func tableView(tbvContact: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_searching == false{
            return arrName.count
        }else{
            return filteredName.count
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            is_searching = false
            tbvContact.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            filteredName = []
            filteredPhone = []
            filteredMail = []
            for var index = 0; index < arrName.count; index++
            {
                var currentString = arrName[index] as String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    filteredName.append(arrName[index])
                    filteredPhone.append(arrPhone[index])
                    filteredMail.append(arrMail[index])
                }
            }
            tbvContact.reloadData()
        }
    }
    
    func tableView(tbvContact: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        if is_searching == false{
            cell.textLabel?.text = arrName[indexPath.row]
            
            cell.detailTextLabel?.text = " \(arrPhone[indexPath.row])     \(arrMail[indexPath.row]) "
        }else{
            cell.textLabel?.text = filteredName[indexPath.row]
            
            cell.detailTextLabel?.text = " \(filteredPhone[indexPath.row])     \(filteredMail[indexPath.row]) "
        }
        

        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations:
            { cell.layer.transform = CATransform3DMakeScale(1,1,1) })
    }
    
    // use delete action cell
    func tableView(tbvContact: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            var name: String
            if is_searching == false{
                name = arrName[indexPath.row]
                arrName.removeAtIndex(indexPath.row)
                arrPhone.removeAtIndex(indexPath.row)
                arrMail.removeAtIndex(indexPath.row)
            }else{
                name = filteredName[indexPath.row]
                filteredName.removeAtIndex(indexPath.row)
                filteredPhone.removeAtIndex(indexPath.row)
                filteredMail.removeAtIndex(indexPath.row)
            }

            tbvContact.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            //delete on database
            if keyType == "NSUserdefault"{
                delContactFromNS(name)
            }
            if keyType == "Plist file"{
                delContactFromPlist(name)
            }
            if keyType == "CoreData"{
                delContactFromCoreData(name)
            }
            if keyType == "SQLlite"{
                delContactFromSQLlite(name)
            }
            if keyType == "Text file"{
                delContactFromText(name)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAddNew" {
            if sender?.integerValue == 1{
                println("detail")
                let contactDetail = segue.destinationViewController as ContactDetail
                contactDetail.checkNew  = false
                contactDetail.keyType = self.keyType
                let indexPath = tbvContact.indexPathForSelectedRow()!
                if is_searching == false{
                    contactDetail.selectedName = arrName[indexPath.row]
                    contactDetail.selectedPhone = arrPhone[indexPath.row]
                    contactDetail.selectedEmail = arrMail[indexPath.row]
                }else{
                    contactDetail.selectedName = filteredName[indexPath.row]
                    contactDetail.selectedPhone = filteredPhone[indexPath.row]
                    contactDetail.selectedEmail = filteredMail[indexPath.row]
                }
            }
            else{
                println("add new")
                let contactDetail = segue.destinationViewController as ContactDetail
                contactDetail.checkNew  = true
                contactDetail.keyType = self.keyType
            }
        }
    }
    
    func getContactFromNS() -> ([String], [String], [String]){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let arrDic = ud.valueForKey("arrDicContact") as NSArray!
        var arrName = [String]()
        var arrPhone = [String]()
        var arrEmail = [String]()
        if arrDic != nil{
            for dic in arrDic{
                arrName.append(dic.valueForKey("name") as String)
                arrPhone.append(dic.valueForKey("phone") as String)
                arrEmail.append(dic.valueForKey("email") as String)
            }
        }
        return (arrName, arrPhone, arrEmail)
        
    }
    
    func getContactFromPlist() -> ([String], [String], [String]){
        
        var arrName = [String]()
        var arrPhone = [String]()
        var arrEmail = [String]()
        
        let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
        
        var content = NSMutableArray(contentsOfFile: path)
        
        println(content)

        for dic in content!{
            arrName.append(dic.valueForKey("name") as String)
            arrPhone.append(dic.valueForKey("phone") as String)
            arrEmail.append(dic.valueForKey("mail") as String)
        }
        
        return (arrName,arrPhone,arrEmail)
    }
    
    func getContactFromText() -> ([String], [String], [String]){
        
        var arrName = [String]()
        var arrPhone = [String]()
        var arrEmail = [String]()
        
        let url = NSBundle.mainBundle().URLForResource("contact", withExtension: "rtf")
        
        var atStr = NSAttributedString(fileURL: url, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
        
        var str = atStr?.string
        
        var arrContact = str?.componentsSeparatedByString("\n")
        
        if arrContact == nil{
            if str == nil{
                (arrName, arrPhone, arrEmail) = ([],[],[])
            }else{
                let info = str?.componentsSeparatedByString("\t") as Array!
                arrName.append(info[0])
                arrPhone.append(info[1])
                arrEmail.append(info[2])
            }
        }else{
            for (idx, ct) in enumerate(arrContact!){
                let info = ct.componentsSeparatedByString("\t")
                arrName.append(info[0])
                arrPhone.append(info[1])
                arrEmail.append(info[2])
            }
        }
        
        return (arrName,arrPhone,arrEmail)
    }
    
    func getContactFromCoreData() -> ([String], [String], [String]){
        
        var arrName = [String]()
        var arrPhone = [String]()
        var arrEmail = [String]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        var error: NSError?
        
        let fetchchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchchedResults {
            coreContact = results
            println("Core contact \(coreContact)")
        }else{
            println("Could not fetch \(error), \(error?.userInfo)")
        }
        
        for dic in coreContact{
            arrName.append(dic.valueForKey("name") as String)
            arrPhone.append(dic.valueForKey("phone") as String)
            arrEmail.append(dic.valueForKey("email") as String)
        }
        
        return (arrName,arrPhone,arrEmail)
    }

    func getContactFromSQLlite() -> ([String], [String], [String]){
        
        var arrName = [String]()
        var arrPhone = [String]()
        var arrEmail = [String]()
        
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let querySQL = "SELECT name, phone, email FROM CONTACTS"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)!
            
            println(results)

            if results?.next() == true{
                
                while (results?.next() ==  true){
                    var n = results?.stringForColumn("name")
                    var p = results?.stringForColumn("phone")
                    var e = results?.stringForColumn("email")
                    
                    arrName.append(n!)
                    arrPhone.append(p!)
                    arrEmail.append(e!)
                }
            
            }
            
            contactDB.close()
        }
        
        return (arrName,arrPhone,arrEmail)
    }

    
    func delContactFromNS(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        let arrDic = ud.valueForKey("arrDicContact") as NSMutableArray
        for (idx, dic) in enumerate(arrDic){
            if dic["name"] as String == name{
                arrDic.removeObjectAtIndex(idx)
                println("Array Dic after delete \(arrDic)")
            }
        }
    }
    
    func delContactFromCoreData(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        var error: NSError?
        
        let fetchchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        for dic in fetchchedResults!{
            if dic.valueForKey("name") as String == name{
                managedContext.deleteObject(dic)
            }
        }
        
    }
    
    func delContactFromPlist(name: String) {
        let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
        
        var content = NSMutableArray(contentsOfFile: path)
        
        for dic in content!{
            if dic["name"] as String == name{
                content!.removeObject(dic)
            }
        }
        
        content!.writeToFile(path, atomically: true)
        
    }
    
    func delContactFromSQLlite(name: String) {
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let querySQL = "DELETE FROM CONTACTS WHERE name = '\(name)'"
            
            let result = contactDB.executeStatements(querySQL)
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            if (results != nil){
                println("error!")
            }
            contactDB.close()
        }
    }
    
    func delContactFromText(name: String) {
        let url = NSBundle.mainBundle().URLForResource("contact", withExtension: "rtf")
        let path = NSBundle.mainBundle().pathForResource("contact", ofType: "rtf")
        
        var atStr = NSAttributedString(fileURL: url, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
        
        var str = atStr?.string
        
        var newStr = ""
        
        var arrContact = str?.componentsSeparatedByString("\n")
        
        if arrContact == nil{
            newStr.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            return
        }else{
            if arrContact?.count == 1{
                for (idx, ct) in enumerate(arrContact!){
                    let info = ct.componentsSeparatedByString("\t")
                    if info[0] != name{
                        newStr = newStr + info[0]
                        newStr = newStr + "\t" + info[1] + "\t" + info[2]
                    }
                }
                var errors: NSError?
                newStr.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: &errors)
                if let theError = errors {
                    print("\(theError.localizedDescription)")
                }

            }else{
                for (idx, ct) in enumerate(arrContact!){
                    let info = ct.componentsSeparatedByString("\t")
                    if info[0] != name{
                        newStr = newStr + "\n" + info[0]
                        newStr = newStr + "\t" + info[1] + "\t" + info[2]
                    }
                }
                var errors: NSError?
                newStr.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: &errors)
                if let theError = errors {
                    print("\(theError.localizedDescription)")
                }
            }
        }
    }

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //edit
        
        self.performSegueWithIdentifier("segueAddNew", sender: 1)
        
    }
    
    
}
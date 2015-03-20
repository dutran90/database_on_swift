//
//  ContactDetail.swift
//  DatabaseTypeOnSwift
//
//  Created by Yosemite on 1/22/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactDetail: UIViewController, UITextFieldDelegate , ValidationFieldDelegate{
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let validator = Validator()
    let Fields = ["Email", "Phone"]
    
    var checkNew: Bool?
    var keyType: String?
    
    var validPhone = false
    var validEmail = false
    var validName = false
    var addNewSuccess = false
    
    //Selected Detail
    var selectedName: String?
    var selectedPhone: String?
    var selectedEmail: String?
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        
        //valid mail and phone
        
        tfEmail.delegate = self
        tfPhone.delegate = self
        
        validator.registerFieldByKey(
            Fields[0],
            textField: tfEmail,
            rules: [.Required, .Email]
        )
        
        validator.registerFieldByKey(
            Fields[1],
            textField: tfPhone,
            rules: [.Required, .PhoneNumber]
        )
        
        //show detail
        if self.checkNew == false{
            tfName.text = selectedName
            tfPhone.text = selectedPhone
            tfEmail.text = selectedEmail
        }
        
    }
    
    func validationFieldFailed(key:String, error:ValidationError)
    {
        //set error text field to red
        error.textField.backgroundColor = UIColor.redColor()
        validEmail = false
        validPhone = false
    }
    
    func validationFieldSuccess(key:String, validField:UITextField)
    {
        //set valid text field to green
        validField.backgroundColor = UIColor.greenColor()
        validPhone = true
        validEmail = true
    }
    
    @IBAction func submitTapped(sender: AnyObject)
    {
        validator.validateFieldByKey(Fields[0], delegate:self)
        validator.validateFieldByKey(Fields[1], delegate:self)
        
        if validEmail == true && validPhone == true{
            var dicContact: NSDictionary?

            if keyType == "Plist file"{
                dicContact = ["name":tfName.text, "phone":tfPhone.text, "mail":tfEmail.text]
            }else{
                    dicContact = ["name":tfName.text, "phone":tfPhone.text, "email":tfEmail.text]
            }
            
            addNewSuccess = addNewContact(dicContact!)
//            var contact = ContactObj()
//            contact.name = tfName.text
//            contact.phone = tfPhone.text
//            contact.email = tfEmail.text
//            contact.avatar = ""
//            contact.id = ""
//            
//            addNewSuccess = addNewContact(contact)
            
        }
        
    }
    
    func addNewContact (dicContact: NSDictionary) -> Bool{
        if keyType == "NSUserdefault"{
            if checkNew == true{
                if validName(dicContact["name"] as String) {
                    
                    var udContact: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    if (udContact.valueForKey("arrDicContact") != nil){
                        var arrDicContact = udContact.valueForKey("arrDicContact") as [NSDictionary]
                        arrDicContact.append(dicContact)
                        udContact.setValue(arrDicContact, forKey: "arrDicContact")
                        udContact.synchronize()
                        return true
                    }else{
                        var arrDicContact = [dicContact]
                        udContact.setValue(arrDicContact, forKey: "arrDicContact")
                        udContact.synchronize()
                        return true
                    }
                    
                    
                }else{
                    return false
                }
            }else{
                if validName(dicContact["name"] as String) || (dicContact["name"] as? String == selectedName){
                    
                    var udContact: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    if (udContact.valueForKey("arrDicContact") != nil){
                        var arrDicContact = udContact.valueForKey("arrDicContact") as [NSDictionary]
                        
                        for (idx, dic) in enumerate(arrDicContact){
                            if dic.valueForKey("name") as? String == selectedName{
                                arrDicContact[idx] = dicContact
                            }
                        }
                        
                        udContact.setValue(arrDicContact, forKey: "arrDicContact")
                        udContact.synchronize()
                        return true
                    }else{
                        var arrDicContact = [dicContact]
                        udContact.setValue(arrDicContact, forKey: "arrDicContact")
                        udContact.synchronize()
                        return true
                    }
                    
                    
                }else{
                    return false
                }
            }
        }
 
        if keyType == "Plist file"{
        
            if checkNew == true{
                if validName(dicContact["name"] as String) {
                    
                    let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
                    var content = NSMutableArray(contentsOfFile: path)!
                    
                    content.addObject(dicContact)
                    content.writeToFile(path, atomically: true)
                    
                    return true
                    
                }else{
                    return false
                }
                
            }else{
                if validName(dicContact["name"] as String) || (dicContact["name"] as? String == selectedName){
                    
                    let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
                    var content = NSMutableArray(contentsOfFile: path)!
                        for (idx, dic) in enumerate(content){
                            if dic.valueForKey("name") as? String == selectedName{
                                content[idx] = dicContact
                                content.writeToFile(path, atomically: true)
                                return true
                            }
                        }
                }else{
                    return false
                }
            }
        
        }
        
        if keyType == "CoreData"{
            
            if checkNew == true{
                if validName(dicContact["name"] as String) {
                    
                    //1
                    let appDelegate =
                    UIApplication.sharedApplication().delegate as AppDelegate
                    
                    let managedContext = appDelegate.managedObjectContext!
                    
                    //2
                    let entity =  NSEntityDescription.entityForName("Contact",
                        inManagedObjectContext:
                        managedContext)
                    
                    let person = NSManagedObject(entity: entity!,
                        insertIntoManagedObjectContext:managedContext)
                    
                    //3
                    person.setValue(dicContact["name"], forKey: "name")
                    person.setValue(dicContact["phone"], forKey: "phone")
                    person.setValue(dicContact["email"], forKey: "email")
                    //4
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }  
                    //5
//                    people.append(person)
                    
                    return true
                    
                }else{
                    return false
                }
                
            }else{
                if validName(dicContact["name"] as String) || (dicContact["name"] as? String == selectedName){
                    
                    //1
                    let appDelegate =
                    UIApplication.sharedApplication().delegate as AppDelegate
                    
                    let managedContext = appDelegate.managedObjectContext!
                    
                    //        
                    let fetchRequest = NSFetchRequest(entityName: "Contact")
                    
                    var error: NSError?
                    
                    let fetchchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
                    
                    var coreContact  = [NSManagedObject]()
                    
                    if let results = fetchchedResults {
                        coreContact = results
                        println("Core contact \(coreContact)")
                    }else{
                        println("Could not fetch \(error), \(error?.userInfo)")
                    }
                    
                    for dic in coreContact{
                        if dic.valueForKey("name") as? String == selectedName{
                            dic.setValue(dicContact["name"], forKey: "name")
                            dic.setValue(dicContact["phone"], forKey: "phone")
                            dic.setValue(dicContact["email"], forKey: "email")
                            return true
                        }
                    }
                }else{
                    return false
                }
            }
            
        }
        
        if keyType == "SQLlite"{
            
            let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
            let docsDir = dirPaths[0] as String
            
            databasePath = docsDir.stringByAppendingPathComponent(
                "contacts.db")

            
            if checkNew == true{
                if validName(dicContact["name"] as String) {
                    
                    let contactDB = FMDatabase(path: databasePath)
                    
                    if contactDB.open() {
                        
                        let name = dicContact["name"] as String
                        let phone = dicContact["phone"] as String
                        let email = dicContact["email"] as String
                        
                        let insertSQL = "INSERT INTO CONTACTS (name, phone, email) VALUES ('\(name)', '\(phone)', '\(email)')"
                        
                        let result = contactDB.executeUpdate(insertSQL,
                            withArgumentsInArray: nil)
                        
                        if !result {
                            println("Error: \(contactDB.lastErrorMessage())")
                        }
                        contactDB.close()
                        
                    } else {
                        println("Error: \(contactDB.lastErrorMessage())")
                    }
                    return true
                    
                }else{
                    return false
                }
                
            }else{
                if validName(dicContact["name"] as String) || (dicContact["name"] as? String == selectedName){
                    
                    let name1 = dicContact["name"] as String
                    let phone1 = dicContact["phone"] as String
                    let email1 = dicContact["email"] as String
                    
                    let contactDB = FMDatabase(path: databasePath)
                    
                    if contactDB.open() {
                        
                        let updateSQL = "UPDATE CONTACTS SET name = '\(name1)', phone = '\(phone1)', email = '\(email1)' WHERE name = 'b'"
                        
                        let result = contactDB.executeUpdate(updateSQL, withArgumentsInArray: nil)
                        
                        if !result {
                            println("Error: \(contactDB.lastErrorMessage())")
                        }
                        contactDB.close()
                    
                    } else {
                        println("Error: \(contactDB.lastErrorMessage())")
                    }
                    return true
                
                }else{
                    return false
                }
            }
            
        }


        
        return false
        
    }
    
//    func addNewContact (contact: ContactObj) -> Bool{
//        
//        
//        if validName(contact.name) {
//            
//            var udContact: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//            if (udContact.valueForKey("arrObjContact") != nil){
//                var arrObjContact = udContact.valueForKey("arrObjContact") as [ContactObj]
//                arrObjContact.append(contact)
//                udContact.setValue(arrObjContact, forKey: "arrObjContact")
//                udContact.synchronize()
//                return true
//            }else{
//                var arrObjContact = [contact]
//                udContact.setObject(arrObjContact, forKey: "arrObjContact")
//                udContact.synchronize()
//                return true
//            }
//            
//            
//        }else{
//            return false
//        }
//        
//    }


    func validName(name:String) -> Bool{
        
        if keyType == "NSUserdefault"{
        
            var udContact: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if (udContact.valueForKey("arrDicContact") != nil){
                var arrDicContact = udContact.valueForKey("arrDicContact") as NSArray
                
                var arrName = []
                var dic: NSDictionary
                for dic in arrDicContact {
                    var name1 = dic["name"] as String
                    if name == name1{
                        
                        self.validName = false
                        return false
                    }
                }
            }
            
            self.validName = true
            return true
        
        }
        
        if keyType == "Plist file"{
            
            let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
            var content = NSArray(contentsOfFile: path)
            
            if (content != nil){
                for (idx, dic) in enumerate(content!){
                    var name1 = dic.valueForKey("name") as String
                    if name == name1{
                        self.validName = false
                        return false
                    }
                }
            }
            
            self.validName = true
            return true
        
        }
        
        if keyType == "CoreData"{
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let fetchRequest = NSFetchRequest(entityName: "Contact")
            
            var error: NSError?
            
            let fetchchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
            
            if let results = fetchchedResults {
                var coreContact = results
                println("Core contact \(coreContact)")
            }else{
                println("Could not fetch \(error), \(error?.userInfo)")
            }
            
            if (fetchchedResults != nil){
                for (idx, dic) in enumerate(fetchchedResults!){
                    var name1 = dic.valueForKey("name") as String
                    if name == name1{
                        self.validName = false
                        return false
                    }
                }
            }
            
            self.validName = true
            return true
            
        }
        
        if keyType == "SQLlite"{
            
            let contactDB = FMDatabase(path: databasePath)
            
            if contactDB.open() {
                let querySQL = "SELECT name FROM CONTACTS WHERE name = '\(name)'"
                
                let results:FMResultSet? = contactDB.executeQuery(querySQL,
                    withArgumentsInArray: nil)
            
                var flag = true
                while results?.next() == true{
                    if results?.stringForColumn("name") == name{
                        flag = false
                        break
                    }
                }
                
                if (results != nil && flag == false){
                        self.validName = false
                        return false
                }
                contactDB.close()
            }
            
            self.validName = true
            return true
            
        }


        
        return false
        
    }
    
    override func shouldPerformSegueWithIdentifier(segue: String?, sender: AnyObject?) -> Bool{
        if segue == "segueSave"{
            submitTapped(self)
            if addNewSuccess{
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let contactVC = segue.destinationViewController as ContactVC
        contactVC.keyType = keyType
        println("\(contactVC.keyType)")
    }
    
}
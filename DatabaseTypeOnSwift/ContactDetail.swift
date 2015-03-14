//
//  ContactDetail.swift
//  DatabaseTypeOnSwift
//
//  Created by Yosemite on 1/22/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import Foundation
import UIKit

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
            if keyType == "NSUserdefault"{
                dicContact = ["name":tfName.text, "phone":tfPhone.text, "email":tfEmail.text]
            }
            if keyType == "Plist file"{
                dicContact = ["name":tfName.text, "phone":tfPhone.text, "mail":tfEmail.text]
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
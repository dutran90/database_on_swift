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
            var dicContact = ["name":tfName.text, "phone":tfPhone.text, "email":tfEmail.text]
            addNewSuccess = addNewContact(dicContact)
        }
        
    }
    
    func addNewContact (dicContact: NSDictionary) -> Bool{
        
        
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
        
    }

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
        
        return false
        
    }
    
    override func shouldPerformSegueWithIdentifier(segue: String?, sender: AnyObject?) -> Bool{
        if segue == "segueAddNew"{
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
}
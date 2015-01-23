//
//  PhoneValidation.swift
//  Pingo
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//

import Foundation

class PhoneNumberValidation: Validation {
    let PHONE_REGEX = "[0-9]{10,11}"
    
    func validate(value: String) -> (Bool, ValidationErrorType) {
        if let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX) {
            if phoneTest.evaluateWithObject(value) {
                return (true, .NoError)
            }
            return (false, .PhoneNumber)
        }
        return (false, .PhoneNumber)
    }
    
}

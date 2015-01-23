//
//  Validation.swift
//  Pingo
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//

import Foundation

protocol Validation {
    func validate(value:String) -> (Bool, ValidationErrorType)
}
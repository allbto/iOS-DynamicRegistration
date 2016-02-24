//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Allan Barbato on 09.02.16.
//  Copyright © 2016 Allan Barbato. All rights reserved.
//

import Foundation
import PromiseKit
import Swiftility

class FakeAPIService
{
    static let sharedInstance = FakeAPIService()
    
    func validateCreditCardNumber(number: String) -> Promise<Bool>
    {
        return Promise { resolve, reject in
            
            after(2) {
                resolve(number == "123456")
            }
            
        }
    }
}

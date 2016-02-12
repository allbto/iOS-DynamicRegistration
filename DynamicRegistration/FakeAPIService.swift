//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Allan Barbato on 09.02.16.
//  Copyright © 2016 Allan Barbato. All rights reserved.
//

import Foundation
import PromiseKit

public func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class FakeAPIService {

    static let sharedInstance = FakeAPIService()
    
    func validateCreditCardNumber(number: String) -> Promise<Bool>
    {
        return Promise { resolve, reject in
            
            delay(2) {
                resolve(number == "123456")
            }
            
        }
    }
    
}

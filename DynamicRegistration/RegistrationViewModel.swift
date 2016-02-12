//
//  RegistrationViewModel.swift
//  ReactiveRegistration
//
//  Allan Barbato on 09.02.16.
//  Copyright © 2016 Allan Barbato. All rights reserved.
//

import Swiftility

struct RegistrationForm
{
    var email = String()
    var password = String()
    var passwordAgain =  String()
    
    var isEmailValid: Bool {
        return email.isValidEmail()
    }
    
    var isPasswordValid: Bool {
        return (password.characters.count > 5) && (password == passwordAgain)
    }
}

struct CreditCard
{
    enum Status {
        case NotVerified
        case Verifying
        case Verified
        case Denied
    }

    var useCard = true
    var status: Status = .NotVerified

    var number = String() {
        didSet {
            if status == .Verified {
                status = .NotVerified
            }
        }
    }
    
    var isValid: Bool {
        return !useCard || status == .Verified
    }
}

class RegistrationViewModel
{
    var form = Dynamic(RegistrationForm()) {
        didSet { checkCorrectInput() }
    }

    var creditCard = Dynamic(CreditCard()) {
        didSet { checkCorrectInput() }
    }
    
    var correctEmail = Dynamic<Bool>(false)
    var correctPassword = Dynamic<Bool>(false)
    var correctCreditCard = Dynamic<Bool>(false)
    var correctInput = Dynamic<Bool>(false)
    
    func verifyCardNumber()
    {
        creditCard.value.status = .Verifying
        
        FakeAPIService.sharedInstance.validateCreditCardNumber(creditCard.value.number)
        .then { valid -> Void in
            self.creditCard.value.status = valid ? .Verified : .Denied
        }
    }
    
    func createSummaryViewModel() -> SummaryViewModel
    {
        let summaryViewModel = SummaryViewModel()
        summaryViewModel.email = form.value.email
        summaryViewModel.creditCardNumber = creditCard.value.useCard ? creditCard.value.number : nil
        
        return summaryViewModel
    }
    
    func checkCorrectInput()
    {
        correctEmail.value = form.value.isEmailValid
        correctPassword.value = form.value.isPasswordValid
        correctCreditCard.value = creditCard.value.isValid
        
        correctInput.value = correctEmail.value && correctPassword.value && correctCreditCard.value
    }
}

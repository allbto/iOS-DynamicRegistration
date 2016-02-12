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
    var number = String()
    
    var isValid: Bool {
        return !useCard || status == .Verified
    }
}

class RegistrationViewModel
{
    var form = Dynamic(RegistrationForm()) {
        didSet { checkCorrectInput() }
    }

    var creditCard = Dynamic(CreditCard())
    
    var correctEmailProducer = Dynamic<Bool>(false)
    var correctPasswordProducer = Dynamic<Bool>(false)
    var correctCreditCardProducer = Dynamic<Bool>(false)
    var correctInputProducer = Dynamic<Bool>(false)
    
    func verifyCardNumber()
    {
        creditCard.value.status = .Verifying
        
        FakeAPIService.sharedInstance.validateCreditCardNumber(creditCard.value.number)
        .then { valid -> Void in
            self.creditCard.value.status = valid ? .Verified : .Denied
            self.checkCorrectInput()
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
        correctEmailProducer.value = form.value.isEmailValid
        correctPasswordProducer.value = form.value.isPasswordValid

        correctCreditCardProducer.value = creditCard.value.isValid
        
        correctInputProducer.value = correctEmailProducer.value && correctPasswordProducer.value && correctCreditCardProducer.value
    }
}

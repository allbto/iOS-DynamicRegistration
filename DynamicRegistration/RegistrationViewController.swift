//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Allan Barbato on 09.02.16.
//  Copyright © 2016 Allan Barbato. All rights reserved.
//

import UIKit

class RegistrationViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var useCreditCardSwitch: UISwitch!
    @IBOutlet weak var creditCardTextField: UITextField!
    @IBOutlet weak var cardStatusLabel: UILabel!
    @IBOutlet weak var verifyCardButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    lazy var viewModel: RegistrationViewModel! = {
        let vm = RegistrationViewModel()
        
        vm.correctInput.bindAndFire { correct in
            self.registerButton.enabled = correct
        }
        
        vm.correctEmail.bindAndFire { correct in
            let backgroundColor = correct ? UIColor.lightGrayColor() : UIColor.redColor()
            self.emailTextField.textColor = backgroundColor
        }
        
        vm.correctPassword.bindAndFire { correct in
            let backgroundColor = correct ? UIColor.lightGrayColor() : UIColor.redColor()
            self.passwordTextField.textColor = backgroundColor
            self.passwordAgainTextField.textColor = backgroundColor
        }
        
        vm.creditCard.bindAndFire { card in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            switch card.status {
                
            case .NotVerified:
                self.cardStatusLabel.text = "Card has not been verified yet"
                self.cardStatusLabel.textColor = .lightGrayColor()
                self.activityIndicator.hidden = true
                self.verifyCardButton.hidden = false
                
            case .Verifying:
                self.cardStatusLabel.text = "Card is currently being verified"
                self.cardStatusLabel.textColor = .lightGrayColor()
                self.activityIndicator.hidden = false
                self.verifyCardButton.hidden = true
                
            case .Verified:
                self.cardStatusLabel.text = "Card is verified"
                self.cardStatusLabel.textColor = .greenColor()
                self.creditCardTextField.resignFirstResponder()
                self.activityIndicator.hidden = true
                self.verifyCardButton.hidden = true
                
            case .Denied:
                self.cardStatusLabel.text = "Card is denied"
                self.cardStatusLabel.textColor = .redColor()
                self.activityIndicator.hidden = true
                self.verifyCardButton.hidden = false
                
            }
        }
        
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel
    }
    
    // MARK: - Actions
    
    @IBAction func inputChangedAction(sender: AnyObject)
    {
        guard let sender = sender as? UITextField else { return }
        let text = sender.text ?? ""
        
        switch sender {
        case emailTextField:
            viewModel.form.value.email = text
        case passwordTextField:
            viewModel.form.value.password = text
        case passwordAgainTextField:
            viewModel.form.value.passwordAgain = text
        case creditCardTextField:
            viewModel.creditCard.value.number = text
        default: break
        }
    }
    
    
    @IBAction func useCreditCardValueChangedAction(sender: AnyObject)
    {
        viewModel.creditCard.value.useCard = useCreditCardSwitch.on
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - TableView
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 4) || (indexPath.row == 5) {
            if viewModel.creditCard.value.useCard {
                return 44
            }
            else {
                return 0
            }
        }
        
        return 44
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "ShowSummary" {
            let summaryController = segue.destinationViewController as! SummaryViewController
            summaryController.viewModel = viewModel.createSummaryViewModel()
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    @IBAction func showSummary(sender: AnyObject) {
        performSegueWithIdentifier("ShowSummary", sender: self)
    }

    @IBAction func verifyCardNumber(sender: AnyObject) {
        viewModel.verifyCardNumber()
    }
}

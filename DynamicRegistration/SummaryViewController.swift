//
//  SummaryViewController.swift
//  ReactiveRegistration
//
//  Allan Barbato on 09.02.16.
//  Copyright © 2016 Allan Barbato. All rights reserved.
//

import UIKit
import Swiftility

class SummaryViewController: UIViewController, ViewModelController
{
    // MARK: - Outlets
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var creditCardNumberLabel: UILabel!
    
    // MARK: - View Model
    
    var viewModel: SummaryViewModel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailLabel.text = viewModel.email
        creditCardNumberLabel.text = viewModel.creditCardNumber ?? "<N/A>"
    }
}

//
//  PassportViewController.swift
//  PassportScannerUA
//
//  Created by Aleksandr Saliienko on 1/22/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//

import UIKit
import QKMRZScanner

class PassportViewController: UIViewController {
    
    var model: QKMRZScanResult?
    
    @IBOutlet weak var passportImage: UIImageView!
    
    @IBOutlet weak var documentType: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var documentNumber: UILabel!
    @IBOutlet weak var nationality: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var personalNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let passport = model else { return }
        let dateFormatter = DateFormatter()
              dateFormatter.dateStyle = .medium
        
        documentType.text = passport.documentType
        countryCode.text = passport.countryCode
        firstName.text = passport.surnames
        lastName.text = passport.givenNames
        documentNumber.text = passport.documentNumber
        nationality.text = passport.nationality
        birthDate.text = dateFormatter.string(from: passport.birthDate!)
        sex.text = passport.sex
        expiryDate.text = dateFormatter.string(from: passport.expiryDate!)
        personalNumber.text = passport.personalNumber
        passportImage.image = passport.documentImage
    }
}

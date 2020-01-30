//
//  ResultViewController.swift
//  PassportScannerUA
//
//  Created by Aleksandr Saliienko on 1/21/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//

import UIKit
import QKMRZScanner
import NFCPassportReader

class ResultViewController: UIViewController {
    
    var scanResult: QKMRZScanResult?
    var passportDetails: PassportDetails!
    private let passportReader = PassportReader()
    private var segmentedControlPages: Array<UIViewController>!

    @IBOutlet private weak var faceImage: UIImageView!
    @IBOutlet private weak var varificationImage: UIImageView!
    @IBOutlet private weak var varificationLabel: UILabel!
    @IBOutlet private weak var varificationView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        setupSegmentedPages()
        configureUI()
    }
    
    private func configureUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        varificationView.isHidden = true
        
        faceImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        faceImage.addGestureRecognizer(tapGesture)
        
        let segmentedInitialView =  segmentedControlPages[segmentedControl.selectedSegmentIndex]
        contentView.addSubview(segmentedInitialView.view)
    }
    
    private func setupModel() {
        guard let result = scanResult else { return }
        let dateFormatterForMRZ = DateFormatter()
        dateFormatterForMRZ.dateFormat = "yyMMdd"
        
        passportDetails = PassportDetails(passportNumber: result.documentNumber + "<",
                                          dateOfBirth: dateFormatterForMRZ.string(from: result.birthDate!),
                                          expiryDate: dateFormatterForMRZ.string(from: result.expiryDate!))
        faceImage.image = result.faceImage
    }
    
    private func setupSegmentedPages() {
        let passportVC = PassportViewController()
        passportVC.model = scanResult
        segmentedControlPages = [passportVC]
    }
    
    @objc func tappedImage() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let imageController: PassportImageViewController = storyboard.instantiateViewController(withIdentifier: "PassportImageViewController") as! PassportImageViewController
        imageController.image = passportDetails.passport?.passportImage
        self.show(imageController, sender: nil)
    }
    
    @IBAction func segmentedControlDidChanged(_ sender: UISegmentedControl) {
        var view: UIView
        if segmentedControlPages.count == 1 && segmentedControl.selectedSegmentIndex == 1 {
            view = UIView()
        } else {
            view = segmentedControlPages[sender.selectedSegmentIndex].view
        }
        contentView.subviews.last?.removeFromSuperview()
        contentView.addSubview(view)
    }
    
    
    @IBAction func scanNFC(_ sender: UIBarButtonItem) {
        let mrzKey = passportDetails.getMRZKey()

        // Set the masterListURL on the Passport Reader to allow auto passport verification
        let masterListURL = Bundle.main.url(forResource: "masterList", withExtension: ".pem")!
        passportReader.setMasterListURL( masterListURL )

        // If we want to read only specific data groups we can using:
       let dataGroups : [DataGroupId] = [.COM, .SOD, .DG1, .DG2, .DG7, .DG14]
        passportReader.readPassport(mrzKey: mrzKey, tags:dataGroups, completed: { (passport, error) in
            guard let passport = passport else { return }
            self.passportDetails.passport = passport
            DispatchQueue.main.async {
                let passportVC = PassportDetailsViewController()
                passportVC.model = self.passportDetails
                passportVC.view.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
                self.segmentedControlPages.append(passportVC)
                self.varificationView.isHidden = false
                self.faceImage.image = passport.passportImage
                let isVerified = passport.passportCorrectlySigned && passport.documentSigningCertificateVerified
                self.showVerificationIcon(isVerified: isVerified)
            }
        })

    }
    
    private func showVerificationIcon(isVerified: Bool) {
        switch isVerified {
        case true:
            self.varificationImage.image = UIImage(systemName: "checkmark.seal")?.withRenderingMode(.alwaysTemplate)
            self.varificationImage.tintColor = UIColor.green
            self.varificationLabel.textColor = UIColor.green
            self.varificationLabel.text = "Genuine"
        case false:
            self.varificationImage.image = UIImage(systemName: "xmark.seal")?.withRenderingMode(.alwaysTemplate)
            self.varificationImage.tintColor = UIColor.red
            self.varificationLabel.textColor = UIColor.red
            self.varificationLabel.text = "Not Genuine"
        }
    }
}

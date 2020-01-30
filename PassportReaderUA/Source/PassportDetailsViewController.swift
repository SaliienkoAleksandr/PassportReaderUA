//
//  PassportDetailsViewController.swift
//  PassportScannerUA
//
//  Created by Aleksandr Saliienko on 1/22/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//

import UIKit
import NFCPassportReader

struct Item {
    var id = UUID()
    var title : String
    var value : String
}

class PassportDetailsViewController: UITableViewController {
    
    var model: PassportDetails?
    
    private var sectionNames = ["Chip information", "Verification information", "Document signing certificate", "Country signing certificate", "Datagroup Hashes"]
    private var sections = [[Item]]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.register(UINib(nibName: DetailsCell.identifier, bundle: nil), forCellReuseIdentifier: DetailsCell.identifier)
        configure()
    }
    
    private func configure() {
        guard let passport = model?.passport else { return }
        sections.append(getChipInfoSection(passport))
        sections.append(getVerificationDetailsSection(passport))
        sections.append(getCertificateSigningCertDetails(certItems:passport.documentSigningCertificate?.getItemsAsDict()))
        sections.append(getCertificateSigningCertDetails(certItems:passport.countrySigningCertificate?.getItemsAsDict()))
        sections.append(getDataGroupHashesSection(passport))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier) as! DetailsCell
        let item = sections[indexPath.section][indexPath.row]
        cell.title.text = item.title
        cell.value.text = item.value
        return cell
    }
    
    func getChipInfoSection(_ passport: NFCPassportModel) -> [Item] {
           // Build Chip info section
           let chipInfo = [Item(title:"LDS Version", value: passport.LDSVersion),
                           Item(title:"Data groups present", value: passport.dataGroupsPresent.joined(separator: ", ")),
                           Item(title:"Data groups read", value: passport.dataGroupsAvailable.map { $0.getName()}.joined(separator: ", "))]

           return chipInfo
       }
       
       func getVerificationDetailsSection(_ passport: NFCPassportModel) -> [Item] {
           // Build Verification Info section
           var aa : String = "Not supported"
           if passport.activeAuthenticationSupported {
               aa = passport.activeAuthenticationPassed ? "SUCCESS\nSignature verified" : "FAILED\nCould not verify signature"
           }

           let verificationDetails : [Item] = [
               Item(title: "Access Control", value: "BAC"),
               Item(title: "Active Authentication", value: aa),
               Item(title: "Document Signing Certificate", value: passport.documentSigningCertificateVerified ? "SUCCESS\nSOD Signature verified" : "FAILED\nCouldn't verify SOD signature"),
               Item(title: "Country signing Certificate", value: passport.passportCorrectlySigned ? "SUCCESS\nmatched to country signing certificate" : "FAILED\nCouldn't build trust chain"),
               Item(title: "Data group hashes", value: passport.passportDataNotTampered ? "SUCCESS\nAll hashes match" : "FAILED\nCouldn't match hashes" )
           ]

           return verificationDetails
       }
       
       func getCertificateSigningCertDetails( certItems : [CertificateItem : String]? ) -> [Item] {
           let titles : [String] = ["Serial number", "Signature algorithm", "Public key algorithm", "Certificate fingerprint", "Issuer", "Subject", "Valid from", "Valid to"]

           var items = [Item]()
           if certItems?.count ?? 0  == 0 {
               items.append( Item(title:"Certificate details", value: "NOT FOUND" ) )
           } else {
               for title in titles {
                   let ci = CertificateItem(rawValue:title)!
                   items.append( Item(title:title, value: certItems?[ci] ?? "") )
               }
           }
           return items
       }

       func getDataGroupHashesSection(_ passport: NFCPassportModel) -> [Item] {
           var dgHashes = [Item]()
           for id in DataGroupId.allCases {
               if let hash = passport.dataGroupHashes[id] {
                   dgHashes.append( Item(title:hash.id, value:hash.match ? "MATCHED" : "UNMATCHED"))
                   dgHashes.append( Item(title:"SOD Hash", value: hash.sodHash))
                   dgHashes.append( Item(title:"Computed Hash", value: hash.computedHash))
               }
           }
           return dgHashes
       }
}

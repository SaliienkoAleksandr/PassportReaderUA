//
//  Scan.swift
//  PassportReaderUA
//
//  Created by Aleksandr Saliienko on 1/30/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//
import UIKit

public func scan(viewController: UIViewController) {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let scanVC: MyScanViewController = storyboard.instantiateViewController(withIdentifier: "PassportScanner") as! MyScanViewController
    viewController.show(scanVC, sender: nil)
}

//
//  MyScanViewController.swift
//  PassportScannerUA
//
//  Created by Aleksandr Saliienko on 1/20/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//

import QKMRZScanner

import UIKit

class MyScanViewController: UIViewController {
    
    @IBOutlet weak var mrzScannerView: QKMRZScannerView!
    
    override func viewDidLoad() {
        mrzScannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mrzScannerView.startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if mrzScannerView.isScanning {
            mrzScannerView.stopScanning()
        }
    }
}

extension MyScanViewController: QKMRZScannerViewDelegate {
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
        mrzScannerView.stopScanning()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "ResultViewController") as! ResultViewController
        controller.scanResult = scanResult
        show(controller, sender: nil)
    }
}

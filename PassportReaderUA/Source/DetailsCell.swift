//
//  DetailsCell.swift
//  PassportScannerUA
//
//  Created by Aleksandr Saliienko on 1/22/20.
//  Copyright © 2020 Aleksandr Saliienko. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    static let identifier = "DetailsCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

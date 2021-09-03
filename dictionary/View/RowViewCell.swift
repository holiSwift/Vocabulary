//
//  RowViewCell.swift
//  dictionary
//
//  Created by Виталий Орехов on 6.08.21.
//

import UIKit

class RowViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var row: UIView!
    @IBOutlet weak var translate: UILabel!
    @IBOutlet weak var word: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        row.transform = CGAffineTransform(scaleX: 1, y: -1)
        row.layer.borderWidth = 1
        row.layer.borderColor = UIColor(red:50/55, green:225/255, blue:227/255, alpha: 1).cgColor
        row.layer.cornerRadius = 5
        word.adjustsFontSizeToFitWidth = true
        translate.adjustsFontSizeToFitWidth = true

    }

}

//
//  MessageCellReverb.swift
//  dictionary
//
//  Created by Виталий Орехов on 2.08.21.
//

import UIKit

class MessageCellReverb: UITableViewCell {

    @IBOutlet weak var row: UIView!
    @IBOutlet weak var translate: UIButton!
    @IBOutlet weak var word: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        row.transform = CGAffineTransform(scaleX: 1, y: -1)
        row.layer.borderWidth = 1
        row.layer.borderColor = UIColor(red:50/55, green:225/255, blue:227/255, alpha: 1).cgColor
        row.layer.cornerRadius = 5
    }

//    @IBAction func translateBtn(_ sender: Any) {
//        print("translate")
//    }
//
//    @IBAction func word(_ sender: Any) {
//        print("word")
//    }
    
}

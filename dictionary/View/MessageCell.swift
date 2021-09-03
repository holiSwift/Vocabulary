//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 24/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var listRow: UIView!
    @IBOutlet weak var word: UIButton!
    @IBOutlet weak var translate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        listRow.transform = CGAffineTransform(scaleX: 1, y: -1)
        listRow.layer.borderWidth = 1
        listRow.layer.borderColor = UIColor(red:50/55, green:225/255, blue:227/255, alpha: 1).cgColor
        listRow.layer.cornerRadius = 5

    }
    
    @IBAction func wordBtn(_ sender: Any) {
        print("word")
    }
    
    
    }

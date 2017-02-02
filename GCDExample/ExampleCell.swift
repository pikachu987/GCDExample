//
//  ExampleCell.swift
//  GCDExample
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

protocol ExampleDelegate {
    func exampleAction(_ cell: ExampleCell)
}

class ExampleCell: UITableViewCell {
    var delegate: ExampleDelegate?
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnAction(_ sender: Any) {
        self.delegate?.exampleAction(self)
    }
    
}
